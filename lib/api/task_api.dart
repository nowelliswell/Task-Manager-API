import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'dart:convert';
import '../services/database_service.dart';
import '../services/jwt_service.dart';

class TaskApi {
  final db = DatabaseService().db;
  final jwt = JwtService();

  // Helper method untuk mendapatkan user_id dari JWT
  Future<int?> _getUserId(Request req) async {
    final user = req.context['user'];
    if (user is! Map<String, dynamic>) {
      return null;
    }
    final userMap = user;
    final email = userMap['email'];

    final userResult = db.select('SELECT id FROM users WHERE email = ?', [
      email,
    ]);
    if (userResult.isEmpty) {
      return null;
    }
    return userResult.first['id'];
  }

  // Middleware untuk authentication
  Handler authMiddleware(Handler handler) {
    return (Request request) {
      final authHeader = request.headers['authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response(
          401,
          body: jsonEncode({'error': 'Token tidak ditemukan'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final token = authHeader.substring(7); // Remove 'Bearer '
      try {
        final payload = jwt.verifyToken(token);
        // Tambahkan user info ke request context
        final newRequest = request.change(context: {'user': payload});
        return handler(newRequest);
      } catch (e) {
        return Response(
          401,
          body: jsonEncode({'error': 'Token tidak valid'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    };
  }

  Router get router {
    final router = Router();

    // GET /tasks - Get tasks for authenticated user
    router.get(
      '/',
      (Request req) => authMiddleware((Request req) async {
        final userId = await _getUserId(req);
        if (userId == null) {
          return Response(
            401,
            body: jsonEncode({'error': 'User tidak ditemukan'}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // Ambil tasks milik user
        final taskResult = db.select(
          'SELECT id, title, description, is_completed FROM tasks WHERE user_id = ?',
          [userId],
        );
        final tasks = taskResult
            .map(
              (row) => {
                'id': row['id'],
                'title': row['title'],
                'description': row['description'],
                'completed': row['is_completed'] == 1,
              },
            )
            .toList();

        return Response.ok(
          jsonEncode(tasks),
          headers: {'Content-Type': 'application/json'},
        );
      })(req),
    );

    // POST /tasks - Create new task for authenticated user
    router.post(
      '/',
      (Request req) => authMiddleware((Request req) async {
        final userId = await _getUserId(req);
        if (userId == null) {
          return Response(
            401,
            body: jsonEncode({'error': 'User tidak ditemukan'}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        final body = jsonDecode(await req.readAsString());
        final title = body['title']?.toString();
        final description = body['description']?.toString();

        if (title == null || title.isEmpty) {
          return Response(
            400,
            body: jsonEncode({'error': 'Title wajib diisi'}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // Simpan ke database
        db.execute(
          'INSERT INTO tasks (title, description, is_completed, user_id) VALUES (?, ?, ?, ?)',
          [title, description, 0, userId],
        );

        return Response.ok(
          jsonEncode({'message': 'Task berhasil ditambahkan'}),
          headers: {'Content-Type': 'application/json'},
        );
      })(req),
    );

    router.put(
      '/<id>',
      (Request req, String id) => authMiddleware((Request req) async {
        final userId = await _getUserId(req);
        if (userId == null) {
          return Response(
            401,
            body: jsonEncode({'error': 'User tidak ditemukan'}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        int taskId;
        try {
          taskId = int.parse(id);
        } catch (e) {
          return Response(
            400,
            body: jsonEncode({'error': 'ID task tidak valid'}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // Pastikan task milik user yang login
        final taskResult = db.select(
          'SELECT id FROM tasks WHERE id = ? AND user_id = ?',
          [taskId, userId],
        );
        if (taskResult.isEmpty) {
          return Response(
            404,
            body: jsonEncode({
              'error': 'Task tidak ditemukan atau bukan milik Anda',
            }),
            headers: {'Content-Type': 'application/json'},
          );
        }

        final body = jsonDecode(await req.readAsString());
        final completed = body['completed'];
        if (completed == null || completed is! bool) {
          return Response(
            400,
            body: jsonEncode({'error': 'Field completed harus berupa boolean'}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        db.execute(
          'UPDATE tasks SET is_completed = ? WHERE id = ? AND user_id = ?',
          [completed ? 1 : 0, taskId, userId],
        );
        return Response.ok(
          jsonEncode({'message': 'Task diperbarui'}),
          headers: {'Content-Type': 'application/json'},
        );
      })(req),
    );

    router.delete(
      '/<id>',
      (Request req, String id) => authMiddleware((Request req) async {
        final userId = await _getUserId(req);
        if (userId == null) {
          return Response(
            401,
            body: jsonEncode({'error': 'User tidak ditemukan'}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        int taskId;
        try {
          taskId = int.parse(id);
        } catch (e) {
          return Response(
            400,
            body: jsonEncode({'error': 'ID task tidak valid'}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // Pastikan task milik user yang login
        final taskResult = db.select(
          'SELECT id FROM tasks WHERE id = ? AND user_id = ?',
          [taskId, userId],
        );
        if (taskResult.isEmpty) {
          return Response(
            404,
            body: jsonEncode({
              'error': 'Task tidak ditemukan atau bukan milik Anda',
            }),
            headers: {'Content-Type': 'application/json'},
          );
        }

        db.execute('DELETE FROM tasks WHERE id = ? AND user_id = ?', [
          taskId,
          userId,
        ]);
        return Response.ok(
          jsonEncode({'message': 'Task dihapus'}),
          headers: {'Content-Type': 'application/json'},
        );
      })(req),
    );

    router.all('/<ignored|.*>', (Request req) {
      print('🚦 Tidak ada route untuk ${req.url}');
      return Response.notFound('Route tidak ditemukan');
    });

    return router;
  }
}
