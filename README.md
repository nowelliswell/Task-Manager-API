
0. Menjalankan Server

dart run bin/server.dart
Server akan berjalan di http://localhost:8081. Jalankan di terminal terpisah atau background.

1. Register User : 
Invoke-WebRequest -Uri "http://localhost:8081/auth/register" -Method POST -ContentType "application/json" -Body '{"username": "john_doe", "password": "password123"}'

2. Login User : 
Invoke-WebRequest -Uri "http://localhost:8081/auth/login" -Method POST -ContentType "application/json" -Body '{"username": "john_doe", "password": "password123"}'
Simpan token JWT dari response login untuk digunakan di endpoint berikutnya.

3. Lihat Users yang Terdaftar (Get Users) : 
Invoke-WebRequest -Uri "http://localhost:8081/auth/users" -Method GET

4. Lihat Task (Get Tasks) : 
Invoke-WebRequest -Uri "http://localhost:8081/tasks/" -Method GET -Headers @{"Authorization" = "Bearer YOUR_JWT_TOKEN_HERE"}

5. Tambah Task (Create Task) : 
Invoke-WebRequest -Uri "http://localhost:8081/tasks/" -Method POST -Headers @{"Authorization" = "Bearer YOUR_JWT_TOKEN_HERE"; "Content-Type" = "application/json"} -Body '{"title": "Belajar Dart", "description": "Mempelajari bahasa pemrograman Dart"}'

6. Update Task (Mark as Completed/Incomplete) : 
Invoke-WebRequest -Uri "http://localhost:8081/tasks/1" -Method PUT -Headers @{"Authorization" = "Bearer YOUR_JWT_TOKEN_HERE"; "Content-Type" = "application/json"} -Body '{"completed": true}'
Ganti 1 dengan ID task yang ingin diupdate.

7. Delete Task : 
Invoke-WebRequest -Uri "http://localhost:8081/tasks/1" -Method DELETE -Headers @{"Authorization" = "Bearer YOUR_JWT_TOKEN_HERE"}
Ganti 1 dengan ID task yang ingin dihapus.

Catatan:
Jalankan server terlebih dahulu dengan dart run bin/server.dart.
Endpoint /auth/users tidak memerlukan authentication.
Semua endpoint task memerlukan header Authorization: Bearer <token> kecuali register dan login.
Token JWT didapat dari response login.
Untuk testing, gunakan PowerShell commands seperti di atas.
r dan login.
Token JWT didapat dari response login.
Untuk testing, gunakan PowerShell commands seperti di atas.
>>>>>>> 246e26fbd9676100ead6ff3b5158b06abdb49490
