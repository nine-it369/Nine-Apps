# Nine Mall Style Guidelines & Design System

Dokumen ini berisi panduan gaya desain (*Design System*) resmi untuk **Nine Mall Web Platform**. Seluruh pengembang wajib mengikuti pedoman ini guna menjaga konsistensi visual, estetika premium bernuansa otomotif, aksesibilitas, dan performa tinggi di seluruh antarmuka web.

---

## 🎨 Filosofi Desain

Nine Mall mengadopsi prinsip desain antarmuka e-commerce modern berstandar tinggi:
1. **Automotive Premium Aesthetic**: Nuansa warna gelap solid (*Dark Slate & Zinc-900*) berpadu dengan aksen emerald green (*Green-500*) yang mencerminkan presisi mekanis dan kualitas tinggi aksesori modifikasi otomotif.
2. **Clarity & High Contrast (Light Mode Primary)**: Seluruh katalog belanja dan proses checkout diprioritaskan dalam mode terang (*Light Mode*) dengan kontras teks tinggi untuk keterbacaan optimal spesifikasi produk dan rincian nominal pembayaran.
3. **Micro-Typography & Information Density**: Menggunakan skala tipografi mikro terukur (`text-[9px]` & `text-[11px]`) dengan pelacakan huruf lebar (*uppercase tracking*) untuk badge teknis, tipe soket, dan status garansi, dipadukan dengan tipografi judul yang tegas.
4. **Frictionless Shopping Flow**: Elemen interaktif memiliki target sentuh ramah jempol (*thumb-friendly*), sticky action bar di mobile, dan transisi halus (GSAP micro-animations) tanpa animasi berlebihan yang membebani browser.

---

## 🌈 Sistem Warna & Token Tema

Palet warna dikonfigurasi melalui Tailwind CSS v4 di [`app/assets/css/main.css`](file:///d:/Frontend-Mall/app/assets/css/main.css) dan Nuxt UI v3 di [`app/app.config.ts`](file:///d:/Frontend-Mall/app/app.config.ts).

### 1. Palette Warna Inti

| Token Nama | Nilai HEX | Kelas Tailwind | Penggunaan Utama |
|---|---|---|---|
| **`primary`** | `#18181b` | `bg-primary-900`, `text-primary-900` | Header navbar, tombol checkout utama, teks heading, border aktif |
| **`secondary`** | `#71717a` | `text-primary-500`, `border-neutral-300` | Teks sekunder, label formulir, garis pembatas, icon tidak aktif |
| **`accent` / `success`** | `#22c55e` | `bg-accent-500`, `text-accent-500` | Badge diskon, tombol konfirmasi, status settlement, saldo Nine Koin |
| **`danger`** | `#ef4444` | `bg-danger-500`, `text-danger-500` | Notifikasi error, tombol batalkan pesanan, peringatan stok habis |
| **`warning`** | `#f59e0b` | `bg-warning-500`, `text-warning-500` | Hitung mundur batas transfer, status pending, stok menipis |
| **`info`** | `#3b82f6` | `bg-info-500`, `text-info-500` | Banner pelacakan resi AWB, tautan bantuan, informasi pengiriman |
| **`surface`** | `#fafafa` | `bg-neutral-50` | Latar belakang input form, card checkout, background halaman |

---

### 2. Token Tailwind CSS v4 (`main.css`)

```css
@theme {
  /* Primary — Dark, Premium Automotive Feel */
  --color-primary-50: #fafafa;
  --color-primary-100: #f4f4f5;
  --color-primary-200: #e4e4e7;
  --color-primary-300: #d4d4d8;
  --color-primary-400: #a1a1aa;
  --color-primary-500: #71717a;
  --color-primary-600: #52525b;
  --color-primary-700: #3f3f46;
  --color-primary-800: #27272a;
  --color-primary-900: #18181b;
  --color-primary-950: #09090b;

  /* Accent & Success — Green Signature Highlights */
  --color-accent-50: #f0fdf4;
  --color-accent-500: #22c55e;
  --color-accent-600: #16a34a;
  --color-accent-700: #15803d;

  /* Danger — Red Alerts */
  --color-danger-50: #fef2f2;
  --color-danger-500: #ef4444;
  --color-danger-600: #dc2626;

  /* Warning — Amber Pending States */
  --color-warning-50: #fffbeb;
  --color-warning-500: #f59e0b;
}
```

---

### 3. Override Tema Nuxt UI (`app.config.ts`)

```typescript
export default defineAppConfig({
  ui: {
    colors: {
      primary: 'primary',
      secondary: 'neutral',
      neutral: 'zinc',
    },
    // Input — latar terang bersih dengan placeholder kontras
    input: {
      slots: {
        base: '!bg-neutral-50 !text-neutral-900',
        input: 'placeholder:!text-neutral-400',
      },
    },
    // Select — konsistensi latar belakang input
    select: {
      slots: {
        base: '!bg-neutral-50 !text-neutral-900',
      },
    },
    // SelectMenu — highlight abu-abu lembut saat hover
    selectMenu: {
      slots: {
        item: 'data-[highlighted]:bg-primary-100 data-highlighted:text-primary-900',
      },
    },
  },
});
```

---

## 🔤 Tipografi & Skala Mikro (Micro-Typography)

Nine Mall memanfaatkan perpaduan skala teks standar dengan mikro-tipografi untuk mempertegas spesifikasi teknis otomotif:

| Skala Kelas | Ukuran | Bobot & Tracking | Penggunaan |
|---|---|---|---|
| **`text-[9px]`** | 9px | `font-black uppercase tracking-wider` | Chip status stok ("READY"), label kendaraan ("MOBIL") |
| **`text-[11px]`** | 11px | `font-bold uppercase tracking-[0.15em]` | Label SKU, breadcrumb, tab filter, header kolom keranjang |
| **`text-xs`** | 12px | `font-normal / font-medium` | Deskripsi kurir, estimasi hari tiba, petunjuk input |
| **`text-sm`** | 14px | `font-normal / font-semibold` | Teks tubuh utama, nama opsi varian, rincian biaya |
| **`text-base`** | 16px | `font-bold` | Nama produk di katalog, subtotal item, teks tombol |
| **`text-lg`** | 18px | `font-black` | Harga produk reguler, judul modal dialog |
| **`text-xl`** | 20px | `font-extrabold` | Harga headline flash sale, judul section beranda |
| **`text-2xl`** | 24px | `font-black tracking-tight` | Grand Total di checkout dan instruksi pembayaran |

```vue
<!-- Contoh Penerapan Badge Status & Harga -->
<span class="inline-flex items-center px-2 py-0.5 rounded text-[9px] font-black uppercase tracking-wider bg-accent-100 text-accent-800">
  Flash Sale
</span>

<p class="text-sm font-semibold text-primary-900">
  Biled Matrix E9 Pro 3.0 Inch
</p>

<p class="text-xl font-black text-primary-900">
  Rp 1.299.000
</p>
```

---

## 🧩 Pola Komponen & State Antarmuka

### 1. Tombol Aksi (Buttons)
- **Tombol Primary (Aksi Belanja / Checkout)**:
  ```vue
  <UButton
    color="primary"
    size="lg"
    class="w-full justify-center font-bold tracking-wide rounded-xl shadow-sm hover:shadow transition-all"
  >
    Bayar Sekarang
  </UButton>
  ```
- **Tombol Secondary (Aksi Batal / Kembali)**:
  ```vue
  <UButton
    variant="ghost"
    color="neutral"
    class="font-semibold text-neutral-600 hover:text-neutral-900"
  >
    Ubah Metode Pembayaran
  </UButton>
  ```

---

### 2. Kartu Item Terpilih (Selectable Card Pattern)
Komponen kartu (seperti varian pada `CartItemVariantCard.vue` atau metode bayar di `CheckoutPayment.vue`) memiliki indikator aktif yang jelas:

```vue
<div
  :class="[
    'p-4 rounded-xl border transition-all cursor-pointer',
    isSelected
      ? 'border-accent-500 bg-accent-50/30 ring-2 ring-accent-500/20'
      : 'border-neutral-200 hover:border-neutral-300 bg-white'
  ]"
>
  <!-- Konten Kartu -->
</div>
```

---

### 3. Bilah Aksi Bawah Mobile (Fixed Bottom Bar)
Pada viewport mobile (`< 768px`), tombol penting seperti keranjang belanja dan checkout terkunci di bagian bawah layar agar mudah dijangkau satu tangan:

```vue
<div class="md:hidden fixed bottom-0 left-0 right-0 z-40 bg-white border-t border-neutral-200 p-4 shadow-lg backdrop-blur-md bg-white/95">
  <div class="flex items-center justify-between gap-4">
    <div>
      <p class="text-[11px] text-neutral-500 font-medium uppercase tracking-wider">Total Pembayaran</p>
      <p class="text-lg font-black text-primary-900">{{ formatRupiah(totalAmount) }}</p>
    </div>
    <UButton color="primary" size="lg" class="px-6 font-bold">
      Lanjut ke Bayar
    </UButton>
  </div>
</div>
```

---

## 📱 Breakpoint Responsif & Konvensi Layout

Nine Mall menerapkan pendekatan **Mobile-First** dengan 4 breakpoint standar:

| Breakpoint | Lebar Layar | Strategi Layout |
|---|---|---|
| **Mobile (`default`)** | `< 640px` | 1 kolom penuh, fixed bottom action bar, slideover drawer untuk filter/alamat |
| **Tablet (`sm` / `md`)** | `640px - 1023px` | Grid katalog 2 kolom, modal popover varian, layout checkout kartu vertikal |
| **Desktop (`lg`)** | `1024px - 1279px` | Grid katalog 3-4 kolom, sidebar filter kategori kiri, checkout 2 kolom (65% form / 35% ringkasan) |
| **Wide Desktop (`xl`)** | `≥ 1280px` | Maksimal lebar kontainer `max-w-7xl mx-auto`, padding horizontal konsisten `px-4 sm:px-6 lg:px-8` |

---

## 🛡️ Konvensi Kode Styling

1. **Dilarang Menulis Warna Acak (No Arbitrary Colors)**: Dilarang menggunakan warna bebas seperti `text-[#333]` atau `bg-[#25D366]` di dalam komponen. Wajib menggunakan token semantik Tailwind atau variabel tema (misal `text-primary-900`, `bg-accent-500`).
2. **Kerapian Utility Class**: Urutkan kelas Tailwind dengan urutan logis: *Layout & Display* $\rightarrow$ *Spacing & Sizing* $\rightarrow$ *Typography* $\rightarrow$ *Colors & Borders* $\rightarrow$ *Effects & Transitions*.
3. **Format Uang Konsisten**: Seluruh tampilan nominal mata uang wajib menggunakan helper sentral `formatRupiah(value)` (menghasilkan format `Rp 1.250.000` dengan pemisah titik).
