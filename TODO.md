# TODO List for Fixing Dart Task API Code

- [x] Update pubspec.yaml: Add sqlite3 and dart_jsonwebtoken dependencies
- [x] Fix jwt_service.dart: Correct syntax errors (final_secret to final _secret, string to String)
- [x] Fix database_service.dart: Replace sqflite import with sqlite3, define _database properly
- [x] Implement task_api.dart: Add database operations for tasks (get, create, update, delete)
- [x] Fix auth_api.dart: Ensure db access works with updated DatabaseService
- [ ] Run 'dart pub get' to install dependencies
- [ ] Test server functionality
- [x] Fix GET /tasks route in task_api.dart: Implement proper handler with authentication and user-specific task retrieval
- [x] Fix POST / route in task_api.dart: Add authentication and insert task with user_id
- [ ] Verify PUT and DELETE routes in task_api.dart are working correctly
- [ ] Run server and test GET tasks endpoint
