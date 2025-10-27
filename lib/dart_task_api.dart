import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Router getRouter() {
  final router = Router();

  router.get('/hello', (Request request) {
    return Response.ok('Hello, World!');
  });

  router.get('/calculate', (Request request) {
    final result = 6 * 7;
    return Response.ok('Result: $result');
  });

  return router;
}
