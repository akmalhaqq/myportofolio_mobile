# Personal Portfolio Akmal — Mobile

- **Nama** Muhammad Akmal Haqqani
- **NPM** 2506548295
- **Kelas** PBP D

## Deskripsi

Saya membuat aplikasi ini sebagai versi mobile dari portofolio pribadi untuk mata kuliah Pemrograman Berbasis Platform. Tugas 7 memperkenalkan halaman profil, kartu aksi, dan layout responsif. Pada Tutorial 09 dan Tugas 8, saya menambahkan navigasi drawer serta formulir Proyek dan Pengalaman. Tema gelapnya mengikuti palet portofolio versi web. [Portofolio versi web](https://github.com/akmalhaqq/myportofolio)

## Fitur

### Profil dan Menu Aksi

Di bagian atas ada tiga kartu yang menampilkan NPM, nama lengkap, dan kelas PBP. Di bawahnya ada **Lihat Proyek**, **Tambah Proyek**, **Tambah Pengalaman**, dan **Logout**. Setiap aksi punya ikon dan warna sendiri.

### Daftar dan Detail Proyek

Pilih **Lihat Proyek** dari Home atau drawer untuk membuka daftar publik dari API Django. Tarik daftar ke bawah untuk melihat data terbaru. Jika gagal dimuat, tekan **Coba Lagi**. Ketuk salah satu proyek untuk melihat deskripsi, teknologi, kategori, tahun, tautan, dan gambar jika tersedia.

### Formulir Proyek dan Pengalaman

Kartu **Tambah Proyek** dan **Tambah Pengalaman** membuka masing-masing formulir. Drawer memuat pilihan **Home**, **Lihat Proyek**, **Add Project**, dan **Add Experience**. Saat isian lolos validasi, tombol **Save** atau **Simpan** membuka ringkasan dalam dialog. Data formulir hanya berada di memori selama halaman aktif.

Formulir Pengalaman mengikuti model `Experience` di portofolio web. Jabatan, perusahaan atau organisasi, dan tags wajib diisi dengan batas 255 karakter. Periode berupa teks wajib dengan batas 100 karakter. Deskripsi wajib diisi dan bisa terdiri dari beberapa baris. Kategori dipilih dari dropdown dengan nilai awal `Other`. Tags dipisahkan dengan koma dan harus menghasilkan minimal satu label.

Panel **Pratinjau Pengalaman** bisa dibuka atau ditutup. Isinya mengikuti perubahan formulir dan menampilkan tags sebagai chip. Menutup ringkasan mempertahankan isian agar bisa dikoreksi. Tombol **Reset** meminta konfirmasi sebelum mengosongkan formulir dan mengembalikan kategori ke `Other`.

### Layout Responsif

Di layar sempit, kartu disusun satu kolom supaya nama dan label punya ruang untuk membungkus. Kalau lebar kontennya mencapai 600 piksel logis, kartu disusun dalam tiga kolom. Halamannya bisa digulir supaya kartu paling bawah tetap bisa dijangkau.

## Teknologi

- **Flutter dan Dart** untuk membangun aplikasi dan logika tampilan.
- **Material 3** melalui paket `material_ui` untuk tema, kartu, drawer, formulir, dan dialog.
- **Flutter Test** untuk memeriksa tampilan dan interaksi antar-widget.

## Struktur Project

```text
.
├── lib/
│   ├── main.dart                  # Entry point dan tema aplikasi
│   ├── config.dart                # Alamat backend Django
│   ├── models/
│   │   ├── item_homepage.dart     # Nama, ikon, dan warna tiap aksi
│   │   └── project.dart           # Model proyek dari API
│   ├── screens/
│   │   ├── experience_form.dart   # Form tambah pengalaman dan ringkasan
│   │   ├── menu.dart              # Halaman utama dan konfigurasi aksi
│   │   ├── project_detail_screen.dart # Halaman detail proyek
│   │   ├── project_form.dart      # Form tambah proyek
│   │   └── project_list_screen.dart   # Daftar proyek dari Django
│   ├── services/
│   │   └── api_client.dart        # Request ke API Django
│   ├── utils/
│   │   └── experience_tags.dart   # Pemisahan tags berdasarkan koma
│   ├── validators/
│   │   └── experience_validators.dart # Validasi field pengalaman
│   └── widgets/
│       ├── experience_preview.dart # Pratinjau isian dan chip tags
│       ├── info_card.dart         # Kartu profil
│       ├── left_drawer.dart       # Navigasi drawer
│       └── project_card.dart      # Kartu aksi dan SnackBar
├── test/
│   ├── api_client_test.dart
│   ├── experience_form_test.dart
│   ├── project_form_test.dart
│   ├── project_list_test.dart
│   └── widget_test.dart
├── pubspec.yaml
└── README.md
```

## Instalasi dan Menjalankan Project

### Prasyarat

Siapkan Git, Flutter SDK yang menyertakan Dart sesuai syarat `^3.13.7`, dan target yang ingin dipakai. Gunakan Chrome untuk demo web atau siapkan Android SDK dan emulator untuk demo mobile. Jalankan backend Django dari repo MyPortfolio untuk membuka daftar proyek. [Dependensi aplikasi](pubspec.yaml) · [Backend MyPortfolio](https://github.com/akmalhaqq/myportofolio)

### Menjalankan Aplikasi

Clone repo, cek setup Flutter, lalu install dependensinya.

```sh
git clone https://github.com/akmalhaqq/myportofolio_mobile.git
cd myportofolio_mobile
flutter --version
flutter doctor
flutter pub get
dart run build_runner build
```

Untuk Chrome, arahkan Flutter ke server Django lokal yang berjalan di port 8000.

```sh
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
```

Untuk Android, nyalakan emulator dan jalankan aplikasi. Alamat Django default adalah `http://10.0.2.2:8000`.

```sh
flutter devices
flutter run
```

Kalau ada beberapa perangkat, pakai `flutter run -d <device-id>`. ID perangkatnya bisa dilihat dari `flutter devices`.

### Menjalankan Pengujian

Dari root repo, jalankan perintah berikut setelah konfigurasi awal dan pembuatan serializer di atas.

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Tes mencakup tema dan layout halaman utama, navigasi dari kartu dan drawer, validasi batas panjang, ringkasan terbaru, pratinjau langsung, reset, serta penggunaan formulir ketika keyboard tampil. Pada pengujian tahap kelima, `flutter analyze` bersih dan 22 tes lulus. [Tes halaman utama](test/widget_test.dart) · [Tes formulir Proyek](test/project_form_test.dart) · [Tes formulir Pengalaman](test/experience_form_test.dart)

### Skenario Demo Tugas 8

1. Buka **Tambah Pengalaman** dari kartu Home. Pada perangkat Android, gunakan tombol Back sistem untuk kembali ke Home.
2. Buka drawer, pilih **Add Experience**, lalu tekan **Simpan** saat formulir kosong. Formulir menampilkan pesan validasi dan dialog ringkasan belum terbuka.
3. Isi jabatan `Mentor Flutter`, perusahaan `Komunitas Uji`, periode `2026`, kategori `Other`, deskripsi `Mendampingi peserta belajar Flutter.`, dan tags `Flutter, Mentoring`.
4. Buka **Pratinjau Pengalaman** untuk melihat perubahan isian dan dua chip tags. Tekan **Simpan** dan cocokkan keenam nilai di dialog. Pilih **Tutup** untuk kembali ke formulir.
5. Tekan **Reset → Batal** untuk memeriksa bahwa isian tetap ada. Ulangi dengan **Reset → Reset** untuk mengosongkan isian. Buka drawer dan pilih **Home** untuk kembali.

Pengujian interaktif di Chrome pada viewport 360 × 640 memverifikasi alur drawer, penolakan isian kosong, pratinjau dan ringkasan isian valid, penutupan dialog, serta kembali ke Home. Pembatalan dan konfirmasi Reset, navigasi Back dari kartu, dan simulasi keyboard pada layar sempit diverifikasi melalui widget test.

## Proses Pengembangan

### Tutorial 08 — Basic Flutter

Di tutorial ini saya mulai dari setup Flutter, lalu memisahkan halaman utama ke `menu.dart` dan membuat tiga kartu profil serta tiga kartu aksi. [Commit Tutorial 08](https://github.com/akmalhaqq/myportofolio_mobile/commit/15dd7cb)

### Tugas 7 — Basic Flutter

Saya lanjut dengan memisahkan model dan widget kartu ke file masing-masing. Setelah itu saya pindahkan palet dari versi web ke mobile dan merapikan layout untuk layar sempit. Tahap terakhir di kode adalah menambahkan pratinjau ke aksi **Lihat Proyek**. Perubahannya saya commit per tahap supaya gampang dicek dari riwayat Git. Versi Tugas 7 bisa dicoba dengan langkah setup di atas. [Commit pratinjau proyek](https://github.com/akmalhaqq/myportofolio_mobile/commit/d2a1d250b62eef634bd0ff2085710039f1fe122c)

### Tutorial 09 — Navigasi dan Formulir Proyek

Saya menambahkan drawer, formulir Proyek dengan validasi dan dialog, serta navigasi dari kartu **Tambah Proyek**. Di akhir tutorial, saya memindahkan halaman ke `lib/screens/` dan memakai `lib/widgets/` untuk komponen yang digunakan kembali. [Commit final Tutorial 09](https://github.com/akmalhaqq/myportofolio_mobile/commit/de02d7a27ad12279e43578011341f0e649379a03)

### Tugas 8 — Formulir Pengalaman

Saya mulai dari formulir dan validasi berdasarkan model `Experience`, lalu menghubungkan kartu Home dan drawer ke halaman baru. Tahap berikutnya menambahkan pratinjau langsung, chip tags, dan konfirmasi Reset. Saya menutup tahap implementasi dengan memperkuat pengujian validasi dan ringkasan melalui jalur drawer. 

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
   - **Umpan balik dan pratinjau.** `SnackBar` menampilkan pesan, `SnackBarAction` menambahkan tombol **Buka Proyek**, dan `ScaffoldMessenger` mengelola kemunculan pesan. `BottomSheet` menjadi panel modal yang dibuka lewat `showModalBottomSheet()`. `ProjectPreview` menyusun isinya, `FilledButton` menjadi tombol **Tutup**, dan `Navigator` mengelola rute panel tersebut. 

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

### Tugas 8

1. **Apa perbedaan `push()`, `pushReplacement()`, dan `pop()` dalam navigasi aplikasi ini?**

 Ketiga metode tersebut digunakan untuk mengatur perpindahan halaman di Flutter, tetapi memiliki cara kerja yang berbeda. `Navigator.push()` digunakan untuk membuka halaman baru dengan menambahkan route ke navigation stack, sehingga halaman sebelumnya tetap tersimpan dan pengguna bisa kembali menggunakan tombol Back. Sementara itu, `Navigator.pushReplacement()` mengganti halaman yang sedang aktif dengan halaman baru, sehingga halaman sebelumnya tidak lagi berada pada posisi tersebut di navigation stack. Berbeda dengan keduanya, `Navigator.pop()` digunakan untuk menutup route yang sedang aktif dan kembali ke route sebelumnya.

   Dalam aplikasi portofolio saya, kartu Tambah Pengalaman menggunakan `Navigator.push()` untuk membuka formulir Experience dari halaman utama. Dengan begitu, pengguna tetap bisa kembali ke halaman utama menggunakan tombol Back. Untuk navigasi melalui drawer, ketika pengguna memilih Home dari halaman formulir, aplikasi terlebih dahulu menutup drawer menggunakan `pop()`, kemudian menggunakan `pushReplacement()` untuk mengganti halaman formulir dengan halaman utama. Pendekatan ini membantu menjaga alur navigasi agar pengguna tidak perlu melewati halaman formulir yang sudah ditinggalkan.

2. **Bagaimana `Scaffold`, `AppBar`, dan `Drawer` menjaga struktur halaman konsisten?**

   Saya menggunakan `Scaffold` sebagai struktur utama setiap halaman karena widget ini menyediakan tempat untuk komponen seperti `AppBar`, `Drawer`, dan konten utama melalui body. Dengan struktur yang sama, setiap halaman memiliki susunan yang konsisten meskipun konten di dalamnya berbeda.

   `AppBar` digunakan untuk menampilkan identitas atau judul halaman, sedangkan `Drawer` menyediakan akses navigasi ke `Home`, `Add Project`, dan `Add Experience`. Saya juga menggunakan komponen `LeftDrawer` yang sama pada ketiga halaman agar tidak perlu membuat ulang menu navigasi dengan implementasi yang berbeda.

   Dari sisi tampilan, saya menerapkan tema gelap yang mengikuti warna portofolio versi web melalui `ThemeData` pada `MaterialApp`. Salah satu contohnya adalah penggunaan colorScheme.primaryContainer sebagai warna latar header drawer. Karena warna tersebut diambil dari tema aplikasi, tampilannya tetap konsisten ketika drawer dibuka dari halaman Home, Project, maupun Experience. Menurut saya, pendekatan ini juga mempermudah perubahan desain karena pengaturan warna tidak perlu dilakukan secara terpisah pada setiap halaman.

3. **Mengapa tata letak formulir memakai kolom, jarak, dan pengguliran?**

   Pada formulir Experience, saya memilih susunan vertikal menggunakan Column agar pengguna dapat mengisi setiap field secara berurutan, mulai dari jabatan, perusahaan atau organisasi, periode, kategori, deskripsi, hingga tags. Susunan ini menurut saya lebih mudah digunakan pada perangkat mobile karena pengguna cukup mengikuti alur pengisian dari atas ke bawah.

   Untuk menjaga keterbacaan, saya menggunakan Padding dengan EdgeInsets agar konten tidak terlalu menempel pada tepi layar, serta SizedBox untuk memberikan jarak antarfield dan tombol. Jarak tersebut membantu membedakan setiap bagian formulir sehingga tampilannya tidak terlalu padat.

   Selain itu, saya menggunakan SingleChildScrollView karena tinggi layar perangkat berbeda-beda, terutama ketika keyboard sedang terbuka. Tanpa pengguliran, sebagian field atau tombol seperti Simpan dan Reset berisiko sulit dijangkau. Dengan widget tersebut, pengguna tetap dapat mengakses seluruh bagian formulir meskipun ruang yang tersedia berkurang. Saya juga menerapkan dialog yang mendukung pengguliran agar ringkasan input yang panjang tetap dapat dibaca.

4. **Apa peran `GlobalKey<FormState>`, `validator`, dan `validate()` saat Simpan ditekan?**

   Ketiga komponen tersebut saling berhubungan dalam memastikan data yang dimasukkan pengguna sudah sesuai aturan sebelum diproses. GlobalKey<FormState> digunakan untuk mengakses dan mengelola state dari Form, sedangkan validator berisi aturan pemeriksaan untuk masing-masing field. Ketika tombol Simpan ditekan, aplikasi memanggil validate() untuk menjalankan seluruh validator dan menentukan apakah input sudah valid.

   Sebagai contoh, pada formulir Experience, field periode wajib diisi dan memiliki batas maksimal 100 karakter. Jika pengguna hanya memasukkan spasi, input tersebut akan ditolak karena setelah diproses menggunakan trim(), hasilnya menjadi string kosong. Formulir kemudian menampilkan pesan kesalahan pada field terkait dan tidak membuka dialog ringkasan.

   Menurut saya, penggunaan jenis input atau keyboard yang sesuai tetap belum cukup untuk memastikan validitas data. TextFormField, misalnya, tetap memungkinkan pengguna memasukkan spasi atau teks yang tidak memenuhi aturan model. Oleh karena itu, validasi diperlukan untuk memeriksa isi data secara langsung, bukan hanya membatasi cara pengguna mengetiknya. Setelah seluruh input lolos validasi, aplikasi menjalankan proses penyimpanan state formulir dan menampilkan ringkasan data melalui AlertDialog.

## AI Disclosure

### Penggunaan AI

Saya pakai Chat GPT sebagai asisten selama Tugas 7. Saya minta dibantu memahami rubrik, menyusun urutan commit, dan belajar cara memisahkan widget, mengatur layout, serta menulis widget test. Saya juga minta bantuan mengecek perubahan dan mengacu pada kode dan dokumentasi Flutter.

### Pendekatan Penggunaan AI

Saya pakai *iterative prompting*. Di awal saya minta diajari langkahnya, dikasih contoh kode, lokasi file, dan alasan singkat kenapa perubahan itu perlu. Saya terapkan panduan awal secara manual lalu minta diff-nya dicek. Untuk beberapa perubahan berikutnya, seperti palet warna, layout responsif, dan panel pratinjau saya ubah lalu commit serta push ke `main`. Prosesnya berjalan per tahap.

### Keterbatasan AI dan Perbaikan Manual

Waktu pertama memindahkan kartu ke file baru, class lama masih tertinggal di `menu.dart`. Akibatnya, halaman masih memakai class lama dan analyzer menandai tiga import baru sebagai tidak terpakai. Saya hapus definisi lama secara manual, lalu minta analyzer dan widget test dijalankan lagi. Dari situ saya jadi lebih teliti memeriksa perubahan yang benar-benar tersimpan sebelum commit, AI chat lumayan terbatas dalam melihat adanya perubahan dalam code saya, sehingganya agar AI tahu state kita harus keep AI updated dengan datanya.

Dari masalah tersebut, saya belajar bahwa AI tidak selalu mengetahui kondisi terbaru dari kode yang sedang saya kerjakan. Karena itu, saya perlu memberikan konteks dan kode terbaru ketika meminta bantuan. Saya juga tetap perlu memeriksa hasil perubahan secara manual dan memastikan tidak ada error sebelum melakukan commit.

## Tugas 8

Dalam pengerjaan Tugas 8, saya menggunakan ChatGPT sebagai alat bantu untuk memahami implementasi Flutter dan mendukung proses pengembangan aplikasi. Bantuan AI saya gunakan terutama untuk menjelaskan maksud dan cara kerja kode, memahami hubungan antar-widget, menyusun test case, membantu mengidentifikasi penyebab bug ketika terjadi error, serta memberikan masukan untuk merapikan tampilan UI agar lebih konsisten dan responsif.

### Pendekatan Penggunaan AI
Saya menggunakan pendekatan iterative prompting, yaitu memberikan pertanyaan atau instruksi secara bertahap berdasarkan kebutuhan dan hasil implementasi sebelumnya. Misalnya, saya meminta penjelasan mengenai cara kerja navigasi dan validasi formulir, kemudian melanjutkan dengan pertanyaan mengenai pengujian input, penanganan error, atau perbaikan tampilan ketika ditemukan masalah. Dengan pendekatan ini, saya lebih mudah memahami alasan di balik perubahan kode dibandingkan langsung menerima seluruh solusi sekaligus.

### Keterbatasan dan Perbaikan Manual
Dalam prosesnya, saya juga menyadari bahwa saran dari ChatGPT tidak selalu langsung sesuai dengan kondisi aplikasi. Salah satu hal yang perlu diperhatikan adalah tampilan formulir dan dialog ketika dijalankan pada layar sempit atau saat keyboard terbuka. Karena itu, saya tetap perlu memeriksa hasil implementasi, menyesuaikan kode dengan kebutuhan aplikasi, serta menguji kembali fitur yang sudah dibuat. Pengujian melalui flutter analyze, flutter test, dan menjalankan aplikasi membantu memastikan perubahan tidak menimbulkan masalah baru.

Secara keseluruhan, saya menggunakan ChatGPT sebagai pendamping dalam proses belajar, debugging, dan pengembangan. Saya tetap perlu memahami kode yang digunakan, mengevaluasi saran AI, dan memeriksa hasil implementasi agar sesuai dengan kebutuhan tugas.
