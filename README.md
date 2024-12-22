# Kelompok : A06

[![Build status](https://build.appcenter.ms/v0.1/apps/c9bd0a01-db20-40e3-9cd5-6a08837180d7/branches/main/badge)](https://appcenter.ms)

Anggota Kelompok :

- Andharu Hanif Achmadsyah (2306221062)
- Kadek Savitri (2306203236)
- Nur Alya Khairina (2306275701)
- Muhammad Hibrizi Farghana (2306165585)
- Hadyan Fachri (2306245030)

## Deskripsi Aplikasi:

OlehBali adalah solusi bagi wisatawan yang ingin membawa pulang oleh-oleh khas Bali tanpa kesulitan mencari toko yang tepat. Aplikasi ini mengumpulkan para pengusaha oleh-oleh di kota Denpasar, memungkinkan pengguna menemukan rekomendasi toko, menjelajahi katalog produk, dan menambahkan item favorit ke dalam wishlist serta melakukan diskusi dengan pengguna lainnya untuk mendapatkan rekomendasi suatu produk dan lainnya. Website ini dirancang untuk memudahkan wisatawan maupun pencari oleh-oleh dalam mencari informasi serta berbagi pengalaman seputar produk khas Bali. Tidak hanya itu, OlehBali juga memberikan peluang bagi UMKM lokal untuk memperluas pasar mereka dan meningkatkan penjualan dengan menjangkau audiens yang lebih luas, sekaligus mendukung ekonomi Bali.

## Daftar modul

### 0. Autentikasi

Modul untuk mengautentikasi pengguna. Modul ini menangani sistem _login_ bagi pengguna yang memiliki akun, dan _sign up_ bagi pengguna yang belum memiliki akun. Apabila pengguna telah berhasil diautentikasi, pengguna akan diarahkan ke laman utama dari _website_.

Dikerjakan oleh: Nur Alya Khairina dan Muhammad Hibrizi Farghana

### 1. Profil Pengguna

Modul ini mencakup detail akun pengguna, pengaturan akun, dan wishlist oleh-oleh yang diminati pengguna.
Rincian fitur modul ini adalah sebagai berikut.

- Pengguna dapat melihat detail akun mereka yang meliputi username, password, email, nomor telepon, dan nama toko (jika pengguna adalah pemilik toko).
- Pengguna juga dapat mengubah detail akunnya.
- Pengguna dapat memilih menghapus akunnya secara permanen.

Dikerjakan oleh : Nur Alya Khairina

### 2. Community

Modul ini memberikan ruang bagi pengguna untuk berinteraksi dan bertukar informasi mengenai oleh-oleh Bali. Fitur utama dari modul ini meliputi:

- Pengguna dapat membuat posting, memberikan ulasan, atau bertanya tentang pengalaman berbelanja oleh-oleh di Bali.
- Forum diskusi memungkinkan pengguna berbagi tips, rekomendasi, dan informasi tentang toko atau produk tertentu.

Dikerjakan oleh : Hadyan Fachri

### 3. Katalog Produk

Modul ini memungkinkan admin untuk mengelola dan menampilkan informasi tentang produk oleh-oleh di website. Fitur-fitur utama dari modul ini meliputi:

- Pemilik toko dapat mengunggah produk oleh-oleh dengan informasi detail, termasuk nama produk, deskripsi, harga, gambar, dan kategori produk.
- Memungkinkan pengguna untuk menjelajahi berbagai produk dengan mudah. Setiap produk akan menampilkan gambar, nama, dan harga.
- Fitur pencarian memungkinkan pengguna mencari produk spesifik berdasarkan kata kunci. Pengguna juga dapat menyaring produk berdasarkan kategori atau harga untuk mempercepat pencarian.
- Halaman Detail Produk: Ketika pengguna mengklik produk tertentu, mereka akan diarahkan ke halaman detail produk yang menampilkan informasi lebih lengkap, termasuk deskripsi mendetail, foto tambahan, dan opsi untuk menambahkan produk ke wishlist.
- Kategorisasi Produk: Pemilik toko dapat mengelompokkan produk dalam kategori yang relevan, sehingga memudahkan pengguna dalam menemukan jenis oleh-oleh yang mereka cari.

Dikerjakan oleh : Andharu Hanif Achmadsyah

### 4. Review

Modul ini memungkinkan pembeli untuk memberikan ulasan dan penilaian tentang toko di website. Fitur-fitur utama dari modul ini meliputi:

- Pembeli dapat mengunggah dan memberikan penilaian bintang (biasanya dari 1 hingga 5) untuk produk berdasarkan pengalaman belanja mereka.
- Pembeli dapat menulis ulasan yang lebih rinci tentang kualitas produk, layanan pelanggan, atau pengalaman secara keseluruhan.

Dikerjakan oleh : Muhammad Hibrizi Farghana

### 5. Wishlist
Modul ini memungkinkan pengguna untuk memasukan produk yang diinginkan ke dalam wishlist atau dihapus dari wishlist.

- Pengguna dapat menambahkan produk ke dalam wishlist
- Pengguna dapat melihat produk-produk dalam wishlistnya
- Pengguna dapat menghapus produk-produk dari wishlist

Dikerjakan oleh: Kadek Savitri

## Peran atau aktor pengguna aplikasi 

### Pemilik Toko

Pemilik toko dapat menampilkan produk mereka di aplikasi OlehBali. Pemilik toko dapat mengatur katalog toko, seperti menambahkan produk yang ingin dipasarkan dan menghapusnya.

### Pembeli

Pengguna dapat mencari produk yang ingin mereka cari, melihat profil toko maupun informasi produknya. Pembeli melakukan review terhadap suatu produk. Pengguna juga dapat melakukan diskusi pada modul Community dengan user lainnya.

## Alur pengintegrasian dengan web service untuk terhubung dengan aplikasi web yang sudah dibuat saat Proyek Tengah Semester

1. Aplikasi mobile mengambil data dari web service yang telah di-deploy melalui URL yang disediakan.
2. Dalam file Dart, URL tersebut diparsing menggunakan Uri.parse() untuk kemudian melakukan request HTTP GET  dengan header application/json.
3. Data yang berformat JSON tersebut di-decode menggunakan fungsi jsonDecode(), yang mengubahnya menjadi struktur objek Dart.
4. Setelah data di-decode, data tersebut dikonversi ke dalam model Dart yang sudah didefinisikan(class-model).
5. Pengambilan data dari web service terjadi secara asinkron. Untuk menampilkan data ini di Flutter, digunakan widget bernama FutureBuilder.

## Berita Acara

https://docs.google.com/spreadsheets/d/1N8S_MYg_wuZxCq1zvXGhb4QvITe9sBTcb45nuWGa2DE/edit?gid=1728856645#gid=1728856645

## Tautan deployment aplikasi
