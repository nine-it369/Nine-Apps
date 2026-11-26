# 🎨 Nine AutoSeries® Mobile App — Human Interface Guidelines (HIG) & Style Guide

> **Standar Antarmuka Resmi:** Apple Human Interface Guidelines (HIG) & Dual-Tone Modern Enterprise  
> **Platform Target:** Flutter 3.50+ & Dart 3.14+ (iOS, Android, Web & Desktop)  
> **Filosofi Inti:** High-Contrast, Tactile Ergonomics, Zero-Glassmorphism, No Pure Black (`#000000`) & No Raw White (`#FFFFFF`).

---

## 1. Filosofi & Prinsip Utama Desain

Sistem antarmuka **Nine AutoSeries®** dibangun di atas empat pilar filosofis berstandar **Apple Human Interface Guidelines (HIG)**:

```
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                   EMPAT PILAR FILOSOFIS HIG NINE®                               │
├─────────────────────┬──────────────────────────┬────────────────────────────┬───────────────────┤
│ 1. CLARITY          │ 2. DEFERENCE             │ 3. DEPTH & TACTILITY       │ 4. AUTHENTICITY   │
│ (Kejelasan Visual)  │ (Penghormatan Konten)    │ (Kedalaman & Materialitas) │ (Presisi Otomotif)│
│ • Kontras tinggi    │ • Kanvas studio lembut   │ • Solid opaque surface     │ • Telemetri nyata │
│ • Hierarki instan   │ • Konten telemetri utama │ • Zero glassmorphism kotor │ • Latensi <280ms  │
│ • Monoline presisi  │ • Data tanpa distraksi   │ • Elevasi mikro difus      │ • Nilai teknis pas│
└─────────────────────┴──────────────────────────┴────────────────────────────┴───────────────────┘
```

1. **Clarity (Kejelasan & Keterbacaan Instan):**
   Setiap elemen visual dirancang agar dapat dipindai oleh pengemudi dalam lirikan $\le 1$ detik. Tipografi proporsional, ikonografi monoline tunggal tanpa ornamen berlebih, dan angka telemetri berjarak tabular (*tabular figures*).
2. **Deference (Penghormatan pada Konten):**
   Antarmuka tidak boleh mencuri perhatian dari status operasional kendaraan. Kanvas latar belakang tenang dan lapang memberi panggung utama bagi status mobil, peta GIS, dan video streaming.
3. **Depth & Tactility (Kedalaman Padat 100% Solid Opaque):**
   Kedalaman visual dibangun melalui lapisan permukaan padat (*solid surfaces*) dengan bayangan difus mikro (*ambient diffused shadows*). **Dilarang keras menggunakan efek kaca buram murahan (*glassmorphism / backdrop-filter: blur*) pada area kerja utama** karena menyebabkan teks bocor dan menurunkan rasio kontras.
4. **Dual-Tone Anti-Monotony Enterprise:**
   Mengakhiri kebosanan desain serba-hitam pekat. Kanvas utama berbalut *Soft Silk Off-White* (`#FAFAFB`), berpadu harmonis dengan kontainer kontrol fokus *Smoked Obsidian* (`#141518`, `#1E2024`) serta aksen *Nine Lime Green* (`#8DC63F`).

---

## 2. Sistem Warna & Materialitas Resmi (Design Tokens)

### 2.1. Palet Warna Utama
| Token Nama | Nilai HEX | Definisi & Peruntukan Penggunaan |
| :--- | :---: | :--- |
| `primary` | `#8DC63F` | **Nine Lime Green** — Warna signature brand, status aktif, tombol aksi primer (CTA), marker bergerak. |
| `primaryDark` | `#76A834` | Aksen penekanan teks hijau tua, border status aktif terfokus. |
| `primaryLight` | `#E6F3D4` | Background pastel lencana sukses, active indicator tint. |
| `obsidian` | `#141518` | **Smoked Obsidian** — Kartu hero gravitasi tertinggi, floating bottom dock, tombol dark accent. |
| `obsidianSurface` | `#1E2024` | Layer sekunder di dalam kontainer obsidian, border halus surface gelap. |
| `canvas` | `#FAFAFB` | **Soft Silk Off-White** — Latar belakang kanvas aplikasi default (terang, lapang, nyaman di mata). |
| `surface` | `#FFFFFF` | Latar belakang kartu bento, modul sheet, dialog modal. |
| `surfaceMuted` | `#F8FAFC` | Latar input form, state non-aktif, segmented control container. |
| `border` | `#E2E8F0` | Garis batas input field, pemisah list aktivitas. |
| `borderSubtle` | `rgba(0,0,0,0.06)` | Garis tipis 1px kartu bento putih. |

### 2.2. Palet Warna Status & Semantik
| Kategori Status | Nilai HEX | Background Pastel Tag | Arti Fungsional |
| :--- | :---: | :---: | :--- |
| **Emergency / Danger** | `#ED1C24` | `#FEE2E2` (Text `#B91C1C`) | Alarm benturan G-Sensor, rem blong, kuota habis, offline kritis. |
| **Warning / Alert** | `#F59E0B` | `#FEF3C7` (Text `#B45309`) | Voltase aki drop, servis mendekati batas, mesin idling lama. |
| **Information / Blue** | `#4366B0` | `#E0E7FF` (Text `#3730A3`) | Kategori kendaraan, Bluetooth terkoneksi, update firmware. |
| **Loyalty / Gold** | `#BA983D` | `#FEF9C3` (Text `#854D0E`) | Poin Nine Koin, level member, e-voucher diskon khusus. |

---

## 3. Sistem Spasial & Geometri Layar (The 8pt Grid Engine)

### 3.1. Grid Spasi 8-Point Universal
Semua padding, margin, dan dimensi wajib mematuhi kelipatan basis **8pt** (dengan toleransi sub-grid mikro **4pt**):

| Spacing Token | Ukuran Pixel | Contoh Implementasi Nyata |
| :--- | :---: | :--- |
| `space-1` | `4px` | Jarak mikro ikon ke label teks, padding internal tag status mini. |
| `space-2` | `8px` | Jarak horizontal antar tombol aksi, gap antar item chip. |
| `space-3` | `12px` | Padding internal icon squircle, jarak antar baris list aktivitas. |
| `space-4` | `16px` | Padding standar kartu bento putih, margin lateral standar form. |
| `space-5` | `20px` | Margin lateral kiri-kanan layar ponsel (`EdgeInsets.symmetric(horizontal: 20)`). |
| `space-6` | `24px` | Jarak vertikal antar seksi utama (Header $\to$ Hero $\to$ Grid Jasa). |
| `space-8` | `32px` | Jarak aman batas atas modal bottom sheet. |
| `space-12` | `48px` | Tinggi minimum target sentuh ergonomis (Touch Target $\ge 44\text{px}$). |
| `space-28` | `112px` | Clearance buffer bawah (`pb-28`) agar konten tidak tertutup Floating Dock. |

### 3.2. Geometri Kurva Kontinu (Squircle Radius Konsentris)
Sesuai standar Apple HIG, komponen bersarang (*nested components*) wajib mematuhi kaidah konsentris:

$$R_{\text{outer}} = R_{\text{inner}} + \text{Padding}$$

* **Frame Layar Ponsel:** `44px` (Meniru bezel iPhone Pro).
* **Modal Bottom Sheet Drawer:** `32px` (`BorderRadius.vertical(top: Radius.circular(32))`).
* **Hero Obsidian Bento Card:** `28px`.
* **Standar Bento Grid Card:** `24px`.
* **Squircle Wadah Ikon Touch Target:** `16px` (pada dimensi $48 \times 48\text{ px}$).
* **Tombol Aksi & Input Form:** `14px`.
* **Floating Dock Navigasi & Status Pill:** `999px` (Kapsul Sempurna).

---

## 4. Sistem Tipografi & Skala Teks Dinamis

Aplikasi menggunakan dua keluarga font resmi:
1. **Plus Jakarta Sans:** Font antarmuka utama (UI, judul, tombol, label, deskripsi).
2. **JetBrains Mono:** Font khusus data teknis (angka telemetri GPS, koordinat, voltase aki, waktu, UUID tiket SPK, dan kode voucher).

| Token Tipografi | Font Family | Size | Weight | Line Height | Penerapan |
| :--- | :--- | :---: | :---: | :---: | :--- |
| `AppTextStyles.h1` | Plus Jakarta Sans | 24px | 800 (ExtraBold) | 32px | Judul utama layar, judul hero obsidian. |
| `AppTextStyles.h2` | Plus Jakarta Sans | 20px | 700 (Bold) | 28px | Judul seksi stepper, nama cabang bengkel. |
| `AppTextStyles.h3` | Plus Jakarta Sans | 16px | 700 (Bold) | 24px | Judul kartu bento, nama layanan servis. |
| `AppTextStyles.bodyLarge` | Plus Jakarta Sans | 15px | 500 (Medium) | 22px | Teks isi input field, harga tebal. |
| `AppTextStyles.bodyMedium`| Plus Jakarta Sans | 13px | 400 (Regular) | 18px | Deskripsi jasa servis, subtitle panduan. |
| `AppTextStyles.bodySmall` | Plus Jakarta Sans | 11px | 500 (Medium) | 16px | Label status tag, jam operasional, footnote. |
| `AppTextStyles.button`    | Plus Jakarta Sans | 14px | 700 (Bold) | 20px | Teks tombol aksi primer & sekunder. |
| `AppTextStyles.mono`      | JetBrains Mono | 12px | 600 (SemiBold) | 16px | Nomor SPK (`BK-2026-XXXX`), slot jam, lat/lng. |

---

## 5. Anatomi Komponen Antarmuka Terpakai Ulang (Reusable Widgets)

### 5.1. Bento Information Card (`BentoCard`)
* **Latar:** Putih solid 100% (`#FFFFFF`) atau Smoked Obsidian (`#141518`).
* **Border:** 1px `borderSubtle` (`rgba(0,0,0,0.06)`).
* **Bayangan:** Ambient drop-shadow difus halus: `BoxShadow(color: Color(0x0A000000), blurRadius: 18, offset: Offset(0, 4))`.
* **Radius:** `24px` konsisten.

### 5.2. Universal Borderless Status Tag (`BorderlessStatusTag`)
* **Aturan Mutlak:** `border: Border.all(color: Colors.transparent, width: 0)`.
* **Materialitas:** Warna latar pastel solid dengan teks berbobot `600 (SemiBold)`.
* **Bentuk:** Kapsul penuh `AppRadius.pillRadius` (`999px`).

### 5.3. Tombol Aksi Baku (Button Playbook)
* **Touch Target Ergonomis:** Tinggi minimal 48px (`minHeight: 48`).
* **NinePrimaryButton:** Latar `#8DC63F`, teks `#231F20`, elevasi 0.
* **NineSecondaryButton:** Latar `#F8FAFC`, border `#E2E8F0`, teks `#231F20`.
* **NineDangerButton:** Latar `#ED1C24`, teks `#FFFFFF`.

### 5.4. Floating Navigation Dock (`main-floating-dock`)
* **Desain:** Kapsul mengambang di atas konten (`bottom: 20px, left: 16px, right: 16px`).
* **Material:** Latar padat `#FAFAFB`, border `rgba(0,0,0,0.06)`, shadow `[0_8px_28px_rgba(0,0,0,0.08)]`.
* **Tab:** 4 Pintu Utama (Home Cockpit, Aksesoris IoT, Nine Mall, Profil/Garasi).

---

## 6. Aturan Baku & Pedoman Implementasi (Do & Don't)

### ✅ Do (Wajib Diterapkan):
1. Selalu gunakan `CurrencyFormatter.format(amount)` untuk seluruh tampilan mata uang Rupiah tanpa desimal ganda (`Rp 600.000`).
2. Gunakan `JetBrains Mono` dengan `font-variant-numeric: tabular-nums` untuk semua angka telemetri, jam slot, dan kode kupon.
3. Berikan ruang nafas bawah minimal 112px (`pb-28` atau `SizedBox(height: 112)`) pada seluruh halaman scrollable agar konten terbawah tidak tertutup Floating Dock.
4. Terapkan getaran haptik (*HapticFeedback.lightImpact()*) pada seleksi chip jadwal, stepper, dan tombol konfirmasi.

### ❌ Don't (Dilarang Keras):
1. **Dilarang menggunakan warna hitam pekat `#000000` atau putih mentah `#FFFFFF` pada background layar utama.**
2. **Dilarang menggunakan border outline tebal pada tag status** (Wajib borderless pastel).
3. **Dilarang memakai efek kaca kabur (*glassmorphism / blur*) pada area formulir kerja.**
4. **Dilarang membuat tombol aksi di bawah 44px tinggi.**
