import 'package:shelf_router/shelf_router.dart';
import 'package:dart_task_api/controllers/task_controller.dart';

class TaskRouter {
  final _controller = TaskController();

  Router get router {
    final router = Router();

    router.get('/', _controller.getTasks);
    router.post('/', _controller.createTask);
    router.put('/<id>', _controller.updateTask);
    router.delete('/<id>', _controller.deleteTask);

    return router;
  }
}
