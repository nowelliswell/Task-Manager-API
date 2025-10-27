import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'dart:convert';
import '../services/database_service.dart';
import '../services/jwt_service.dart';

class TaskApi {
  final db = DatabaseService().db;
  final jwt = JwtService();

  Router get router {
    final router = Router();

    router.get('/', (Request req) {
      final tasks = db.select('SELECT * FROM tasks');
      return Response.ok(
        jsonEncode(tasks),
        headers: {'Content-Type': 'application/json'},
      );
    });

    router.post('/', (Request req) async {
      final body = jsonDecode(await req.readAsString());
      db.execute(
        'INSERT INTO tasks (title, description, completed, user_id) VALUES (?, ?, ?, ?)',
        [body['title'], body['description'], 0, 1],
      );
      return Response.ok('Task ditambahkan');
    });

    router.put('/<id>', (Request req, String id) async {
      final body = jsonDecode(await req.readAsString());
      db.execute('UPDATE tasks SET completed = ? WHERE id = ?', [
        body['completed'] ? 1 : 0,
        int.parse(id),
      ]);
      return Response.ok('Task diperbarui');
    });

    router.delete('/<id>', (Request req, String id) {
      db.execute('DELETE FROM tasks WHERE id = ?', [int.parse(id)]);
      return Response.ok('Task dihapus');
    });

    return router;
  }
}
