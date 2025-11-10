Daftar Command untuk Semua Fungsi API
Berikut adalah semua command untuk menguji fungsi API menggunakan PowerShell (seperti di test_api.ps1). Pastikan server berjalan di background. Ganti placeholder seperti YOUR_JWT_TOKEN_HERE dengan token yang didapat dari login.

1. Endpoint Root (Status Server)
GET / (Status Server):

Invoke-WebRequest -Uri "http://localhost:8080/" -Method GET
Response: {"status":"ok"}
2. Endpoint Auth (Autentikasi)
POST /auth/register (Register User):


Invoke-WebRequest -Uri "http://localhost:8080/auth/register" -Method POST -ContentType "application/json" -Body '{"email": "john_doe@example.com", "password": "password123"}'
Response: {"message":"Registrasi berhasil"}

POST /auth/login (Login User):


Invoke-WebRequest -Uri "http://localhost:8080/auth/login" -Method POST -ContentType "application/json" -Body '{"email": "john_doe@example.com", "password": "password123"}'
Response: {"token":"YOUR_JWT_TOKEN_HERE"} (Simpan token untuk endpoint berikutnya)

3. Endpoint Tasks (Manajemen Tugas - Membutuhkan JWT Token)
GET /tasks (Lihat Semua Tasks User):


Invoke-WebRequest -Uri "http://localhost:8080/tasks/" -Method GET -Headers @{"Authorization" = "Bearer YOUR_JWT_TOKEN_HERE"}
Response: {"tasks":[...list of tasks...]}
(Hanya menampilkan tasks milik user yang login)

POST /tasks (Tambah Task Baru):


Invoke-WebRequest -Uri "http://localhost:8080/tasks/" -Method POST -Headers @{"Authorization" = "Bearer YOUR_JWT_TOKEN_HERE"; "Content-Type" = "application/json"} -Body '{"title": "Belajar Dart", "description": "Mempelajari bahasa pemrograman Dart"}'
Response: {...task data...}

GET /tasks/{id} (Lihat Task Spesifik):


Invoke-WebRequest -Uri "http://localhost:8080/tasks/64f1a2b3c4d5e6f7g8h9i0j1" -Method GET -Headers @{"Authorization" = "Bearer YOUR_JWT_TOKEN_HERE"}
Response: {...task data...} (Ganti ID dengan ID task yang valid)

PUT /tasks/{id} (Update Task - Mark Completed/Incomplete):


Invoke-WebRequest -Uri "http://localhost:8080/tasks/64f1a2b3c4d5e6f7g8h9i0j1" -Method PUT -Headers @{"Authorization" = "Bearer YOUR_JWT_TOKEN_HERE"; "Content-Type" = "application/json"} -Body '{"completed": true}'
Response: Task berhasil diupdate (Ganti ID dengan ID task yang valid)

DELETE /tasks/{id} (Hapus Task):


Invoke-WebRequest -Uri "http://localhost:8080/tasks/64f1a2b3c4d5e6f7g8h9i0j1" -Method DELETE -Headers @{"Authorization" = "Bearer YOUR_JWT_TOKEN_HERE"}
Response: Task berhasil dihapus (Ganti ID dengan ID task yang valid)

Script Testing Otomatis
Gunakan script test_api.ps1 untuk testing otomatis:


./test_api.ps1
Script ini akan register, login, dan test beberapa endpoint tasks secara otomatis.

Catatan Penting
Semua endpoint tasks memerlukan header Authorization: Bearer <token> kecuali register dan login.
Token JWT didapat dari response login dan berlaku 1 hari.
Jika ada error, periksa log server di terminal.
Untuk production, ganti secret key di jwt_service.dart dengan yang lebih aman.
Database collections: users dan tasks di MongoDB.
