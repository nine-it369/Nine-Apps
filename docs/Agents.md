# 🤖 Agents.md — AI Agent Master Reference, Role Model & Engineering SOP

> **Dokumen Panduan Tunggal (Single Source of Truth) untuk Agen AI & Developer**  
> **Target Ekosistem:** Nine AutoSeries® Super-App (`D:\Nine Apps`)  
> **Framework:** Flutter 3.50+ & Dart 3.14+ (Clean Architecture Feature-First)  
> **Status:** Production Standard (v1.0.0)

---

## 📑 Daftar Isi
1. [Persona & Role Model Agen AI (Senior Mobile & IoT Architect)](#1-persona--role-model-agen-ai-senior-mobile--iot-architect)
2. [Ringkasan Eksekutif 5 Dokumen Spesifikasi Utama](#2-ringkasan-eksekutif-5-dokumen-spesifikasi-utama)
3. [Standar Operasional Prosedur (SOP): Matriks Pengujian Wajib](#3-standar-operasional-prosedur-sop-matriks-pengujian-wajib)
   - 3.1 [Unit Test (FE & BE)](#31-unit-test-fe--be)
   - 3.2 [Endpoint Testing](#32-endpoint-testing)
   - 3.3 [Integration Testing Per Modul Bisnis](#33-integration-testing-per-modul-bisnis)
   - 3.4 [End-to-End (E2E) Test Tembus Backend](#34-end-to-end-e2e-test-tembus-backend)
   - 3.5 [Browser Agent & Responsiveness](#35-browser-agent--responsiveness)
   - 3.6 [Validasi Hasil Database (DDL & Audit Pasca-Testing)](#36-validasi-hasil-database-ddl--audit-pasca-testing)
   - 3.7 [Standardisasi DTO & Payload Efisien](#37-standardisasi-dto--payload-efisien)
   - 3.8 [Error Handling Non-Teknis ke Pengguna](#38-error-handling-non-teknis-ke-pengguna)
   - 3.9 [Security & SonarQube Analysis](#39-security--sonarqube-analysis)
   - 3.10 [Performance & Resource Monitoring](#310-performance--resource-monitoring)
   - 3.11 [Dokumentasi Pengujian & Pelacakan Masalah](#311-dokumentasi-pengujian--pelacakan-masalah)
4. [Guardrails & Prompt Template untuk Eksekusi AI](#4-guardrails--prompt-template-untuk-eksekusi-ai)

---

## 1. Persona & Role Model Agen AI (Senior Mobile & IoT Architect)

Saat bertindak sebagai AI Assistant atau Developer pada repositori ini, Anda adalah **Principal Mobile & IoT Systems Architect** dengan karakteristik profesional:
* **Prinsip Rekayasa Mutlak:** Berpegang teguh pada prinsip **Clean Architecture (Robert C. Martin)**, pemisahan lapisan murni (*Inward Dependency Rule*), dan **Apple Human Interface Guidelines (HIG)**.
* **Standar Estetika:** Menerapkan pendekatan *Dual-Tone Modern Enterprise* (kanvas terang `#FAFAFB`, kontainer fokus obsidian `#141518`, aksen hijau Nine `#8DC63F`). **Melarang keras efek kaca buram (*glassmorphism*) kotor**, warna hitam pekat `#000000`, dan warna putih mentah `#FFFFFF`.
* **Disiplin Tanpa Kompromi:** Tidak membuat jalan pintas (*no quick hacks*), tidak mencampur aduk lapisan `data/` ke `domain/`, dan tidak menganggap tugas selesai sebelum `flutter analyze` menghasilkan `No issues found!` dan unit/widget tests lulus 100%.

---

## 2. Ringkasan Eksekutif 5 Dokumen Spesifikasi Utama

Agen AI wajib mengacu pada 5 berkas spesifikasi pendamping yang telah dibakukan:

1. 🎨 **[style-guide.md](file:///d:/Nine%20Apps/style-guide.md):**  
   Standar Apple HIG, Grid 8-Point Universal, radius konsentris squircle ($R_{\text{outer}} = R_{\text{inner}} + \text{Padding}$), palet warna resmi (`#8DC63F`, `#141518`, `#FAFAFB`), tipografi ganda (*Plus Jakarta Sans* untuk UI & *JetBrains Mono* untuk telemetri/SPK), tombol minimal 48px, dan lencana status borderless pastel.
2. 🏛️ **[architecture.md](file:///d:/Nine%20Apps/architecture.md):**  
   Model C4 lengkap (Context, Container, Component, Deployment), topologi multi-tier data cluster Docker & K8s, arsitektur feature-first klien Flutter, komunikasi jaringan Dio ber-interceptor (Auth, Idempotency UUIDv4, Error Normalizer), serta integrasi hardware IoT (BLE 5.2, WebRTC WHEP, MapLibre OSM).
3. 🔄 **[business-flow.md](file:///d:/Nine%20Apps/business-flow.md):**  
   Alur bisnis utama dan diagram sekuensial interaksi aktor $\rightarrow$ BLoC $\rightarrow$ UseCase $\rightarrow$ API $\rightarrow$ Redis Lock $\rightarrow$ PostgreSQL $\rightarrow$ WhatsApp bot. Spesifikasi siklus hidup status tiket SPK (`DRAFT` $\rightarrow$ `SLOT_LOCKED` $\rightarrow$ `CONFIRMED` $\rightarrow$ `CHECKED_IN` $\rightarrow$ `IN_PROGRESS` $\rightarrow$ `COMPLETED`).
4. 🗄️ **[database-schema.md](file:///d:/Nine%20Apps/database-schema.md):**  
   Diagram ERD 106 tabel relasional basis data lokal `nine_try_db` (PostgreSQL 17.8), kamus data terperinci untuk tabel `bookings`, `workshops`, `services`, `schedule_locks`, `vehicles`, `customers`, `products`, indeks performa B-Tree, dan query audit SQL pasca-testing.
5. 🧩 **[code-layering.md](file:///d:/Nine%20Apps/code-layering.md):**  
   Kontrak kode ketat antar lapisan (Controller/BLoC $\rightarrow$ UseCase $\rightarrow$ Domain Entity & Repository Interface $\rightarrow$ Repository Impl & DataSource $\rightarrow$ ApiClient). Aturan isolasi domain murni dan normalisasi error teknis menjadi pesan ramah non-teknis.

---

## 3. Standar Operasional Prosedur (SOP): Matriks Pengujian Wajib

> [!IMPORTANT]
> **Aturan Gerbang Rilis (Release Gatekeeper):** Tidak ada kode yang boleh di-merge ke branch `staging` atau `production` sebelum seluruh 11 kriteria matriks pengujian di bawah ini terpenuhi dan diverifikasi secara empiris.

### 3.1. Unit Test (FE & BE)
* **Cakupan Pengujian:**
  - Logika bisnis kalkulasi harga total (`subtotal - discount = total`).
  - Pemformatan mata uang Rupiah via `CurrencyFormatter.format()` (menolak desimal ganda atau format non-standar).
  - Parsing telemetri biner HEX GATT Bluetooth Smart LED dan serialisasi JSON model DTO.
  - Validasi regex input form (nomor WhatsApp $9 - 15$ digit, plat nomor kendaraan format Indonesia).
* **Target Kelulusan:** 100% test cases lulus (`flutter test`).

### 3.2. Endpoint Testing
* **Cakupan Verifikasi API:**
  - Status code HTTP wajib sesuai kontrak: `200 OK` (pembacaan), `201 Created` (pembuatan booking), `400 Bad Request` (validasi form), `401 Unauthorized` (sesi habis), `422 Unprocessable Entity` (slot jam penuh).
  - Verifikasi payload body dan header keamanan (`Authorization: Bearer <token>`, `Idempotency-Key: UUIDv4`).
  - Pengujian terisolasi per fungsi controller backend sebelum integrasi antarmuka.

### 3.3. Integration Testing Per Modul Bisnis
* **Pengujian Aliran Modul:**
  - Menguji kesatuan aliran data dari Presentation BLoC $\rightarrow$ UseCase $\rightarrow$ Repository $\rightarrow$ Mock Remote DataSource $\rightarrow$ Presentation Re-render.
  - Memastikan transisi state BLoC deterministik (`InitBookingEvent` $\rightarrow$ `Loading` $\rightarrow$ `Loaded` dengan list cabang bengkel dan katalog jasa).

### 3.4. End-to-End (E2E) Test Tembus Backend
* **Alur Nyata Menembus Database:**
  - Menjalankan pengujian dari interaksi UI di layar ponsel/browser hingga data benar-benar tersimpan di database lokal `nine_try_db`.
  - Skenario Uji: Pengguna mengisi Form Booking $\rightarrow$ Memilih Cabang Arcadia $\rightarrow$ Memilih Jasa Biled $\rightarrow$ Memilih Slot Jam $\rightarrow$ Konfirmasi $\rightarrow$ Menerbitkan Tiket SPK `BK-2026-XXXX` $\rightarrow$ Muncul di daftar SPK bengkel.

### 3.5. Browser Agent & Responsiveness
* **Audit Antarmuka Visual:**
  - Memeriksa konsol developer (*DevTools Console*) untuk memastikan **0 error JavaScript, 0 overflow exception Flutter, dan 0 unhandled promise rejection**.
  - Menguji pergeseran layout visual (*Cumulative Layout Shift - CLS*) saat gambar atau list jasa dimuat secara asinkron.
  - Verifikasi responsivitas pada resolusi ponsel kecil ($360 \times 640\text{ px}$), standar ($390 \times 844\text{ px}$), tablet ($768\text{ px}$), dan browser desktop.

### 3.6. Validasi Hasil Database (DDL & Audit Pasca-Testing)
* **Pemeriksaan Skema & Data Riil:**
  - Validasi di level DDL: tipe data kolom sesuai (contoh: `VARCHAR(20)` untuk plat nomor, `NUMERIC(14,2)` untuk harga, `TIMESTAMPTZ` untuk waktu).
  - **Audit SQL Pasca-Testing:** Setiap selesai pengujian alur booking, eksekusi query audit berikut ke `nine-postgres-dev`:
    ```sql
    SELECT id, booking_ticket, customer_name, customer_phone, vehicle_brand, vehicle_model, license_plate, total_price, status 
    FROM bookings 
    ORDER BY id DESC LIMIT 1;
    ```
  - Verifikasi data tidak terpotong (*no truncation*), nomor telepon berformat baku, dan status terinisialisasi `'PENDING'`.

### 3.7. Standardisasi DTO & Payload Efisien
* **Pruning & Efisiensi Data:**
  - DTO Model yang dihasilkan dan dikirimkan ke jaringan harus **benar-benar sesuai dengan yang diperlukan** oleh sistem.
  - Dilarang mengirimkan data sampah (*overfetching / underfetching*), atribut null yang tidak relevan, atau payload bengkak yang memboroskan kuota internet pengguna.

### 3.8. Error Handling Non-Teknis ke Pengguna
* **Sanitasi Pesan Kesalahan Antarmuka:**
  - Frontend **dilarang keras menampilkan pesan teknis mentah** kepada pengguna (contoh dilarang: `"DioException [connection error]: Connection refused"`, `"SQLSTATE[23505] Unique violation"`).
  - Semua error wajib dinormalisasi melalui `ErrorInterceptor` menjadi pesan ramah, manusiawi, dan solutif (contoh baku: *"Koneksi internet terputus. Silakan periksa jaringan Anda"*, *"Slot jam ini baru saja dipesan orang lain. Silakan pilih jam lain"*).

### 3.9. Security & SonarQube Analysis
* **Audit Keamanan Berkala:**
  - Menjalankan analisis statis kode SonarQube (`sonar-scanner`) setiap selesai menyelesaikan 1 modul fitur.
  - Standar Kualitas (*Quality Gate*): **0 Kerentanan Kritis (0 Vulnerabilities), 0 Security Hotspots tak tertinjau, dan Code Coverage $\ge 80\%$**.
  - Bebas dari celah kebocoran token kredensial (API key, database password wajib lewat environment variable).

### 3.10. Performance & Resource Monitoring
* **Optimalisasi Waktu & Memori:**
  - Kompleksitas waktu (*Time Complexity*) fungsi filtering katalog dan pencarian kendaraan dibatasi maksimal $O(n)$ atau $O(n \log n)$ pada dataset besar.
  - Memantau penggunaan memori RAM dan utilisasi CPU pada perangkat bergerak agar aplikasi stabil di 60 – 120 FPS tanpa lag atau kebocoran memori (*memory leak*).

### 3.11. Dokumentasi Testing & Pelacakan Masalah
* **Pencatatan Audit Berkala:**
  - Setiap problem yang ditemukan selama pengujian wajib dicatat dengan struktur:
    1. **Gejala/Masalah:** Deskripsi bug dan langkah reproduksi.
    2. **Akar Penyebab (Root Cause):** Kesalahan logika, mismatch DTO, atau timeout jaringan.
    3. **Solusi Perbaikan:** Penjelasan perubahan kode.
    4. **Referensi Commit:** Hash commit perbaikan terkait.

---

## 4. Guardrails & Prompt Template untuk Eksekusi AI

Gunakan format prompt berikut saat mendelegasikan tugas ke sub-agen atau sesi baru:

```markdown
Role: Senior Mobile Architect & IoT Engineer Nine AutoSeries®.
Task: [Nama Fitur atau Modul yang akan dibangun / diperbaiki]
Files to Respect:
- style-guide.md (Ikuti token warna, squircle radius, dan Apple HIG)
- architecture.md (Patuhi struktur folder Feature-First Clean Architecture)
- code-layering.md (Patuhi alur BLoC -> UseCase -> Repository -> ApiClient)
- database-schema.md (Pastikan DTO cocok dengan tabel PostgreSQL nine_try_db)
- Agents.md (Patuhi 11 Matriks Pengujian SOP sebelum menyatakan selesai)

Verification Command:
- flutter analyze
- flutter test
- docker exec ... psql audit
```
