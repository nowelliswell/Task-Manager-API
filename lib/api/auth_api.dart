import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'dart:convert';
import '../services/database_service.dart';
import '../services/jwt_service.dart';

class AuthApi {
  final db = DatabaseService().db;
  final jwt = JwtService();

  Router get router {
    final router = Router();

    router.post('/register', (Request req) async {
      final body = jsonDecode(await req.readAsString());
      try {
        db.execute('INSERT INTO users (username, password) VALUES (?, ?)', [
          body['username'],
          body['password'],
        ]);
        return Response.ok('User terdaftar');
      } catch (e) {
        return Response(400, body: 'Username sudah ada');
      }
    });

    router.post('/login', (Request req) async {
      final body = jsonDecode(await req.readAsString());
      final result = db.select(
        'SELECT * FROM users WHERE username = ? AND password = ?',
        [body['username'], body['password']],
      );
      if (result.isNotEmpty) {
        final token = jwt.generateToken(body['username']);
        return Response.ok(
          jsonEncode({'token': token}),
          headers: {'Content-Type': 'application/json'},
        );
      } else {
        return Response(401, body: 'Username/password salah');
      }
    });

    router.get('/users', (Request req) {
      final result = db.select('SELECT id, username FROM users');
      final users = result
          .map((row) => {'id': row['id'], 'username': row['username']})
          .toList();
      return Response.ok(
        jsonEncode(users),
        headers: {'Content-Type': 'application/json'},
      );
    });

    return router;
  }
}
