import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'dart:io';

class JwtService {
  final String _secret = Platform.environment['JWT_SECRET'] ?? 'supersecretkey';

  String generateToken(String email) {
    final jwt = JWT({'email': email});
    return jwt.sign(SecretKey(_secret), expiresIn: Duration(hours: 2));
  }

  dynamic verifyToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(_secret));
      return jwt.payload;
    } catch (e) {
      return false;
    }
  }
}
