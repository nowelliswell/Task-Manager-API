import 'package:dart_task_api/dart_task_api.dart';
import 'package:test/test.dart';

void main() {
  test('router', () {
    final router = getRouter();
    expect(router, isNotNull);
  });
}
