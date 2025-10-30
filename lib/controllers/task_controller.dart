import 'package:shelf/shelf.dart';
import 'dart:convert';
import '../services/database_service.dart';

class TaskController {
  final db = DatabaseService().db;

  Future<Response> getTasks(Request req) async {
    final result = db.select(
      'SELECT id, title, description, is_completed as completed, user_id FROM tasks',
    );
    final tasks = result
        .map(
          (row) => {
            'id': row['id'],
            'title': row['title'],
            'description': row['description'],
            'completed': row['completed'] == 1,
            'user_id': row['user_id'],
          },
        )
        .toList();
    return Response.ok(
      jsonEncode(tasks),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> createTask(Request req) async {
    final body = jsonDecode(await req.readAsString());
    db.execute(
      'INSERT INTO tasks (title, description, is_completed, user_id) VALUES (?, ?, ?, ?)',
      [body['title'], body['description'], 0, 1],
    );
    return Response.ok('Task ditambahkan');
  }

  Future<Response> updateTask(Request req, String id) async {
    final body = jsonDecode(await req.readAsString());
    db.execute('UPDATE tasks SET is_completed = ? WHERE id = ?', [
      body['completed'] ? 1 : 0,
      int.parse(id),
    ]);
    return Response.ok('Task diperbarui');
  }

  Future<Response> deleteTask(Request req, String id) async {
    db.execute('DELETE FROM tasks WHERE id = ?', [int.parse(id)]);
    return Response.ok('Task dihapus');
  }
}
