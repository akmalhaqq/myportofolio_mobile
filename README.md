# Personal Portfolio Akmal — Mobile

- **Nama** Muhammad Akmal Haqqani
- **NPM** 2506548295
- **Kelas** PBP D

## Deskripsi

Saya bikin aplikasi ini sebagai versi mobile dari portofolio pribadi saya untuk Tugas 7 mata kuliah Pemrograman Berbasis Platform. Project ini lanjut dari Tutorial 08. Di tugas ini saya pakai Flutter untuk menyusun halaman profil, membuat kartu aksi yang bisa dipakai ulang, dan menyesuaikan layout supaya tetap enak dibaca di HP. Tema gelap dan warnanya saya ambil dari [portofolio versi web](https://github.com/akmalhaqq/myportofolio).

## Fitur

### Profil dan Menu Aksi

Di bagian atas ada tiga kartu yang menampilkan NPM, nama lengkap, dan kelas PBP. Di bawahnya ada **Lihat Proyek**, **Tambah Proyek**, dan **Logout**. Saya kasih tiap aksi ikon dan warna sendiri, yaitu hijau gelap, hijau sage, dan merah redup. Saat ditekan, ketiganya menampilkan pesan `Kamu telah menekan tombol [Nama Tombol]!`.

### Pratinjau Proyek

Tekan **Lihat Proyek**, lalu pilih **Buka Proyek** di SnackBar. Panel yang muncul dari bawah berisi ringkasan MyPortfolio Mobile dan teknologi yang dipakai. Tekan **Tutup** untuk kembali. Di versi Tugas 7, aksi **Tambah Proyek** dan **Logout** memberi umpan balik lewat SnackBar.

### Layout Responsif

Di layar sempit, kartu disusun satu kolom supaya nama dan label punya ruang untuk membungkus. Kalau lebar kontennya mencapai 600 piksel logis, kartu disusun dalam tiga kolom. Halamannya bisa digulir supaya kartu paling bawah tetap bisa dijangkau.

## Teknologi

- **Flutter dan Dart** untuk membangun aplikasi dan logika tampilan.
- **Material 3** untuk tema, kartu, ikon, SnackBar, dan panel pratinjau.
- **Flutter Test** untuk memeriksa tampilan dan interaksi antar-widget.

## Struktur Project

```text
.
├── lib/
│   ├── main.dart                  # Entry point dan tema aplikasi
│   ├── models/
│   │   └── item_homepage.dart     # Nama, ikon, dan warna tiap aksi
│   ├── screens/
│   │   ├── menu.dart              # Halaman utama dan konfigurasi aksi
│   │   └── project_form.dart      # Form tambah proyek
│   └── widgets/
│       ├── info_card.dart         # Kartu profil
│       ├── left_drawer.dart       # Navigasi drawer
│       ├── project_card.dart      # Kartu aksi dan SnackBar
│       └── project_preview.dart   # Isi panel pratinjau
├── test/
│   ├── project_form_test.dart
│   └── widget_test.dart
├── pubspec.yaml
└── README.md
```

## Instalasi dan Menjalankan Project

### Prasyarat

Siapkan Git, Flutter SDK yang menyertakan Dart sesuai syarat `^3.13.7` di [pubspec.yaml](pubspec.yaml), serta emulator Android atau perangkat Android yang terhubung. Data profil dan pratinjau sudah ada di dalam aplikasi, jadi demonya bisa jalan tanpa server Django. [Panduan instalasi Flutter](https://docs.flutter.dev/install)

### Menjalankan Aplikasi

Clone repo, cek setup Flutter, lalu install dependensinya.

```sh
git clone https://github.com/akmalhaqq/myportofolio_mobile.git
cd myportofolio_mobile
flutter --version
flutter doctor
flutter pub get
```

Nyalakan emulator atau hubungkan HP, lalu jalankan aplikasi.

```sh
flutter devices
flutter run
```

Kalau ada beberapa perangkat, pakai `flutter run -d <device-id>`. ID perangkatnya bisa dilihat dari `flutter devices`.

### Menjalankan Pengujian

Dari root repo, jalankan perintah berikut setelah `flutter pub get`.

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Widget test mencakup tema gelap, data profil, warna dan pesan tiap aksi, serta alur buka–tutup pratinjau. Ada juga tes dengan ukuran layar 320 × 480 piksel logis dan teks 2× untuk memastikan semua aksi masih bisa dijangkau. [File widget test](test/widget_test.dart)

## Proses Pengembangan

### Tutorial 08 — Basic Flutter

Di tutorial ini saya mulai dari setup Flutter, lalu memisahkan halaman utama ke `menu.dart` dan membuat tiga kartu profil serta tiga kartu aksi. [Commit Tutorial 08](https://github.com/akmalhaqq/myportofolio_mobile/commit/15dd7cb)

### Tugas 7 — Basic Flutter

Saya lanjut dengan memisahkan model dan widget kartu ke file masing-masing. Setelah itu saya pindahkan palet dari versi web ke mobile dan merapikan layout untuk layar sempit. Tahap terakhir di kode adalah menambahkan pratinjau ke aksi **Lihat Proyek**. Perubahannya saya commit per tahap supaya gampang dicek dari riwayat Git. Versi Tugas 7 bisa dicoba dengan langkah setup di atas. [Commit pratinjau proyek](https://github.com/akmalhaqq/myportofolio_mobile/commit/d2a1d250b62eef634bd0ff2085710039f1fe122c)

## Pertanyaan Reflektif

### Tugas 7

1. **Apa itu widget tree dan bagaimana hubungan induk-anak bekerja?**

   Widget tree adalah susunan widget yang membentuk tampilan Flutter. Saya membayangkannya dari halaman utama project ini. `runApp()` memasang `MyApp`, lalu `MyApp` membuat `MaterialApp` dengan `MyHomePage` sebagai halaman awal. Di halaman itu, `Scaffold` punya slot `appBar` dan `body`. Di bagian `body`, saya pakai `Wrap` dengan beberapa kartu sebagai `children`. Properti `child` dipakai untuk satu anak, sedangkan `children` menampung beberapa anak.

   Widget mendeskripsikan konfigurasi tampilan. Flutter memakai *element* untuk mewakili posisi widget yang terpasang dan *render object* untuk mengatur ukuran, posisi, serta penggambaran. Saat layout, induk memberi batas ukuran ke anak. Anak menentukan ukurannya di dalam batas itu, lalu induk menentukan posisinya. Di project saya, `LayoutBuilder` membaca batas lebar tersebut supaya kartu bisa disusun satu atau tiga kolom.

2. **Widget apa saja yang saya pakai dan apa fungsinya?**

   - **Aplikasi dan halaman.** `MyApp` mengatur konfigurasi awal. `MaterialApp` menyiapkan tema dan navigasi. `MyHomePage` merangkai halaman utama, `Scaffold` menyediakan struktur halamannya, dan `AppBar` menampilkan judul aplikasi.
   - **Layout.** `SafeArea` menjaga konten dari area sistem. `Padding` memberi ruang di sekitar isi. `LayoutBuilder` membaca batas ruang yang tersedia. `SingleChildScrollView` membuat konten bisa digulir. `Column` menyusun isi ke bawah, `Wrap` memindahkan kartu ke baris berikutnya kalau ruangnya habis, dan `SizedBox` memberi jarak atau menentukan lebar kartu.
   - **Kartu profil.** `InfoCard` menyusun judul dan nilai profil, lalu `Card` memberi permukaan dan elevasi. `Text` saya pakai untuk profil, judul halaman, label tombol, pesan SnackBar, dan isi pratinjau.
   - **Kartu aksi.** `ItemCard` menyusun satu aksi, `Material` memberi warna permukaan dan tempat efek sentuhan, lalu `InkWell` menangani ketukan. `Container` memberi padding isi kartu, `Center` memusatkan isinya, dan `Icon` menampilkan simbol aksi. Nama, ikon, dan warna kartu diambil dari model data `ItemHomepage`.
   - **Umpan balik dan pratinjau.** `SnackBar` menampilkan pesan, `SnackBarAction` menambahkan tombol **Buka Proyek**, dan `ScaffoldMessenger` mengelola kemunculan pesan. `BottomSheet` menjadi panel modal yang dibuka lewat `showModalBottomSheet()`. `ProjectPreview` menyusun isinya, `FilledButton` menjadi tombol **Tutup**, dan `Navigator` mengelola rute panel tersebut. [API MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp-class.html) · [API showModalBottomSheet](https://api.flutter.dev/flutter/material/showModalBottomSheet.html)

3. **Apa fungsi MaterialApp dan kenapa biasanya ada di root?**

   Saya pakai `MaterialApp` untuk mengatur hal-hal yang dipakai bersama oleh halaman, seperti tema, judul aplikasi, navigasi, dan pengelola SnackBar. Di project ini, `MyApp` yang langsung diberikan ke `runApp()`. Di dalam `MyApp`, `MaterialApp` memakai `theme` untuk memasang tema gelap dan `home` untuk membuka `MyHomePage`. Karena posisinya dekat akar, halaman dan panel di bawahnya bisa memakai tema serta layanan navigasi yang sama. Contohnya, saat saya buka pratinjau, rute panel ditambahkan ke `Navigator` yang sudah disiapkan. 

4. **Kapan saya pakai StatelessWidget dan kapan StatefulWidget?**

   Saya pakai `StatelessWidget` saat tampilan cukup dibentuk dari konfigurasi dan konteks. Contohnya, data profil dan konfigurasi aksi di `MyHomePage` sudah ditentukan, jadi halaman itu tidak perlu menyimpan state lokal yang berubah. Widget stateless masih bisa dibangun ulang ketika input dari induk atau dependensi seperti tema berubah. Ketukan pada `ItemCard` juga bisa memunculkan SnackBar lewat `ScaffoldMessenger`.

   Kalau nanti saya menambahkan filter proyek yang pilihannya disimpan di halaman, saya bisa pakai `StatefulWidget`. Konfigurasi widget tetap immutable. Pilihan yang bisa berubah saya simpan di objek `State`, lalu saya perbarui dengan `setState()` supaya Flutter menjadwalkan pembangunan ulang UI yang terkait. 


5. **Apa itu BuildContext dan bagaimana saya pakai di build?**

   `BuildContext` menunjukkan posisi widget yang sedang terpasang di tree. Di `build(BuildContext context)`, saya bisa pakai posisi itu untuk mengambil tema atau layanan dari widget yang menaunginya. Contohnya, `Theme.of(context)` mengambil gaya judul untuk `ProjectPreview`, `ScaffoldMessenger.of(context)` menampilkan SnackBar dari kartu aksi, dan `Navigator.of(context).pop()` menutup panel saat tombol **Tutup** ditekan.

   Posisi konteks penting saat ada beberapa tingkat widget. Kalau saya membuat `Theme` baru di dalam hasil `build()`, konteks dari metode itu masih berada di atas tema baru. Untuk membacanya saya perlu konteks dari widget di bawah tema, misalnya dari callback `Builder`. 

6. **Apa bedanya hot reload, hot restart, dan full restart?**

   **Hot reload** memuat perubahan kode Dart di mode debug dan membangun ulang widget sambil menjaga state yang sedang berjalan. Ini cocok kalau saya cuma mengubah jarak antarkartu atau gaya judul di `build()`. Saat memakai `flutter run`, saya bisa tekan `r` di terminal.

   **Hot restart** memulai kembali aplikasi Flutter dan menghapus state dalam memori. Saya pakai ini ketika perlu menjalankan ulang `main()`, `initState()`, atau inisialisasi variabel global dan field statis non-`const` yang sudah terbaca sebelumnya. Di terminal perintahnya `R`.

   **Full restart** saya pakai ketika perubahan perlu dikompilasi ulang di sisi native, misalnya setelah mengedit Kotlin di Android atau Swift di iOS. Caranya dengan menghentikan sesi `flutter run` dan menjalankannya lagi. 

## AI Disclosure

### Penggunaan AI

Saya pakai Chat GPT sebagai asisten selama Tugas 7. Saya minta dibantu memahami rubrik, menyusun urutan commit, dan belajar cara memisahkan widget, mengatur layout, serta menulis widget test. Saya juga minta bantuan mengecek perubahan dan mengacu pada kode dan dokumentasi Flutter.

### Pendekatan Penggunaan AI

Saya pakai *iterative prompting*. Di awal saya minta diajari langkahnya, dikasih contoh kode, lokasi file, dan alasan singkat kenapa perubahan itu perlu. Saya terapkan panduan awal secara manual lalu minta diff-nya dicek. Untuk beberapa perubahan berikutnya, seperti palet warna, layout responsif, dan panel pratinjau saya ubah lalu commit serta push ke `main`. Prosesnya berjalan per tahap.

### Keterbatasan AI dan Perbaikan Manual

Waktu pertama memindahkan kartu ke file baru, class lama masih tertinggal di `menu.dart`. Akibatnya, halaman masih memakai class lama dan analyzer menandai tiga import baru sebagai tidak terpakai. Saya hapus definisi lama secara manual, lalu minta analyzer dan widget test dijalankan lagi. Dari situ saya jadi lebih teliti memeriksa perubahan yang benar-benar tersimpan sebelum commit, AI chat lumayan terbatas dalam melihat adanya perubahan dalam code saya, sehingganya agar AI tahu state kita harus keep AI updated dengan datanya.

Dari masalah tersebut, saya belajar bahwa AI tidak selalu mengetahui kondisi terbaru dari kode yang sedang saya kerjakan. Karena itu, saya perlu memberikan konteks dan kode terbaru ketika meminta bantuan. Saya juga tetap perlu memeriksa hasil perubahan secara manual dan memastikan tidak ada error sebelum melakukan commit.
