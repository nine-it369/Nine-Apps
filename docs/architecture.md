# 🏛️ Nine AutoSeries® Super-App — System Architecture & Infrastructure Blueprint

> **Standar Rekayasa:** C4 Architectural Model & Clean Distributed Systems  
> **Target Ekosistem:** Mobile Native (Flutter 3.50+), Web Portal (Nuxt 4 / Vue 3), Backend Services (Golang Gin), Database (PostgreSQL 17 HA & Redis 7 HA)  
> **Status:** Production-Ready (v1.0.0)

---

## 📑 Daftar Isi
1. [Tinjauan Arsitektur Tingkat Tinggi](#1-tinjauan-arsitektur-tingkat-tinggi)
2. [Model C4 Arsitektur Sistem](#2-model-c4-arsitektur-sistem)
   - 2.1 [Level 1: System Context Diagram](#21-level-1-system-context-diagram)
   - 2.2 [Level 2: Container Diagram](#22-level-2-container-diagram)
   - 2.3 [Level 3: Component Diagram (Flutter Mobile Client)](#23-level-3-component-diagram-flutter-mobile-client)
   - 2.4 [Level 4: Network & Deployment Topology](#24-level-4-network--deployment-topology)
3. [Arsitektur Klien Mobile (Flutter Feature-First Clean Architecture)](#3-arsitektur-klien-mobile-flutter-feature-first-clean-architecture)
4. [Protokol Jaringan, Interceptors & Idempotensi](#4-protokol-jaringan-interceptors--idempotensi)
5. [Integrasi Hardware & Aksesoris IoT](#5-integrasi-hardware--aksesoris-iot)
6. [Keamanan Data & Kontrol Konkurensi](#6-keamanan-data--kontrol-konkurensi)

---

## 1. Tinjauan Arsitektur Tingkat Tinggi

Ekosistem digital **Nine AutoSeries®** mengintegrasikan pengalaman pengguna multi-platform (*Omnichannel Mobility*) yang menghubungkan aplikasi mobile konsumen, portal operasional bengkel web, broker telemetri IoT berkecepatan tinggi, dan klaster basis data relasional:

```mermaid
graph TB
    subgraph "Klien Interaksi (Presentation Tier)"
        MOB["📱 Nine Apps Mobile<br>(Flutter 3.50+ • Pelanggan & Pemilik Kendaraan)"]
        WEB["💻 Garage Website Portal<br>(Nuxt 4 / Vue 3 • Web Pelanggan & Resepsionis)"]
        ADMIN["🖥️ Directus Headless CMS<br>(Manajemen Konten, Katalog Produk & Hak Akses)"]
    end

    subgraph "API Gateway & Reverse Proxy Tier"
        TRAEFIK["🛡️ Traefik / Nginx Gateway<br>SSL Termination • Rate Limiting • Routing :80/:443"]
    end

    subgraph "Layanan Backend Core Engine (Golang)"
        GARAGE_API["⚡ nine-garage-api (:8080)<br>Booking Servis, SPK Digital, Workshop Slots"]
        MALL_API["🛒 nine-mall-api (:8081)<br>Katalog Sparepart, Keranjang, Vehicle Matchmaker"]
        IOT_GATEWAY["🛰️ IoT Telemetry Ingestion (EMQX / Go Worker)<br>GPS Tracking, Alert Aki, MediaMTX WebRTC Stream"]
    end

    subgraph "Data & Persistence Tier"
        PG[("🐘 PostgreSQL 17 (nine_try_db :5432)<br>106 Tabel Relasional • PostGIS • Auditing")]
        REDIS[("🔴 Redis 7 Cluster (:6379)<br>10-Min Capacity Lock, Sesi JWT, Cache Kategori")]
        S3[("🪣 MinIO / S3 Object Storage<br>Media Produk, Rekaman Incident Vault Dashcam")]
    end

    subgraph "Layanan Pihak Ketiga (External Cloud Providers)"
        MIDTRANS["💳 Midtrans Payment Gateway (QRIS, VA, E-Wallet)"]
        JNT["🚚 J&T Express Logistics API (Tarif & Resi Live)"]
        CHATWOOT["💬 WhatsApp Bot (n8n / Chatwoot Alert)"]
    end

    MOB -->|"HTTPS TLS 1.3 / Dio"| TRAEFIK
    WEB -->|"HTTPS / Nuxt $fetch"| TRAEFIK
    ADMIN -->|"HTTP / REST"| TRAEFIK

    TRAEFIK --> GARAGE_API
    TRAEFIK --> MALL_API
    TRAEFIK --> IOT_GATEWAY

    GARAGE_API --> PG
    GARAGE_API --> REDIS
    MALL_API --> PG
    MALL_API --> REDIS

    GARAGE_API --> CHATWOOT
    MALL_API --> MIDTRANS
    MALL_API --> JNT
    IOT_GATEWAY --> S3
```

---

## 2. Model C4 Arsitektur Sistem

### 2.1 Level 1: System Context Diagram
Diagram ini memperlihatkan batas sistem (*system boundary*) ekosistem Nine AutoSeries® beserta interaksi eksternalnya:

```mermaid
C4Context
    title System Context Diagram - Nine AutoSeries® Platform
    
    Person(pelanggan, "Pelanggan / Pemilik Kendaraan", "Mengelola kendaraan di Cockpit, reservasi servis bengkel, belanja sparepart, dan monitoring GPS/Dashcam.")
    Person(mekanik, "Mekanik & Resepsionis Bengkel", "Memvalidasi tiket Digital SPK, mengalokasikan pit mekanik, dan memperbarui status pengerjaan.")

    System(nine_ecosystem, "Nine AutoSeries® Ecosystem", "Platform otomotif cerdas terpadu (Mobile App, Web Portal & Core Backend Services).")

    System_Ext(midtrans_gw, "Midtrans Payment Engine", "Pemroses transaksi digital (QRIS, E-Wallet, VA Bank).")
    System_Ext(jnt_api, "J&T Express API", "Kalkulasi ongkos kirim real-time dan pelacakan status AWB.")
    System_Ext(wa_engine, "WhatsApp Automation (n8n)", "Pengiriman notifikasi tiket SPK dan alarm darurat G-Sensor.")

    Rel(pelanggan, nine_ecosystem, "Reservasi Booking, Kontrol LED, Pantau GPS", "HTTPS / BLE")
    Rel(mekanik, nine_ecosystem, "Kelola Tiket SPK & Alokasi Mekanik", "Web Admin HTTPS")
    Rel(nine_ecosystem, midtrans_gw, "Inisiasi Snap Token & Verifikasi Notifikasi Webhook", "REST API")
    Rel(nine_ecosystem, jnt_api, "Cek Tarif & Generate AirWayBill", "REST API")
    Rel(nine_ecosystem, wa_engine, "Trigger Alert WhatsApp", "Webhook POST")
```

### 2.2 Level 2: Container Diagram
Diagram container memetakan seluruh aplikasi independen yang berjalan di dalam arsitektur:

```mermaid
graph TD
    subgraph "Client Applications"
        A[Nine Apps Flutter Mobile<br>Dart 3.14 • BLoC • GoRouter]
        B[Garage Website Nuxt 4<br>Vue 3 • Pinia • Tailwind]
    end

    subgraph "API & Routing Gateway"
        C[Traefik / Nginx Ingress<br>Port :80 / :443 • Reverse Proxy]
    end

    subgraph "Backend Workloads (Docker Containers)"
        D[nine-garage-dev :8080<br>Golang Gin • Booking & Workshop Logic]
        E[nine-mall-dev :8081<br>Golang Gin • E-Commerce & Checkout Engine]
        F[nine-directus-dev :8055<br>Node.js • Headless CMS & Admin Control]
    end

    subgraph "Data Storage Systems"
        G[(PostgreSQL 17 :5432<br>Database: nine_try_db)]
        H[(Redis 7 :6379<br>Capacity Mutex & Session Cache)]
    end

    A -->|REST JSON / HTTP| C
    B -->|REST JSON / HTTP| C
    C -->|Proxy to :8080| D
    C -->|Proxy to :8081| E
    C -->|Proxy to :8055| F

    D -->|SQL Queries & Tx| G
    D -->|10-Min Locks / GEO| H
    E -->|SQL Queries & Tx| G
    E -->|Cart Caching| H
    F -->|Directus Collections| G
```

### 2.3 Level 3: Component Diagram (Flutter Mobile Client)
Struktur komponen di dalam aplikasi mobile mengadopsi prinsip **Feature-First Clean Architecture**:

```mermaid
graph TD
    subgraph PresentationLayer["1. PRESENTATION LAYER (lib/features/garage/presentation)"]
        UI["BookingStepperScreen / GarageLandingScreen"]
        BLOC["BookingBloc (Event ➔ State Machine)"]
        WIDGETS["Section Widgets (Contact, Vehicle, Service, Schedule, Review)"]
    end

    subgraph DomainLayer["2. DOMAIN LAYER (lib/features/garage/domain)"]
        ENT["Entities (WorkshopEntity, ServiceEntity, BookingEntity)"]
        UC["UseCases (GetWorkshops, GetServices, GetAvailability, SubmitBooking)"]
        REPO_INT["Repository Interface (IGarageRepository)"]
    end

    subgraph DataLayer["3. DATA LAYER (lib/features/garage/data)"]
        REPO_IMPL["GarageRepositoryImpl"]
        REMOTE["GarageRemoteDataSourceImpl"]
        MODELS["Models (WorkshopModel, ServiceModel, BookingModel)"]
    end

    subgraph CoreLayer["4. CORE & SHARED (lib/core & lib/shared)"]
        CLIENT["ApiClient (Dio Client + Interceptors)"]
        DI["GetIt Service Locator (injection.dart)"]
        THEME["AppTheme & HIG Design Tokens"]
    end

    UI --> BLOC
    BLOC --> WIDGETS
    BLOC --> UC
    UC --> REPO_INT
    REPO_IMPL -.-> REPO_INT
    REPO_IMPL --> REMOTE
    REMOTE --> MODELS
    REMOTE --> CLIENT
    DI -.-> REPO_IMPL
    DI -.-> UC
    DI -.-> BLOC
```

### 2.4 Level 4: Network & Deployment Topology
Topologi jaringan lokal Docker dan cluster target produksi:

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                            INTERNET (PUBLIC WAN)                             │
│  [Mobile Klien: Android / iOS]               [Web Klien: Chrome / Safari]   │
└──────────────────────────────────────┬───────────────────────────────────────┘
                                       │ HTTPS (Port 443) / DNS Traefik
                                       ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                     GATEWAY TIER (LOCAL / K8S INGRESS)                       │
│  Traefik Edge Proxy:                                                         │
│  • /api/v1/workshops, /api/v1/bookings  ──► nine-garage-dev:8080            │
│  • /api/v1/products, /api/v1/cart       ──► nine-mall-dev:8081              │
│  • /assets, /items/*                    ──► nine-directus-dev:8055          │
└──────────────────────────────────────┬───────────────────────────────────────┘
                                       │ Docker Bridge Network / CNI
                                       ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                    APPLICATION SUBNET (BACKEND SERVICES)                     │
│  ┌───────────────────────────────┐     ┌──────────────────────────────────┐  │
│  │ nine-garage-dev (:8080)       │     │ nine-mall-dev (:8081)            │  │
│  └───────────────┬───────────────┘     └─────────────────┬────────────────┘  │
└──────────────────┼───────────────────────────────────────┼───────────────────┘
                   │ SQL Connection / Redis Protocol       │
                   ▼                                       ▼
┌──────────────────────────────────────────────────────────────────────────────┐
│                         DATA TIER (PERSISTENCE)                              │
│  ┌─────────────────────────────────┐   ┌──────────────────────────────────┐  │
│  │ PostgreSQL 17 (nine-postgres-dev)│  │ Redis 7 (nine-redis-dev)         │  │
│  │ Port: 5432 • DB: nine_try_db    │   │ Port: 6379 • DB Index 0 & 4     │  │
│  │ User: nine_dev                  │   │ Mutex Lock & Temporary Caching   │  │
│  └─────────────────────────────────┘   └──────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Arsitektur Klien Mobile (Flutter Feature-First Clean Architecture)

Aplikasi mobile mengisolasi modul bisnis ke dalam folder `features/garage/` dengan hierarki berikut:

```
features/garage/
├── domain/                                    # Logika Bisnis Murni (Bebas Framework)
│   ├── entities/                              # Model entitas immutable
│   ├── repositories/                          # Kontrak antarmuka IGarageRepository
│   └── usecases/                              # Single Responsibility Use Cases
├── data/                                      # Sumber Data & Serialisasi
│   ├── datasources/                           # Remote API DataSource via Dio
│   ├── models/                                # DTO dengan mapping JSON (fromJson/toJson)
│   └── repositories/                          # Implementasi konkret repository
└── presentation/                              # Antarmuka Pengguna Reaktif
    ├── blocs/                                 # BLoC, Event, dan State Machine
    ├── screens/                               # Halaman penuh (Landing, Stepper, Success)
    └── widgets/                               # Komponen spesifik form booking
```

### Aliran Data Satu Arah (Unidirectional Data Flow - UDF):
1. **User Action:** Pengguna memilih cabang bengkel di `ScheduleSectionWidget`.
2. **Event Dispatched:** Widget memicu `SelectWorkshopEvent(workshop)` ke `BookingBloc`.
3. **State Mutation:** `BookingBloc` memanggil `GetAvailabilityUseCase` dan meng-emit state `BookingState(selectedWorkshop: ws, timeSlots: slots)`.
4. **Re-render:** `ScheduleSectionWidget` bereaksi dan menampilkan slot jam yang tersedia secara reaktif tanpa efek kedip (*smooth reactivity*).

---

## 4. Protokol Jaringan, Interceptors & Idempotensi

Setiap request HTTP dari aplikasi mobile diatur melalui 3 interceptor otomatis di dalam `ApiClient`:

1. **`AuthInterceptor`:** Menyuntikkan token `Authorization: Bearer <JWT>` secara otomatis jika sesi autentikasi tersedia.
2. **`IdempotencyInterceptor`:** Pada operasi mutasi data (`POST`, `PUT`, `PATCH`, `DELETE` — khususnya pembuatan booking servis `/bookings`), interceptor secara otomatis menyematkan header unik:
   ```http
   Idempotency-Key: 550e8400-e29b-41d4-a716-446655440000
   ```
   Hal ini menjamin bahwa jika koneksi terputus saat pengguna menekan tombol *"Konfirmasi Booking"*, pengiriman ulang tidak akan menghasilkan duplikasi tiket SPK di database.
3. **`ErrorInterceptor`:** Menerjemahkan respons status code HTTP (`400`, `401`, `422`, `500`) dan kegagalan jaringan menjadi objek `ServerException` dan `NetworkException` dengan pesan ramah non-teknis.

---

## 5. Integrasi Hardware & Aksesoris IoT

* **Smart LED Headlight & Demon Eye:** Dikendalikan secara nirkabel melalui Bluetooth Low Energy (**BLE 5.2**) menggunakan `flutter_blue_plus`. Mengirimkan frame biner HSV GATT langsung ke kontroler tanpa ketergantungan internet.
* **4K Smart Dashcam:** Menampilkan streaming langsung latensi rendah ($<350\text{ ms}$) menggunakan protokol **WebRTC WHEP** (`flutter_webrtc`) yang dialirkan melalui server MediaMTX.
* **GPS Telematics Tracker:** Membaca posisi satelit via API ingest Go/EMQX, ditampilkan di peta vektor OpenStreetMap menggunakan `maplibre_gl` (tanpa biaya Google Maps API).

---

## 6. Keamanan Data & Kontrol Konkurensi

1. **10-Minute Redis Capacity Lock:** Saat pengguna memilih slot jam dan memasuki tahap review, backend mengunci kapasitas mekanik di Redis selama 600 detik (`lock:slot:{workshop_id}:{date}:{slot}`) untuk mencegah *double booking* antar pelanggan.
2. **Enkripsi PII Data Pelanggan:** Nama, nomor telepon, dan plat nomor dilindungi sesuai UU PDP No. 27/2022.
3. **Audit Logging:** Setiap perubahan status tiket booking dicatat di tabel `audit_logs` dengan timestamp atomik server.
