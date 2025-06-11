#todo_app

- Nama: Rafa Aulia Tsalasadila
- Judul Project: Dooti
- Deskripsi Fungsionalitas Aplikasi
    Dooti adalah sebuah aplikasi todo list yang intuitif dan fungsional, dibangun dengan Flutter dan didukung oleh Firebase. Aplikasi ini dirancang untuk membantu pengguna mengelola tugas harian mereka dengan mudah dan efisien.
- Deskripsi Fungsionalitas Aplikasi
    Aplikasi Dooti menyediakan fitur-fitur utama, yaitu:
    1. Manajemen Tugas (CRUD): Pengguna dapat dengan mudah menambah, melihat, mengedit, dan menghapus tugas.
    2. Autentikasi Pengguna: - Pendaftaran (Sign Up): Pengguna baru dapat mendaftar dengan email, password, dan username.
                             - Login: Pengguna yang sudah terdaftar dapat masuk menggunakan email dan password mereka.
                             - Persistensi Sesi: Sesi login pengguna akan dipertahankan, sehingga pengguna tetap login bahkan setelah menutup aplikasi dan membukanya kembali.
                            - Logout: Pengguna dapat keluar dari akun mereka melalui halaman pengaturan.
    3. Kategorisasi Tugas: Tugas dapat dikelompokkan ke dalam kategori yang berbeda seperti Study, Personal, Shopping, dan Health, membantu pengguna mengatur tugas mereka dengan lebih baik.
    4. Tampilan Tugas: - Home Screen: Menampilkan sapaan personal, ringkasan tugas yang jatuh tempo hari ini, dan navigasi cepat ke kategori-kategori tugas.
                       - All Tasks: Menampilkan semua tugas yang ada, dipisahkan menjadi tugas yang sudah selesai dan tugas yang belum selesai.
    5. Tampilan Kalender: Pengguna dapat melihat tugas mereka dalam tampilan kalender interaktif, memungkinkan mereka untuk memilih tanggal dan melihat tugas yang terkait dengan tanggal tersebut. Tanggal yang memiliki tugas akan ditandai pada kalender.
    6. Detail Tugas: Saat menambah atau mengedit tugas, pengguna dapat memasukkan judul, deskripsi/catatan, memilih kategori, serta mengatur tanggal dan waktu jatuh tempo.
    7. Pengaturan Profil: Pengguna dapat melihat informasi akun mereka (username, email) dan memiliki opsi untuk logout. Fitur untuk mengubah foto profil juga tersedia, namun belum diimplementasikan untuk penyimpanan permanen ke Cloud Storage.
    8. Navigasi Bawah (Bottom Navigation Bar): Memungkinkan navigasi yang mudah antara halaman utama (Home), Kalender, Daftar Tugas, dan Pengaturan.
    
- Teknologi yang Digunakan
    1. Flutter: Framework UI yang kuat untuk membangun aplikasi cross-platform (Android, iOS, Web, Desktop) dari satu basis kode.
    2. Dart: Bahasa pemrograman yang digunakan oleh Flutter.
    3. Firebase Authentication: Layanan backend dari Google Firebase untuk mengelola autentikasi pengguna (registrasi, login, logout) dengan aman dan mudah.
    4. Cloud Firestore: Database NoSQL berbasis cloud dari Google Firebase yang digunakan untuk menyimpan dan menyinkronkan data tugas secara real-time.
    5. Google Fonts: Pustaka untuk mengintegrasikan berbagai font kustom (misalnya, Poppins) ke dalam aplikasi.
    6. table_calendar: Sebuah paket Flutter untuk menampilkan kalender interaktif yang dapat menandai tanggal dengan event dan memungkinkan pemilihan tanggal.
    7. intl: Pustaka Dart untuk internasionalisasi dan lokalisasi, digunakan untuk memformat tanggal dan waktu sesuai dengan locale (misalnya, bahasa Indonesia).
    8. image_picker: Paket Flutter untuk memilih gambar dari galeri perangkat atau mengambil foto dengan kamera.

- Cara Menjalankan Aplikasi
    1. Buka Aplikasi Dooti
    2. Proses Register
        Dalam Regiister Screen, pengguna harus memasukkan email dan meembuat password
    3. Proses Login
        Dalam Login Screen, pengguna harus login menggunakan akun yang telah didaftarkan
    4. Mulai Mengelola Tugas
        Di sini, pengguna dapat:
        - Menambah Tugas Baru: Ketuk tombol plus (+) di pojok kanan bawah layar untuk menambahkan tugas baru. Pengguna bisa memasukkan judul, deskripsi, kategori, dan tanggal/waktu jatuh tempo tugas.
        - Melihat Tugas Hari Ini: Di Home Screen, Anda bisa melihat tugas-tugas yang jatuh tempo hari ini.
        - Melihat Semua Tugas: Ketuk "See all" di Home Screen, atau ikon "Tasks" (simbol dokumen) di Bottom Navigation Bar, untuk melihat daftar lengkap semua tugas Anda, dipisahkan antara yang sudah selesai dan yang belum.
        - Melihat Tugas di Kalender: Ketuk ikon "Calendar" (simbol kalender) di Bottom Navigation Bar untuk melihat tugas Anda di tampilan kalender interaktif. Anda bisa memilih tanggal untuk melihat tugas yang terkait dengan tanggal tersebut.
        - Mengelola Pengaturan Akun: Ketuk ikon "Settings" (simbol roda gigi) di Bottom Navigation Bar untuk melihat informasi profil Anda atau untuk logout dari aplikasi.
    

- Tampilan APK

Splash Screen
<img width="118" alt="image" src="https://github.com/user-attachments/assets/21cb2667-2249-451a-84ec-ceb90bb32f67" />

Sign up 
<img width="476" alt="dooti1" src="https://github.com/user-attachments/assets/0f7debb4-e49e-426b-b10a-372cdb7f7aaa" />

Halaman utama
<img width="479" alt="image" src="https://github.com/user-attachments/assets/c404f33f-a422-4f45-961b-038c65aa6d3d" />

Melihat all to do list
<img width="475" alt="image" src="https://github.com/user-attachments/assets/662c3fcb-b5d9-4fe4-8423-e8917dc161a9" />

Add new task
<img width="185" alt="image" src="https://github.com/user-attachments/assets/8b7b9540-7207-4f91-ab51-b3a149136e27" />

Add task (atur kalender)
<img width="181" alt="image" src="https://github.com/user-attachments/assets/a3c0f0e0-6974-4553-a17e-59f144322c1e" />

Add new task (atur waktu)
<img width="182" alt="image" src="https://github.com/user-attachments/assets/b58a7c08-a4b1-4aa3-b475-dfdae15af3b9" />

Edit task
<img width="178" alt="image" src="https://github.com/user-attachments/assets/2ad5d1e4-47ca-46d5-aa76-bdd0d93e217c" />

Kalender
<img width="178" alt="image" src="https://github.com/user-attachments/assets/e3f6ec1b-9363-44e3-96bd-047ac2c4d6df" />

Settings profile
<img width="471" alt="image" src="https://github.com/user-attachments/assets/3fe37da0-c114-48ac-8da7-ca6e85ce58fe" />


Kategori (personal)
<img width="154" alt="image" src="https://github.com/user-attachments/assets/268ddf2c-1abd-4aac-8a99-95dc2652f43e" />

(shopping)
<img width="154" alt="image" src="https://github.com/user-attachments/assets/986a9f74-769a-4dde-a061-4bfa47f39546" />

(health)
<img width="178" alt="image" src="https://github.com/user-attachments/assets/1bf19eec-5dbd-4a1b-ac7d-50cf8ba8a129" />













