# Nine Autogarage Mobile Ecosystem (Nine Apps)

[![Apple HIG](https://img.shields.io/badge/Design-Apple%20HIG-black?style=flat&logo=apple)](https://developer.apple.com/design/human-interface-guidelines/)
[![TailwindCSS](https://img.shields.io/badge/CSS-TailwindCSS%20v4-38bdf8?style=flat&logo=tailwindcss)](https://tailwindcss.com/)
[![Phosphor Icons](https://img.shields.io/badge/Icons-Phosphor%20v2.1-green?style=flat)](https://phosphoricons.com/)
[![Vercel Ready](https://img.shields.io/badge/Deploy-Vercel%20Ready-black?style=flat&logo=vercel)](https://vercel.com/)

Aplikasi web mobile otomotif premium untuk ekosistem **Nine Autogarage** & **Nine Mall**, dirancang mengikuti standar **Apple Human Interface Guidelines (HIG)** dengan Clean Architecture.

---

## 🚀 Fitur Utama

### 1. 🏠 Beranda & Aksesori Terhubung (`index.html` / `home.html`)
- **Carousel 3-Deck Hero**: Menampilkan mockup perangkat interaktif (GPS Tracker 4G, Biled Projector Matrix E9 Pro, Dashcam 4K).
- **Beam Temperature Selector**: Mengubah warna sorot lampu secara langsung (*Ice Blue 6000K, Pure White 5500K, Warm 4300K, Amber 3000K, Laser Green*).
- **Live GPS Radar & Telemetri**: Status parkir geofence, kecepatan realtime, dan integrasi peta.
- **Quick Actions**: Bagikan lokasi dengan tautan langsung, status jadwal servis bengkel, dan lacak pesanan pengiriman.
- **Highlight Produk Mall**: Rekomendasi bundling aksesori resmi garasi.

### 2. 📅 Workshop & Booking Hub (`booking.html`)
- **Digital Pass Apple Wallet**: Tiket servis terkonfirmasi berbalut warna **Hijau Emerald Primary** (`TGR-8821`).
- **Live Workshop Pit Availability**: Indikator kapasitas stall pit bengkel realtime (Arcadia BSD & Jelambar).
- **Alur Reservasi 3 Langkah yang Humanis**:
  - *Langkah 1*: Pilih Layanan & Kendaraan (checklist transparan dengan kalkulasi estimasi durasi & biaya realtime).
  - *Langkah 2*: Pilih Cabang & Jadwal Kedatangan (pemilih tanggal & chip jam 30 menit).
  - *Langkah 3*: Konfirmasi & Ringkasan (slot lock timer 180s, garansi pengerjaan 1 tahun).
- **Pass Digital Resmi**: QR Code check-in di meja pit bengkel dan tombol bot WhatsApp.

### 3. 👤 Akun & Profil Garasi (`profile.html`)
- **Profil Pelanggan Apple HIG**: Avatar inisial dengan gradasi emerald premium, badge Platinum, nomor telepon & Member ID rapi.
- **Dual Loyalty Cards**: Saldo *Nine Koin* (Mall) & *Garage Points* (Bengkel).
- **Kendaraan Terdaftar**: Manajemen multi-unit kendaraan dan aksesori tertaut.
- **Pengaturan Lengkap**: Toggle notifikasi real-time push dan biometrik Face ID berstandar iOS Green.

### 4. 🛒 Nine Mall E-Commerce
- Katalog produk 2-kolom dengan filter kategori & harga (`catalog.html`).
- Detail produk dengan spesifikasi watt/lensa & countdown diskon (`product-detail.html`).
- Keranjang belanja multi-warehouse (`keranjang.html`) dan Checkout pengiriman J&T Express (`checkout.html`).
- Pelacakan resi AWB kurir realtime (`track.html` & `order-detail.html`).

### 5. 🛠️ Layanan Bengkel & IoT
- Detail GPS Tracker 4G IoT dengan riwayat rute (`device-gps.html`).
- Detail Dashcam 4K dengan dual kamera HUD (`device-dashcam.html`).
- Detail Lampu Biled Matrix E9 Pro (`device-lampu.html`).
- Detail Tiket Servis Digital Pass (`booking-detail.html`).
- Work Order (SPK Digital) dengan kanvas tanda tangan digital 1:1 (`work-order.html`).
- Riwayat Servis dengan filter status & unduh invoice PDF (`service-history.html`).

---

## 🎨 Design System & Clean Architecture

- **Primary Brand Color**: Emerald Green (`#16a34a` / `#22c55e` / `bg-accent-600`) untuk tombol aksi utama (*CTA*), chip aktif, dan pass card resmi.
- **Latar & Tipografi**: Canvas bersih `#ffffff` dan off-white `#f8f8fa`, didukung tipografi SF Pro Display & SF Pro Text.
- **Modular Components**:
  - `assets/components.css`: Kumpulan komponen UI siap pakai (`.btn-primary`, `.btn-secondary`, `.ios-card`, `.ios-list-group`, `.ios-list-row`, `.ios-toggle`, `.ios-filter-chip`).
  - `assets/base.css`: Pondasi CSS global dan interaksi sentuh Apple HIG (min 44pt touch targets).
  - `assets/components.js`: Helper modular untuk rendering stepper, kartu kendaraan, status badge, dll.
  - `assets/shell.js`: Global tab bar navigasi bawah dan header responsif.

---

## 📁 Struktur Direktori

```
d:\Nine Apps\
├── index.html               # Halaman utama root (Beranda / Home)
├── home.html                # Beranda utama Nine Autogarage
├── accecories.html          # Halaman manajemen aksesori IoT
├── mall.html                # Beranda Nine Mall e-commerce
├── booking.html             # Hub layanan bengkel & reservasi pit
├── booking-detail.html      # Detail tiket servis Apple Wallet pass
├── profile.html             # Profil pengguna & garasi kendaraan
├── service-history.html     # Riwayat servis bengkel & invoice
├── work-order.html          # SPK digital & tanda tangan inspeksi
├── catalog.html             # Katalog produk belanja
├── product-detail.html      # Detail produk & varian
├── keranjang.html           # Keranjang belanja
├── checkout.html            # Pembayaran & pengiriman
├── orders.html              # Daftar pesanan pelanggan
├── order-detail.html        # Timeline pengiriman pesanan
├── track.html               # Lacak resi publik kurir
├── auth.html                # Autentikasi masuk / daftar
├── showcase.html            # Katalog showcase direktori prototipe
├── vercel.json              # Konfigurasi deployment Vercel
├── assets/
│   ├── base.css             # Base stylesheet
│   ├── components.css       # Modular reusable UI components
│   ├── components.js        # Modular component helper engine
│   ├── config.js            # Tailwind token theme configuration
│   └── shell.js             # Shared app header & bottom navigation shell
└── README.md                # Dokumentasi proyek
```

---

## ⚡ Deployment ke Vercel

Proyek ini telah dikonfigurasi siap pakai untuk Vercel melalui `vercel.json`:

```json
{
  "$schema": "https://openapi.vercel.sh/vercel.json",
  "cleanUrls": true,
  "trailingSlash": false,
  "rewrites": [
    { "source": "/", "destination": "/index.html" },
    { "source": "/home", "destination": "/home.html" }
  ]
}
```

Pengunjung yang membuka root URL (`/`) akan langsung disuguhkan halaman **Beranda (Home)** dengan clean URL.

---

© 2026 **Nine Autogarage Digital Engineering**. All rights reserved.
