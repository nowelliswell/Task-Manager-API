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
        db.execute('INSERT INTO users (email, password) VALUES (?, ?)', [
          body['email'],
          body['password'],
        ]);
        return Response.ok('User terdaftar');
      } catch (e) {
        return Response(400, body: 'Email sudah ada');
      }
    });

    router.post('/login', (Request req) async {
      final body = jsonDecode(await req.readAsString());
      final result = db.select(
        'SELECT * FROM users WHERE email = ? AND password = ?',
        [body['email'], body['password']],
      );
      if (result.isNotEmpty) {
        final token = jwt.generateToken(body['email']);
        return Response.ok(
          jsonEncode({'token': token, 'email': body['email']}),
          headers: {'Content-Type': 'application/json'},
        );
      } else {
        return Response(401, body: 'Email/password salah');
      }
    });

    router.get('/users', (Request req) {
      final result = db.select('SELECT id, email FROM users');
      final users = result
          .map((row) => {'id': row['id'], 'email': row['email']})
          .toList();
      return Response.ok(
        jsonEncode(users),
        headers: {'Content-Type': 'application/json'},
      );
    });

    return router;
  }
}
