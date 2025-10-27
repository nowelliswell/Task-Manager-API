import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'dart:io';

class JwtService {
  final String _secret = Platform.environment['JWT_SECRET'] ?? 'supersecretkey';

  String generateToken(String username) {
    final jwt = JWT({'username': username});
    return jwt.sign(SecretKey(_secret), expiresIn: Duration(hours: 2));
  }

  bool verifyToken(String token) {
    try {
      JWT.verify(token, SecretKey(_secret));
      return true;
    } catch (e) {
      return false;
    }
  }
}
