import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:dart_task_api/api/auth_api.dart';
import 'package:dart_task_api/api/task_api.dart';

void main() async {
  final router = Router();

  // Tambahkan route dari API
  final authApi = AuthApi();
  final taskApi = TaskApi();

  router.mount('/auth/', authApi.router.call);
  router.mount('/tasks/', taskApi.router.call);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  final server = await io.serve(handler, 'localhost', 8081);
  print('✅ Server berjalan di http://${server.address.host}:${server.port}');
}
