# Nine Garage Website — Design System & Style Guidelines

Dokumen ini adalah panduan gaya (*style guide*) dan sistem desain resmi untuk pengembangan **Nine Garage Web Platform**. Seluruh komponen UI, layout, dan gaya visual mengacu pada standar ini demi memastikan konsistensi antarmuka premium di seluruh halaman.

---

## 🗺️ Daftar Isi

1. [Filosofi Desain & Pondasi](#1-filosofi-desain--pondasi)
2. [Sistem Warna & Design Tokens](#2-sistem-warna--design-tokens)
3. [Tipografi & Micro-Typography](#3-tipografi--micro-typography)
4. [Komponen UI & Nuxt UI v4](#4-komponen-ui--nuxt-ui-v4)
5. [Pola Desain Khusus (Signature Patterns)](#5-pola-desain-khusus-signature-patterns)
6. [Sistem Ikon (Lucide)](#6-sistem-ikon-lucide)
7. [Animasi & Transisi](#7-animasi--transisi)
8. [Breakpoints & Desain Responsif](#8-breakpoints--desain-responsif)
9. [Katalog & Struktur Komponen Aktual](#9-katalog--struktur-komponen-aktual)
10. [Konvensi Kode & Best Practices](#10-konvensi-kode--best-practices)

---

## 1. Filosofi Desain & Pondasi

Website Nine Garage mengadopsi estetika **Modern Automotive Precision** yang terinspirasi oleh kesederhanaan, keterbacaan tinggi, dan kesan mewah ala ekosistem Apple:
- **Latar Bersih & Minimalis:** Dominasi warna putih bersih (`#ffffff`), off-white subtil (`#fbfbfd` / `#f5f5f7`), dan border halus (`#e8e8ed` / `#d2d2d7`).
- **Signature Emerald Accent:** Aksen warna hijau neon/emerald (`#22c55e`) yang menjadi identitas visual garasi spesialis pencahayaan (*lighting*) dan teknologi otomotif modern.
- **Micro-Typography:** Kombinasi huruf kecil (*small labels*) dengan ketebalan ekstra (*font-black*), huruf kapital penuh (*uppercase*), dan spasi antar-huruf yang renggang (*wide letter-spacing* `tracking-[0.2em]`).
- **Pondasi Teknologi:** Ditenagai oleh **Tailwind CSS v4** dan **Nuxt UI v4** (`@import "tailwindcss"; @import "@nuxt/ui";`).

---

## 2. Sistem Warna & Design Tokens

> [!IMPORTANT]
> **Single Source of Truth Desain:**  
> Sumber kebenaran definitif (*single source of truth*) seluruh token warna dan styling antarmuka adalah blok `@theme static` di [`app/assets/css/main.css`](file:///d:/Garage%20Website/Frontend/app/assets/css/main.css).  
> *Catatan Teknis / Footgun Alert:* File `tailwind.config.ts` di root adalah artefak *legacy/unused* yang memiliki konfigurasi warna saling bertentangan (`primary: #18181b` vs `#22c55e`). Pada runtime Tailwind CSS v4, aturan `@theme static` di `main.css` yang sepenuhnya mengendalikan styling aplikasi.

### 2.1. Palette Warna Inti

| Token CSS / Tailwind | Hex Value | Peran & Penggunaan |
|---|---|---|
| `--color-primary-500` / `accent` | `#22c55e` | Warna identitas utama: tombol aksi utama, active indicators, highlights |
| `--color-primary-600` | `#16a34a` | Hover state tombol primary |
| `--color-primary-700` | `#15803d` | Active / pressed state tombol primary |
| `--color-neutral-900` / `secondary`| `#1d1d1f` | Warna teks utama, heading, tombol gelap |
| `--color-neutral-600` | `#86868b` | Deskripsi teks sekunder, paragraf tubuh |
| `--color-neutral-400` | `#a1a1aa` | Placeholder input teks, ikon pasif |
| `--color-neutral-300` | `#d2d2d7` | Border sekunder, pembatas kontainer |
| `--color-neutral-200` | `#e8e8ed` | Border elemen standar, pembatas baris |
| `--color-neutral-100` | `#f5f5f7` | Background kontainer subtil, badge neutral |
| `--color-neutral-50` | `#fbfbfd` | Background input field, select menu |
| `--color-background` | `#ffffff` | Background kanvas dasar halaman |
| `--color-background-subtle` | `#f5f5f7` | Background kontainer section dan kartu |
| `--color-background-elevated`| `#ffffff` | Background kartu elevated & modal |
| `--color-border` | `#d2d2d7` | Warna border umum UI |
| `--color-success-500` | `#22c55e` | Status sukses, indikator ketersediaan |
| `--color-warning-500` | `#ff9f0a` | Status peringatan / perhatian |
| `--color-danger-500` | `#ff453a` | Status error, aksi pembatalan / hapus |

### 2.2. CSS Static Theme Definition (`app/assets/css/main.css`)

```css
@theme static {
  --color-primary: var(--color-primary-500);
  --color-secondary: var(--color-neutral-900);
  --color-accent: var(--color-primary-500);
  --color-success: var(--color-success-500);
  --color-warning: var(--color-warning-500);
  --color-danger: var(--color-danger-500);
  --color-neutral-50: #fbfbfd;
  --color-neutral-100: #f5f5f7;
  --color-neutral-200: #e8e8ed;
  --color-neutral-300: #d2d2d7;
  --color-neutral-400: #a1a1aa;
  --color-neutral-600: #86868b;
  --color-neutral-900: #1d1d1f;
  --color-background: #ffffff;
  --color-background-subtle: #f5f5f7;
  --color-background-elevated: #ffffff;
  --color-border: #d2d2d7;
  --color-primary-500: #22c55e;
  --color-primary-600: #16a34a;
  --color-primary-700: #15803d;
  --color-success-500: #22c55e;
  --color-warning-500: #ff9f0a;
  --color-danger-500: #ff453a;
  --ui-radius-xl: 1.25rem;
  --ui-radius-2xl: 1.5rem;
  --ui-radius-3xl: 2rem;
  --ui-input-background: var(--color-neutral-50);
  --ui-input-color: var(--color-neutral-900);
  --ui-input-border: var(--color-neutral-200);
  --ui-button-font-weight: 600;
  --ui-tabs-indicator-background: var(--color-primary-500);
  --ui-tabs-trigger-active-color: var(--color-neutral-900);
}
```

---

## 3. Tipografi & Micro-Typography

### 3.1. Font Family
Font utama aplikasi:
```css
font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
```

### 3.2. Skala Ukuran Font

| Kelas Tailwind | Ukuran | Contoh Penggunaan |
|---|---|---|
| `text-[9px]` | 9px | Badge status mini, tag kategori kecil |
| `text-[11px]`| 11px | Label navigasi atas/bawah, uppercase metadata |
| `text-xs` | 12px | Keterangan pembantu, estimasi menit |
| `text-sm` | 14px | Deskripsi produk singkat, input text |
| `text-base` | 16px | Paragraf reguler, teks isi konten |
| `text-lg` | 18px | Sub-judul section, judul kartu |
| `text-xl` | 20px | Judul kartu besar, sub-heading modal |
| `text-2xl` | 24px | Judul halaman sekunder, ringkasan harga |
| `text-3xl` s.d. `text-5xl` | 30px - 48px | Hero header beranda, judul landing banner |

### 3.3. Gaya Huruf Khas (Signature Uppercase Label)

```vue
<!-- Label Navigasi Premium -->
<span class="text-[11px] font-black uppercase tracking-[0.2em] text-neutral-900">
  Catalog
</span>

<!-- Badge Tag Status -->
<span class="text-[9px] font-black uppercase tracking-wider px-2 py-0.5 rounded-full bg-primary-500/10 text-primary-600">
  Bi-LED Matrix
</span>
```

---

## 4. Komponen UI & Nuxt UI v4

Pengembangan menggunakan pustaka komponen resmi **Nuxt UI v4** (`@nuxt/ui: "^4.3.0"`). Seluruh komponen dasar dikonfigurasi secara terpusat di `app/app.config.ts`.

### 4.1. Input & Form Fields
Semua input otomatis menggunakan background halus `!bg-neutral-50`, border `!border-neutral-200`, dan teks gelap `!text-neutral-900`. Placeholder selalu menggunakan `#a1a1aa`.

```vue
<!-- Nuxt UI Form Field -->
<UFormField label="Nomor WhatsApp" name="phone" required>
  <UInput v-model="phone" placeholder="Contoh: 081234567890" icon="i-lucide-phone" />
</UFormField>
```

### 4.2. Tombol (UButton)
- **Primary Action**: `<UButton color="primary">Lanjutkan</UButton>` (Background `#22c55e` dengan font weight 600).
- **Secondary / Neutral**: `<UButton color="neutral" variant="outline">Kembali</UButton>`.
- **Ghost Action**: `<UButton variant="ghost" color="neutral">Batal</UButton>`.

### 4.3. Dialog & Drawer
Untuk navigasi mobile dan filter, digunakan komponen `UDrawer` yang responsif dengan snap points dan backdrop blur `bg-elevated/75`.

---

## 5. Pola Desain Khusus (Signature Patterns)

### 5.1. Selectable Item Card (`app/components/booking/SelectableItemCard.vue`)
Kartu interaktif untuk memilih paket atau layanan dalam alur booking. Memiliki radius lengkung besar (`rounded-[2.5rem]`) dan ring aktif hijau:

```vue
<div
  class="bg-white rounded-[2.5rem] p-4 border transition-all duration-500 cursor-pointer"
  :class="[
    isSelected
      ? 'border-primary-500 ring-2 ring-primary-500/20 shadow-md'
      : 'border-neutral-100 hover:border-primary-200 shadow-sm'
  ]"
  @click="handleSelect"
>
  <div class="relative w-full aspect-video rounded-3xl overflow-hidden bg-neutral-100 mb-3">
    <img :src="item.imageUrl" :alt="item.name" class="w-full h-full object-cover" />
  </div>
  <h3 class="font-bold text-neutral-900 text-base">{{ item.name }}</h3>
  <p class="text-primary-600 font-extrabold text-sm mt-1">Rp {{ formatNumber(item.price) }}</p>
</div>
```

### 5.2. Glassmorphism Sticky Header
Header navigasi global memiliki efek buram transparan saat di-scroll:

```vue
<header
  :class="[
    'sticky top-0 z-50 transition-all duration-500',
    isScrolled
      ? 'bg-white/70 backdrop-blur-xl border-b border-neutral-200/50 py-3 shadow-sm'
      : 'bg-transparent py-5'
  ]"
>
  <!-- Content -->
</header>
```

### 5.3. Digital Signature Canvas Pad (`app/components/work-order/SignaturePad.vue`)
Kanvas tanda tangan dengan rasio aspek 1:1, mendukung sentuhan jari (*touch screen*) dan cursor mouse, mengekspor hasil ke format Blob PNG untuk arsip serah terima digital work order.

---

## 6. Sistem Ikon (Lucide)

Menggunakan kumpulan ikon **Lucide** melalui modul resmi `@nuxt/ui` dan `@iconify-json/lucide`. Seluruh ikon dipanggil dengan awalan `i-lucide-*`.

```vue
<!-- Contoh Pemanggilan Ikon -->
<UIcon name="i-lucide-wrench" class="w-5 h-5 text-primary-600" />
<UIcon name="i-lucide-calendar" class="w-4 h-4 text-neutral-600" />
<UIcon name="i-lucide-check-circle" class="w-6 h-6 text-emerald-500" />
```

---

## 7. Animasi & Transisi

1. **Tailwind Transitions:**
   - Gunakan `transition-all duration-300 ease-out` untuk efek hover tombol dan kartu.
   - Gunakan `transition-transform duration-500 hover:scale-[1.02]` untuk hover kartu produk.
2. **GSAP Micro-Interactions:**
   - Digunakan pada elemen dinamis seperti pengungkapan harga promosi (`PriceRevealAnimation.vue`) atau transisi multi-step stepper.

---

## 8. Breakpoints & Desain Responsif

Mengikuti standar responsif mobile-first Tailwind CSS:

| Breakpoint | Target Layar | Rekomendasi Layout |
|---|---|---|
| `< 640px` | Smartphone | Single column, sticky bottom action bar, bottom drawer |
| `640px - 767px` (`sm:`) | Large Phone / Phablet | 2 columns grid |
| `768px - 1023px` (`md:`) | Tablet / iPad | 2 - 3 columns grid, compact sidebar |
| `1024px - 1279px` (`lg:`) | Laptop / Desktop | 3 - 4 columns grid, sticky summary panel |
| `>= 1280px` (`xl:`) | High-res Desktop | Max-width container `container mx-auto px-6` |

---

## 9. Katalog & Struktur Komponen Aktual

Seluruh komponen antarmuka dikelompokkan secara modular di dalam `app/components/` berdasarkan domain bisnis (seperti `booking/`, `account/`, `auth/`, `home/`, `loading/`, `promo/`, `work-order/`).

> [!TIP]
> **Daftar Lengkap 65 Komponen:**  
> Rincian lengkap katalog 65 komponen aktif, struktur sub-direktori, konvensi penamaan file PascalCase, standar Props/Emits, serta integrasi store Pinia didokumentasikan secara terpusat pada **[`COMPONENTS.md`](./COMPONENTS.md)**.


---

## 10. Konvensi Kode & Best Practices

1. **Selalu Gunakan `<script setup lang="ts">`**: Menjamin type-safety dan performa kompilasi Vue 3 terbaik.
2. **Deklarasikan Props & Emits secara Eksplisit**:
   ```typescript
   interface Props {
     item: SellableItem;
     isSelected?: boolean;
   }
   const props = withDefaults(defineProps<Props>(), {
     isSelected: false,
   });
   const emit = defineEmits<{
     select: [id: number];
   }>();
   ```
3. **Format Mata Uang & Angka**:
   - Selalu format mata uang dalam Rupiah (`Rp 3.500.000`) menggunakan utilitas sentral, hindari hardcoded string acak.
4. **Hindari Magic Numbers & Hardcoded Color Hex di Template**:
   - Gunakan utility classes dari design token (`text-primary-600`, `bg-neutral-50`, `border-neutral-200`) alih-alih `style="color: #22c55e"`.
5. **Gunakan Logger Sentral**:
   - Gunakan `logger` dari `~/utils/logger` alih-alih `console.log` mentah di lingkungan produksi.
