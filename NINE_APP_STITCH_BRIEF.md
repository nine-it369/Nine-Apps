# Nine Autogarage Mobile App — Design Brief untuk Google Stitch

> Dokumen ini adalah brief desain **mobile app** (iOS & Android, portrait, lebar acuan 390 × 844) untuk ekosistem **Nine Autogarage**. Sumber: *Nine Mall Style Guidelines*, fitur `mall.nine.co.id`, dan fitur `garage.nine.co.id`.
> Semua teks UI yang tampil di layar ditulis dalam **Bahasa Indonesia**.

---

## 0. Ringkasan Produk (paste ini dulu ke Stitch)

Nine Autogarage App adalah aplikasi pendamping pemilik kendaraan (mobil & motor) yang menyatukan empat hal: **perangkat aksesori terhubung** (GPS, lampu Biled, dashcam), **belanja aksesori otomotif** (Nine Mall), **booking pemasangan/servis di bengkel** (Nine Garage), dan **akun & loyalitas** (Nine Koin, Garage Points).

Nuansa: **premium otomotif, bersih, presisi**. Dominan **light mode** dengan kontras tinggi, header/aksen gelap (zinc-900), dan aksen **hijau emerald** untuk status positif dan aksi konfirmasi. Informasi padat tapi rapi memakai **micro-typography** (label kecil huruf kapital ber-tracking lebar). Target sentuh ramah jempol (min. 44 px).

**Navigasi utama (bottom tab bar, 5 tab):** Beranda · Aksesori · Mall · Booking · Akun.

---

## 1. Design System

### 1.1 Warna (gunakan token, bukan warna acak)

| Token | HEX | Penggunaan |
|---|---|---|
| `primary-900` | `#18181B` | App bar gelap, tombol utama, heading, tab aktif, hero card |
| `primary-950` | `#09090B` | Permukaan paling gelap (hero kartu aksesori, overlay) |
| `primary-800` | `#27272A` | Permukaan gelap sekunder |
| `primary-500` | `#71717A` | Teks sekunder, label, ikon tidak aktif |
| `primary-200` | `#E4E4E7` | Border, divider |
| `primary-100` | `#F4F4F5` | Highlight lembut, chip netral |
| `surface` | `#FAFAFA` | Latar halaman, input, card |
| `white` | `#FFFFFF` | Card, bottom sheet, bottom bar |
| `accent-500` | `#22C55E` | Terhubung/online, diskon, sukses, saldo Nine Koin, konfirmasi |
| `accent-600` / `accent-700` | `#16A34A` / `#15803D` | Pressed state & teks di atas latar accent muda |
| `accent-50` | `#F0FDF4` | Latar kartu terpilih / badge sukses |
| `warning-500` | `#F59E0B` | Pending, hitung mundur, servis mendekati jadwal, stok menipis |
| `warning-50` | `#FFFBEB` | Latar badge warning |
| `danger-500` | `#EF4444` | Terputus/offline, error, servis terlewat, batalkan, stok habis |
| `danger-50` | `#FEF2F2` | Latar badge danger |
| `info-500` | `#3B82F6` | Tracking resi AWB, tautan bantuan, info pengiriman |

Aturan: **jangan** memakai warna di luar token di atas. Status selalu didukung ikon + teks, bukan warna saja.

### 1.2 Tipografi

Font: sans-serif modern geometris (mis. Inter / Plus Jakarta Sans). Judul tegas, badge teknis kecil kapital.

| Skala | Ukuran | Bobot | Dipakai untuk |
|---|---|---|---|
| Micro | 9 px | Black, UPPERCASE, tracking lebar | Chip status ("ONLINE", "READY"), label jenis kendaraan ("MOBIL"/"MOTOR") |
| Label | 11 px | Bold, UPPERCASE, tracking 0.15em | Label section, SKU, breadcrumb, header kolom, tab filter |
| Caption | 12 px | Regular/Medium | Deskripsi, estimasi, petunjuk input |
| Body | 14 px | Regular/Semibold | Teks utama, rincian |
| Title | 16 px | Bold | Nama produk/aksesori, teks tombol |
| Price | 18 px | Black | Harga reguler, judul modal/sheet |
| Headline | 20 px | Extrabold | Harga flash sale, judul section |
| Display | 24 px | Black, tracking rapat | Grand Total, angka besar (km, kecepatan) |

Format uang selalu `Rp 1.250.000` (titik sebagai pemisah ribuan). Format jarak `1.800 km`.

### 1.3 Bentuk & Elevasi
- Radius: card `16 px`, tombol `12 px`, chip/badge `6 px` (pill untuk status), bottom sheet `24 px` di sudut atas.
- Shadow tipis (`shadow-sm`), bottom bar memakai blur putih 95%.
- Spasi: grid 4 px; padding halaman horizontal `16 px`; jarak antar section `20–24 px`.

### 1.4 Komponen Dasar

- **Tombol Primary**: latar `primary-900`, teks putih, bold, tinggi 52 px, lebar penuh, radius 12.
- **Tombol Secondary / Ghost**: tanpa latar, teks `primary-600`, semibold.
- **Tombol Konfirmasi Positif**: latar `accent-500` (dipakai untuk "Terima Barang", "Hubungkan", "Selesai").
- **Tombol Destruktif**: teks/outline `danger-500`.
- **Input**: latar `surface`, border `primary-200`, teks `primary-900`, placeholder `primary-400`, label 11 px kapital di atasnya.
- **Selectable Card**: default border `primary-200` latar putih; terpilih border `accent-500` + latar `accent-50` + ring lembut `accent-500`.
- **Status Badge**: pill 9 px black kapital — `ONLINE` (accent), `OFFLINE` (danger), `MENGHUBUNGKAN` (warning), `BATERAI LEMAH` (warning).
- **Progress Bar Perawatan**: tinggi 8 px, radius penuh; warna otomatis berdasar persentase (lihat 4.1.6).
- **Fixed Bottom Action Bar**: putih blur, border atas `primary-200`, kiri total/label, kanan tombol aksi (dipakai di keranjang, checkout, booking).
- **Bottom Sheet**: handle di atas, judul 18 px black, dipakai untuk filter, alamat, berbagi lokasi, pilih kendaraan.
- **Empty State**: ilustrasi garis sederhana + judul + 1 kalimat + 1 CTA.
- **Skeleton Loading** untuk list dan kartu, bukan spinner penuh layar.

### 1.5 Bottom Tab Bar
Latar putih, 5 tab: **Beranda** (ikon rumah), **Aksesori** (ikon chip/perangkat), **Mall** (ikon tas belanja), **Booking** (ikon kalender+kunci inggris), **Akun** (ikon user). Tab aktif: ikon & label `primary-900` bold dengan indikator titik/garis `accent-500`. Label 11 px.

### 1.6 Motion
Transisi halus 200–300 ms, tanpa animasi berlebihan. Pengecualian terarah: animasi pairing (4.2), countdown, dan titik live pada peta.

---

## 2. Konteks Global

- **Kendaraan aktif**: pengguna bisa punya lebih dari satu kendaraan (mobil/motor, plat, model). Chip pemilih kendaraan muncul di Beranda & Aksesori; mengetuknya membuka bottom sheet "Pilih Kendaraan".
- **Autentikasi**: login/daftar via nomor WhatsApp atau email, verifikasi OTP 6 digit, Google SSO (lihat 6.1).
- **Dukungan (ikon headset di app bar)**: bottom sheet "Bantuan" berisi: Chat WhatsApp CS, FAQ, Lacak Pesanan.
- **Sampel data** untuk mockup: kendaraan "Yamaha NMAX · B 1234 XYZ" (MOTOR) dan "Toyota Fortuner · B 9876 ABC" (MOBIL); nama pengguna "Rob".

---

## 3. Tab 1 — BERANDA

**Tujuan:** satu layar yang menjawab "kondisi kendaraan & urusanku dengan Nine hari ini".

### 3.1 App Bar (gelap, `primary-900`, sticky)
- Kiri/tengah: **search field** lebar penuh (latar `primary-800`, ikon kaca pembesar, placeholder "Cari aksesori di Mall…"). Mengetuk membuka halaman pencarian Mall.
- Kanan: ikon **keranjang** (badge angka `accent-500`) dan ikon **bantuan/headset**.

### 3.2 Urutan Section (rekomendasi)

> Urutan ini sedikit berbeda dari daftar awal. Alasan ada di bagian 8 (Catatan Diskusi).

1. **Kartu Aksesori Aktif (hero carousel)**
2. **Aksi Cepat** (Bagikan Lokasi, Booking, Lacak Pesanan)
3. **Perawatan Berkala** (oli, filter, rem berdasarkan km dari GPS)
4. **Pesanan Aktif** (hanya tampil jika ada)
5. **Jadwal Booking Terdekat** (hanya tampil jika ada)
6. **Banner Promo Mall**

Jika pengguna belum punya pesanan/booking, section 4–5 disembunyikan dan banner promo naik mengisi ruang tersebut.

### 3.3 Detail Section

**1) Hero Carousel Aksesori Aktif**
- Satu baris berisi tiga elemen: **[panah kiri] [kartu carousel] [panah kanan]**. Kedua panah berada **di luar komponen kartu**, di kiri dan kanannya, sejajar vertikal di tengah kartu. Panah tidak boleh menimpa gambar atau peta di dalam kartu.
- Panah: tombol lingkaran 36 px, latar putih, border `primary-200`, ikon chevron `primary-900` tebal 2.5 px. Area sentuh diperluas jadi 44 px. Saat berada di aksesori pertama/terakhir, panah terkait menjadi abu-abu (`primary-300`) dan nonaktif.
- Lebar kartu ±270 px (390 − padding 16 × 2 − panah 36 × 2 − jarak 8 × 2), tinggi ±240 px, latar `primary-950`, radius 16. Swipe horizontal tetap didukung selain panah.
- Di atas baris: label 11 px "AKSESORI AKTIF" (kiri) dan penghitung "1 / 3" (kanan). Di bawah baris: **indikator titik** di tengah, titik aktif memanjang 20 px berwarna `accent-500`, titik lain 6 px `primary-300`.
- Aksesori yang ditampilkan: **GPS, Lampu, Dashcam**. Satu kartu per aksesori terpasang. Mengetuk kartu membuka detail aksesori di tab Aksesori.
- Empty state: "Belum ada aksesori terhubung" + tombol "Hubungkan Aksesori" `accent-500`.
- Desain isi kartu per aksesori ada di bagian 3.4.

**2) Aksi Cepat** (baris 3 tombol ikon, kartu putih kecil)
- **Bagikan Lokasi** (ikon pin + panah), **Booking Servis** (ikon kalender), **Lacak Pesanan** (ikon paket).
- "Bagikan Lokasi" hanya aktif jika ada GPS terhubung; jika tidak, tampil abu-abu dengan tooltip.

**3) Perawatan Berkala (data dari GPS)**
- Header: label 11 px "PERAWATAN BERKALA" + link "Lihat Semua".
- Subjudul: "Total jarak tempuh: **12.480 km**" (display 24).
- 3 baris item, masing-masing: ikon, nama komponen, `terpakai / interval`, progress bar, status teks.
  - **Oli Mesin** — `1.800 / 2.000 km` — 90% — warna `warning-500` — teks "Segera ganti · sisa 200 km"
  - **Filter** — `4.200 / 10.000 km` — 42% — warna `accent-500` — "Kondisi baik"
  - **Rem (Kampas)** — `18.500 / 20.000 km` — 93% — warna `danger-500` — "Periksa rem segera"
- Tombol di bawah: **"Booking Servis Sekarang"** (primary) — membawa ke tab Booking dengan layanan terkait terpilih.
- Jika tidak ada GPS: empty state "Pasang GPS Nine untuk pemantauan perawatan otomatis".
- Jika ada item `≥ 100%` (terlewat): tampilkan banner merah tipis di paling atas Beranda: "Oli mesin sudah melewati batas ganti".

**4) Pesanan Aktif**
- Kartu putih: label "PESANAN KAMU", nomor pesanan, 1–2 thumbnail produk, **status terakhir** + lokasi paket: "Dalam perjalanan · Transit Jakarta Hub · 2 jam lalu", progress 4 langkah (Dibayar → Diproses → Dikirim → Tiba), tombol link "Lacak" (`info-500`).
- Jika menunggu pembayaran: tampil countdown `warning-500` + tombol "Bayar Sekarang".

**5) Jadwal Booking Terdekat**
- Kartu putih: label "JADWAL BOOKING", tanggal & jam besar (mis. "Sab, 11 Okt · 10.30"), cabang bengkel ("Nine Garage Arcadia"), layanan ringkas, kode tiket `TGR-XXXX-YYYY`, badge status (`CONFIRMED` accent / `PENDING` warning).
- Tombol sekunder: "Lihat Detail" dan "Rute ke Bengkel".

**6) Banner Promo Mall**
- Banner lebar penuh rasio ±16:7, gambar produk + judul promo + chip "FLASH SALE" / "-20%" + countdown opsional. Mengetuk → tab **Mall**.

### 3.4 Desain Kartu Carousel per Aksesori

Semua kartu punya struktur sama: **area visual atas (±130 px)** dan **strip info bawah (±110 px)** di atas latar `primary-950`. Strip info berisi nama alat (16 px bold putih), baris kendaraan (12 px `primary-400` + chip MOTOR/MOBIL 9 px black kapital), baris status/update (12 px `primary-400`), dan satu **angka utama di kanan** (Display 24 black putih + label 11 px kapital).

**A. Kartu GPS**
- Area visual: **peta bergaya OpenStreetMap**. Latar krem `#F2EFE9`, taman hijau muda, sungai biru muda, blok bangunan abu-krem, jalan lokal putih, jalan utama oranye muda, label nama jalan kecil miring (mis. "Jl. Jenderal Sudirman"). Warna peta ini pengecualian karena meniru tile OSM, bukan bagian token UI.
- Di atas peta: **marker kendaraan** lingkaran `accent-500` dengan stroke putih dan cincin berdenyut transparan; **garis rute** `info-500` tebal 3.5 px dengan titik awal berupa lingkaran putih.
- Overlay pojok kiri atas: pill putih "ONLINE" (titik `accent-500`, teks `accent-700`) dan pill "LIVE".
- Atribusi wajib di pojok kanan bawah peta: "© OpenStreetMap contributors" 7–8 px.
- Strip info: "Nine GPS Tracker", "Yamaha NMAX · B 1234 XYZ" + chip MOTOR, "Update 2 mnt lalu · Jl. Jenderal Sudirman". Angka utama: **42 km/j**.
- Status terputus: pill "OFFLINE" `danger-500`, marker abu-abu, peta diberi lapisan abu-abu transparan, strip info menampilkan "Terakhir terlihat 14.20".

**B. Kartu Lampu Biled**
- Area visual: latar `primary-950` dengan **lensa proyektor** di tengah (cincin luar `primary-700`, badan `primary-900`, kaca lensa bulat). **Cahaya lensa dan aura (glow) di sekelilingnya mengikuti warna yang dipilih**: gradien radial dari warna pilihan ke transparan, ditambah box-shadow bercahaya.
- Di bawah lensa: **baris pilihan warna** berisi 5 lingkaran 22 px: Amber, Warm White, White, Ice Blue, Green. Lingkaran terpilih lebih besar (26 px) dengan cincin putih. Mengetuk lingkaran langsung mengubah warna cahaya lensa pada kartu dan mengirim perintah ke lampu.
- Overlay: pill "ONLINE" di kiri atas, "KECERAHAN 80%" di kanan atas (11 px kapital `primary-400`).
- Strip info: "Nine Biled Projector", kendaraan + chip MOTOR, "Warna aktif: Ice Blue · Mode Normal". Angka utama: **80% TERANG**.
- Pastikan kontras: ikon, teks, dan lingkaran warna tetap terbaca di atas latar gelap untuk semua pilihan warna, termasuk White dan Warm White.

**C. Kartu Dashcam**
- Area visual: **pratinjau video 16:9** dari kamera depan (jalan raya saat senja, langit gelap ke oranye di horizon, siluet gedung, marka jalan putih, mobil di depan dengan lampu rem merah). Gradasi gelap di bagian bawah agar teks overlay terbaca.
- Overlay: pill "● REC" di kiri atas (titik `danger-500` berkedip pelan), "4K · 30 FPS" di kanan atas, timestamp "08/10/2026 17:42:10" di kiri bawah, kecepatan "42 KM/J" di kanan bawah (semua putih 10 px bold).
- Strip info: "Nine Dashcam 4K", "Toyota Fortuner · B 9876 ABC" + chip MOBIL, "Merekam · 32 GB tersisa". Angka utama diganti blok **penyimpanan**: label "PENYIMPANAN" 9 px, bar 72 × 6 px (`primary-800` dengan isi `accent-500`), teks "96 / 128 GB". Isi bar menjadi `warning-500` di atas 85% dan `danger-500` di atas 95%.
- Status terputus: overlay "KAMERA TERPUTUS" di atas pratinjau yang diburamkan, tombol kecil "Sambungkan Ulang".

---

## 4. Tab 2 — AKSESORI

**Tujuan:** mengelola koneksi perangkat dan melihat datanya. Aksesori: **GPS, Dashcam, Lampu (Biled)**.

### 4.1 Daftar Aksesori

**App Bar:** judul "Aksesori" kiri; kanan **tombol "+ Tambah"** (ikon plus, latar `accent-500`).

**Isi:**
- Chip filter horizontal: Semua · GPS · Dashcam · Lampu. Chip pemilih kendaraan di bawahnya.
- **Kartu aksesori** (list vertikal), tiap kartu: ikon/gambar perangkat, **nama alat**, **terpasang di** (kendaraan + plat), badge status, dan info singkat:
  - Online: titik hijau, "Terhubung · update 2 mnt lalu".
  - **Terputus**: badge `OFFLINE` merah, "Terputus sejak 14.20 · Terakhir terlihat di Jl. Sudirman", tombol kecil "Sambungkan Ulang".
  - Menghubungkan: badge `MENGHUBUNGKAN` warning dengan animasi pulsa halus.
  - Peringatan: baterai/penyimpanan hampir penuh (warning).
- Ringkasan di atas list: "3 terhubung · 1 terputus".
- Empty state: "Belum ada aksesori" + CTA "Tambah Aksesori".

### 4.2 Alur Tambah Aksesori (full-screen modal bertahap)

**Langkah 1 — Pilih jenis alat:** 3 selectable card besar (GPS, Dashcam, Lampu).
**Langkah 2 — Informasi alat:** input "Nama alat" (mis. "GPS NMAX"), pemilih "Dipasang di kendaraan" (pilih kendaraan tersimpan atau "+ Tambah kendaraan baru": jenis Mobil/Motor, plat, model, warna), input opsional kode/serial perangkat.
**Langkah 3 — Hubungkan (popup animasi):**
- Dialog tengah layar dengan latar gelap redup. Animasi: ikon ponsel di kiri, ikon kendaraan di kanan, **cincin gelombang berpulsa** di antaranya.
- Judul: "Dekatkan ponsel ke kendaraan". Subteks: "Pastikan perangkat menyala dan Bluetooth aktif."
- Status teks berganti: "Mencari perangkat…" → "Perangkat ditemukan" → "Menghubungkan…".
- **Sukses**: lingkaran `accent-500` dengan centang yang tergambar (draw-on), judul "Berhasil terhubung!", tombol "Lihat Aksesori".
- **Gagal / timeout**: ikon `danger-500`, "Perangkat tidak ditemukan", tombol "Coba Lagi" dan link "Hubungkan dengan scan QR / masukkan kode".

### 4.3 Detail GPS

Header: nama alat, kendaraan, badge status, tombol menu (ganti nama, pindah kendaraan, hapus aksesori).
Tab segmented di bawah header: **Live · Rute · Geofence · Perawatan · Pengaturan**.

- **Live**: peta penuh (60% tinggi layar) dengan marker kendaraan, kartu bawah: alamat terakhir, kecepatan (display 24 "42 km/j"), status mesin (ON/OFF), baterai perangkat, sinyal. Tombol: "Bagikan Lokasi", "Navigasi ke Kendaraan".
- **Rute**: pemilih tanggal horizontal (7 hari), peta dengan polyline rute, kartu ringkasan (jarak total, durasi jalan, kecepatan maks, jumlah berhenti), daftar perjalanan (waktu mulai → selesai, asal → tujuan) dan tombol "Putar Ulang Rute" (playback).
- **Geofence**: daftar zona (nama, radius, aturan "Notif saat keluar/masuk", toggle aktif), tombol "+ Tambah Zona" membuka peta dengan lingkaran yang bisa digeser/diubah radiusnya. Riwayat pelanggaran geofence di bawah.
- **Perawatan**: versi lengkap progress oli/filter/rem (bagian 3.3-3), odometer, tombol "Atur Interval", tombol "Tandai Sudah Diganti" (mereset hitungan km), riwayat penggantian.
- **Pengaturan**: notifikasi (gerak tanpa mesin, baterai rendah, kecepatan berlebih), interval pembaruan, firmware.

### 4.4 Detail Dashcam
Tab: **Live · Rekaman · Kejadian · Pengaturan**.
- **Live**: pratinjau video 16:9 dengan indikator REC merah berkedip, tombol ambil foto/kunci rekaman, status penyimpanan (bar: "32 GB / 128 GB").
- **Rekaman**: grid thumbnail video tersimpan dikelompokkan per tanggal, durasi di sudut, filter (Semua · Terkunci · Kejadian). Aksi: putar, unduh, bagikan, hapus.
- **Kejadian**: daftar rekaman terkunci otomatis akibat guncangan/parkir dengan waktu dan lokasi.
- **Pengaturan**: resolusi, mikrofon, mode parkir, format kartu SD, firmware.

### 4.5 Detail Lampu (Biled)
Tab: **Kontrol · Info**.
- **Kontrol**: status koneksi, pratinjau lampu, slider kecerahan, pilihan suhu warna (chip: 4300K / 5500K / 6000K), mode (Normal, Hemat, Siang), toggle on/off.
- **Info lengkap**: tipe/seri lampu, nomor seri, tanggal pasang & bengkel yang memasang, garansi (badge sisa waktu), jam pemakaian, suhu perangkat, versi firmware, riwayat servis terkait lampu ini.

---

## 5. Tab 3 — MALL (mengacu `mall.nine.co.id`)

App bar gelap: search field + ikon keranjang. Di bawahnya **chip gudang** ("Gudang: Jakarta ▾") yang membuka bottom sheet pemilih gudang.

### 5.1 Layar yang dibuat
1. **Beranda Mall**: hero banner promo, grid kategori (ikon bulat), section **Flash Sale** (countdown + progress kuota), **Paket Bundling**, **Terlaris** (grid produk 2 kolom).
2. **Katalog Produk** (`/products`): grid 2 kolom, tombol "Filter" membuka bottom sheet (kategori, rentang harga, kompatibel kendaraan, urutkan).
3. **Detail Produk**: galeri swipe, harga (Price 18 / Headline 20 untuk flash sale), harga coret + badge diskon `accent`, selector varian (warna lensa, watt, ukuran) sebagai selectable chip, indikator stok (READY / MENIPIS / HABIS), rating & ulasan, deskripsi, bottom bar tetap: "Tambah ke Keranjang" + "Beli Sekarang".
4. **Paket Bundling**: daftar paket + detail paket dengan sub-item; modal **pilih sub-varian** wajib per komponen; status "Habis" otomatis jika ada sub-item yang habis.
5. **Flash Sale**: list dengan countdown besar dan bar kuota tersisa.
6. **Keranjang**: checkbox seleksi per item, edit varian dari dalam keranjang, stepper kuantitas, peringatan stok, modal rekonsiliasi jika harga/stok berubah. Bottom bar: "Total Pembayaran Rp …" + "Lanjut ke Bayar".
7. **Checkout**: alamat pengiriman (kartu + bottom sheet buku alamat), pilihan kurir J&T (EZ / ECO / Cargo, estimasi hari), input voucher, toggle pakai **Nine Koin**, rincian biaya, **Grand Total** (Display 24), pilih metode bayar (selectable card).
8. **Instruksi Pembayaran**: kartu VA (BCA/BRI/BNI/Permata/Mandiri) dengan tombol "Salin Nomor VA" & "Salin Nominal"; atau kartu QRIS dengan tombol unduh; countdown `warning-500`; status berubah real-time lalu **Pembayaran Berhasil**.
9. **Pesanan Saya**: tab status (Menunggu Bayar · Diproses · Dikirim · Selesai · Dibatalkan); kartu pesanan; **Detail Pesanan** dengan timeline resi AWB (`info-500`), tombol "Konfirmasi Terima Barang" (`accent-500`, memberi Nine Koin), "Ajukan Retur" (form per item + unggah foto/video), "Beri Ulasan" (bintang 1–5, teks, foto).
10. **Lacak Pesanan Publik**: input nomor pesanan / resi AWB.

---

## 6. Tab 4 — BOOKING (mengacu `garage.nine.co.id`)

### 6.1 Halaman Awal Booking
- Kartu "Booking Berikutnya" (jika ada), tombol besar "Buat Booking Baru", shortcut "Riwayat", info cabang (Arcadia, Jelambar) dengan jam operasional, daftar promo/voucher aktif.

### 6.2 Stepper 5 Langkah (progress bar atas + "Langkah 2 dari 5")
1. **Kontak**: nama, nomor WhatsApp, email, alamat, kota, sumber referral. Terisi otomatis jika login.
2. **Kendaraan**: toggle Mobil/Motor, plat, model, warna, toggle **Kendaraan Listrik (EV)**; ambil dari kendaraan tersimpan. Peringatan: mengubah jenis kendaraan/EV akan mengosongkan pilihan layanan.
3. **Layanan & Produk**: tab Layanan · Suku Cadang · Paket Retrofit, harga menyesuaikan EV/ICE, modal sub-varian paket, input kode voucher.
4. **Jadwal**: pilih cabang, **kalender** (hari libur cabang non-aktif), grid **slot jam** interval 30 menit (tersedia/terisi/dipilih). Jika ada layanan Biled berdurasi panjang: banner info "Pengerjaan dilanjutkan ke hari berikutnya (est. selesai Rab, 15 Okt)".
5. **Review**: ringkasan lengkap + rincian biaya dan **timer hold 3 menit** (`warning-500`, 03:00 → 00:00) bertuliskan "Slot ditahan untuk kamu". Timer habis → dialog "Waktu habis" + tombol "Pilih Jadwal Lagi". Bottom bar: "Konfirmasi Booking".

Semua langkah memakai bottom bar tetap: "Kembali" (ghost) + "Lanjut" (primary). Draft tersimpan otomatis.

### 6.3 Layar Pendukung
- **Sukses Booking**: centang besar `accent-500`, kode tiket `TGR-XXXX-YYYY` (dapat disalin), ringkasan jadwal, tombol "Buka WhatsApp" dan "Lihat Booking".
- **Detail Booking**: status badge (`pending`, `confirmed`, `in_progress`, `completed`, `cancelled`), jadwal, layanan, biaya, tombol batalkan.
- **Work Order**: checklist pengerjaan teknisi, status per item, dan **kanvas tanda tangan digital** (rasio 1:1) dengan tombol "Hapus" dan "Kirim Tanda Tangan".
- **Riwayat Servis**: list dengan badge status dan filter.

---

## 7. Tab 5 — AKUN

Header profil: avatar, nama, nomor WA, chip "Nine Koin: **1.250**" (accent) dan "Garage Points: **340**".

### 7.1 Menu (list grup)

**Kendaraan & Perangkat**
- Kendaraan Saya (daftar + tambah/edit: jenis, plat, model, warna, EV)
- Aksesori Terhubung (pintasan ke tab Aksesori)

**Belanja (Mall)**
- Pesanan Saya · Buku Alamat · Nine Koin (saldo + riwayat mutasi) · Program Afiliasi (kode referral, komisi 4%, klik, konversi, saldo, riwayat payout) · Ulasan Saya

**Bengkel (Garage)**
- Riwayat Servis · Garage Points · Referral Teman (kode + reward) · Voucher & Promo

**Pengaturan**
- Profil (ubah nama, email, nomor WA)
- Keamanan (ubah kata sandi dengan verifikasi sandi lama)
- Notifikasi (peringatan perawatan, status pesanan, pengingat booking, geofence)
- Bahasa (Indonesia / English)
- Bagikan Lokasi Aktif (daftar tautan berbagi yang sedang berjalan + hentikan)
- Bantuan & Dukungan · Syarat & Privasi · Tentang Aplikasi
- **Keluar** (teks `danger-500`)

### 7.2 Layar Autentikasi
Login (nomor WhatsApp/email + sandi, Google SSO), Daftar, **Verifikasi** (input OTP 6 digit + cooldown kirim ulang, atau verifikasi via WhatsApp Bot dengan status real-time), Lupa Kata Sandi via WhatsApp, Lengkapi Nomor WhatsApp (jika belum ada).

---

## 8. Fitur Bagikan Lokasi (bottom sheet, dibuka dari Beranda / Detail GPS / Akun)

- Judul "Bagikan Lokasi Kendaraan". Pilih kendaraan (jika lebih dari satu).
- **Durasi** (selectable chip): 1 jam · 8 jam · 24 jam · Sampai saya hentikan.
- Teks privasi kecil: "Penerima dapat melihat posisi kendaraan secara langsung tanpa perlu aplikasi."
- Tombol: "Bagikan via WhatsApp" (primary) dan "Salin Tautan" (secondary).
- Setelah dibagikan: banner di Beranda "Lokasi sedang dibagikan · berakhir 2 jam lagi" + tombol "Hentikan" (`danger-500`).

---

## 9. State yang Perlu Didesain

Loading (skeleton), kosong (empty state per section), error jaringan ("Koneksi bermasalah" + "Coba Lagi"), offline perangkat, izin ditolak (lokasi/Bluetooth/notifikasi), sesi habis (arahkan ke login), stok habis, voucher tidak valid.

---

## 10. Urutan Generate di Stitch (disarankan)

Generate per layar agar konsisten, mulai dari fondasi:

1. Bagian **0 + 1** (Ringkasan + Design System) → minta Stitch membuat **Beranda** (bagian 3).
2. **Daftar Aksesori** + **popup pairing** (4.1, 4.2).
3. **Detail GPS** tab Live & Perawatan (4.3), lalu Dashcam & Lampu.
4. **Beranda Mall**, **Detail Produk**, **Keranjang**, **Checkout** (5).
5. **Stepper Booking** langkah 2, 4, 5 (6.2).
6. **Akun** + **Bagikan Lokasi** (7, 8).

Setelah layar pertama jadi, di prompt berikutnya selalu tambahkan: *"Gunakan design system, warna, dan komponen yang sama persis dengan layar Beranda."*

---

## 11. Asumsi & Pertanyaan Terbuka

- Alur pairing "dekatkan ponsel" diasumsikan **Bluetooth**. GPS tracker umumnya terhubung lewat IMEI/QR dan kartu SIM, bukan jarak dekat — makanya ada jalur cadangan "scan QR / masukkan kode".
- Data km perawatan diasumsikan berasal dari odometer virtual GPS. Interval default (oli 2.000 km, dst.) perlu dikonfirmasi dan disesuaikan untuk motor vs mobil.
- Peta pada kartu GPS dan detail GPS memakai tile OpenStreetMap (atau layer berbasis OSM); atribusi "© OpenStreetMap contributors" wajib tampil.
- Light mode dipakai untuk semua layar (sesuai style guide), dengan hero kartu aksesori dan app bar gelap sebagai aksen premium. Dark mode penuh belum termasuk.
- Fitur afiliasi dan Nine Koin hanya ada di Mall; Garage Points hanya di Garage. Di app keduanya ditampilkan terpisah dan belum digabung.
- Spesifikasi dashcam (live view, unduh rekaman) dan lampu (kontrol suhu warna/kecerahan) perlu disesuaikan dengan kemampuan perangkat sebenarnya.
