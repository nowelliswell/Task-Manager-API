import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import '../lib/api/auth_api.dart';
import '../lib/api/task_api.dart';

void main() async {
  final router = Router();

  // Tambahkan route dari API
  final authApi = AuthApi();
  final taskApi = TaskApi();

  router.mount('/auth/', authApi.router);
  router.mount('/tasks/', taskApi.router);

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  final server = await io.serve(handler, 'localhost', 8080);
  print('✅ Server berjalan di http://${server.address.host}:${server.port}');
}
