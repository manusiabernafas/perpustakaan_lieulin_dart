# Perpustakaan Digital - Neobrutalism Edition

Aplikasi manajemen perpustakaan modern dengan sentuhan estetika **Neobrutalism** (kontur hitam tebal, bayangan keras berdimensi, warna pop cerah & dinamis). Dikembangkan oleh **m.lie ulin nuha** (**M. Lie Ulin Nuha**).

---

## 🎨 Karakteristik Desain Neobrutalism
- **Bold Outlines**: Garis tepi hitam tegas (*2.5px - 3.5px solid black borders*).
- **Hard Drop Shadows**: Bayangan tanpa blur (*high-contrast solid offset shadows*).
- **Vibrant Color Palette**: Kombinasi warna Neo-Yellow (`#FFDE59`), Neo-Cyan (`#48CAE4`), Neo-Pink (`#FF70A6`), Neo-Purple (`#A29BFE`), dan kanvas krem hangat (`#FFFDF5`).
- **Tactile Micro-Interactions**: Tombol, chip, kartu katalog, dan input dirancang dengan sensasi fisik 3D yang interaktif.

---

## 🚀 Fitur Aplikasi
1. **Beranda & Registrasi Anggota (Neobrutalism Style)**
   - Formulir registrasi lengkap: Informasi akun, data diri, validasi NIM & HP, pemilih tanggal lahir, preferensi minat baca (genre chips), dan dialog konfirmasi.
   - Pengecekan kekuatan password dinamis dengan progress indicator neo-brutal.
2. **Katalog & Peminjaman Anggota**
   - Kartu statistik koleksi buku (*Tersedia* & *Dipinjam Saya*).
   - Pencarian real-time berdasarkan judul atau penulis buku.
   - Filter kategori/genre buku (Novel, Teknologi, Agama, Pengembangan Diri).
   - Peminjaman dan pengembalian buku langsung dari antarmuka pengguna.
3. **Panel Admin Perpustakaan**
   - **Dashboard**: Kartu metrik live (*Total Buku*, *Tersedia*, *Sedang Dipinjam*, *Total Transaksi*) dan riwayat peminjaman terbaru.
   - **Data Buku (CRUD)**: Tambah buku baru, ubah informasi buku, dan hapus buku.
   - **Data Anggota (REST API)**: Integrasi penuh REST API (`GET`, `POST`, `PUT`, `DELETE`) untuk data anggota.
   - **Peminjaman**: Log lengkap peminjaman dan aksi pengembalian buku.

---

## 🔑 Akun Demo (Siap Pakai)
- **Akun Anggota**:
  - Email: `ulin@gmail.com`
  - NIM: `87654321`
  - Password: `ulin123`
  - Nama: `m.lie ulin nuha`
- **Akun Admin**:
  - Username: `adminperpus`
  - Password: `password`
  - Nama: `M. Lie Ulin Nuha (Admin)`

---

## 💻 Menjalankan Proyek
Pastikan Flutter SDK sudah terpasang di sistem:

```bash
flutter pub get
flutter run
```

Atau jalankan di browser:
```bash
flutter run -d chrome
```