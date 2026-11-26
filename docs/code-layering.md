# 🧩 Nine AutoSeries® — Clean Architecture Code Layering & Contract Standards

> **Standar Rekayasa Kode:** Robert C. Martin Clean Architecture & Inward Dependency Rule  
> **Pola Aliran Data:** Presentation (BLoC) $\rightarrow$ Domain (UseCase) $\rightarrow$ Data (Repository & DataSource) $\rightarrow$ Core (Network/DB)  
> **Target Platform:** Flutter 3.50+ & Dart 3.14+  

---

## 📑 Daftar Isi
1. [Prinsip Dasar & Aturan Dependensi Masuk (Inward Dependency Rule)](#1-prinsip-dasar--aturan-dependensi-masuk-inward-dependency-rule)
2. [Matriks Kontrak Kode Per Alur Bisnis (Layering Flow Contract)](#2-matriks-kontrak-kode-per-alur-bisnis-layering-flow-contract)
3. [Implementasi Lengkap: Alur Booking Servis Nine Garage](#3-implementasi-lengkap-alur-booking-servis-nine-garage)
   - 3.1 [Presentation Layer (BLoC, Event & State)](#31-presentation-layer-bloc-event--state)
   - 3.2 [Domain Layer (Entities, UseCases & Repo Contract)](#32-domain-layer-entities-usecases--repo-contract)
   - 3.3 [Data Layer (Models, Datasource & Repository Implementation)](#33-data-layer-models-datasource--repository-implementation)
   - 3.4 [Core & Infrastructure Layer (ApiClient & Interceptors)](#34-core--infrastructure-layer-apiclient--interceptors)
4. [Tabel Normalisasi Error & Pemetaan Exception ke Failure](#4-tabel-normalisasi-error--pemetaan-exception-ke-failure)
5. [Pedoman Kepatuhan Kode: Do & Don't Clean Layering](#5-pedoman-kepatuhan-kode-do--dont-clean-layering)

---

## 1. Prinsip Dasar & Aturan Dependensi Masuk (Inward Dependency Rule)

Clean Architecture memisahkan kode menjadi lingkaran konsentris di mana lingkaran terdalam tidak mengetahui apapun mengenai lingkaran terluar:

```
┌────────────────────────────────────────────────────────────────────────┐
│ 1. PRESENTATION LAYER (Screens, Widgets, BLoC State Management)        │
│    │                                                                   │
│    ▼ memanggil                                                         │
│ 2. DOMAIN LAYER (Pure Entities, UseCases, Repository Interfaces)       │
│    ▲                                                                   │
│    │ diimplementasikan oleh                                            │
│ 3. DATA LAYER (Repository Impl, DTO Models fromJson/toJson, DataSource)│
│    │                                                                   │
│    ▼ memanfaatkan                                                      │
│ 4. CORE & INFRASTRUCTURE (Dio ApiClient, Interceptors, Theme, Utils)   │
└────────────────────────────────────────────────────────────────────────┘
```

* **Lapisan Domain (Paling Murni):** Ditulis dalam **Dart murni** tanpa import framework Flutter (`package:flutter/*`), tanpa import Dio, dan tanpa ketergantungan database. Jika UI berubah dari Flutter ke platform lain, lapisan domain tidak perlu diubah sedikitpun.
* **Lapisan Data:** Mengonversi data luar (JSON REST API atau SQLite) ke entitas domain melalui model DTO.
* **Lapisan Presentation:** Menerima aksi pengguna, mengirimkan event ke BLoC, memanggil UseCase, dan me-render state ke widget.

---

## 2. Matriks Kontrak Kode Per Alur Bisnis (Layering Flow Contract)

| Alur Proses Bisnis | Presentation (BLoC) | Domain (UseCase) | Data (Model & DataSource) | Core Network Endpoint |
| :--- | :--- | :--- | :--- | :--- |
| **Muat Cabang Bengkel** | `InitBookingEvent` $\rightarrow$ `state.copyWith(workshops)` | `GetWorkshopsUseCase(NoParams)` $\rightarrow$ `List<WorkshopEntity>` | `WorkshopModel.fromJson` $\rightarrow$ `getWorkshops()` | `GET /api/v1/workshops` |
| **Katalog Jasa Servis** | `InitBookingEvent` $\rightarrow$ `state.copyWith(availableServices)` | `GetServicesUseCase(params)` $\rightarrow$ `List<ServiceEntity>` | `ServiceModel.fromJson` $\rightarrow$ `getServices()` | `GET /api/v1/services` |
| **Kapasitas Slot Jam** | `SelectDateEvent` $\rightarrow$ `state.copyWith(timeSlots)` | `GetAvailabilityUseCase(params)` $\rightarrow$ `List<BookingAvailabilityEntity>` | `BookingAvailabilityModel` $\rightarrow$ `getAvailability()` | `GET /api/v1/bookings/availability` |
| **Kirim Reservasi SPK** | `SubmitBookingEvent` $\rightarrow$ `submitting` $\rightarrow$ `success` | `SubmitBookingUseCase(booking)` $\rightarrow$ `BookingEntity` | `BookingModel.toJson` $\rightarrow$ `submitBooking(model)` | `POST /api/v1/bookings` |

---

## 3. Implementasi Lengkap: Alur Booking Servis Nine Garage

### 3.1. Presentation Layer (BLoC, Event & State)
Menangani input pengguna dan mengubah state antarmuka:

```dart
// lib/features/garage/presentation/blocs/booking_bloc.dart
Future<void> _onSubmitBooking(SubmitBookingEvent event, Emitter<BookingState> emit) async {
  emit(state.copyWith(submissionStatus: BookingSubmissionStatus.submitting, clearError: true));

  final bookingPayload = BookingEntity(
    customerName: state.customerName,
    customerPhone: state.customerPhone,
    customerEmail: state.customerEmail.isNotEmpty ? state.customerEmail : null,
    vehicleCategory: state.vehicleCategory,
    vehicleBrand: state.vehicleBrand,
    vehicleModel: state.vehicleModel,
    licensePlate: state.licensePlate,
    transmissionType: state.transmissionType,
    workshopId: state.selectedWorkshop!.id,
    bookingDate: DateTimeUtils.formatForApi(state.selectedDate!),
    timeSlot: state.selectedTimeSlot!,
    serviceIds: state.selectedServices.map((s) => s.id).toList(),
    voucherCode: state.appliedVoucherCode,
    subtotalPrice: state.subtotalPrice,
    discountAmount: state.voucherDiscount,
    totalPrice: state.totalPrice,
  );

  final result = await submitBookingUseCase(bookingPayload);

  result.fold(
    (failure) => emit(state.copyWith(
      submissionStatus: BookingSubmissionStatus.failure,
      errorMessage: failure.message,
    )),
    (submitted) => emit(state.copyWith(
      submissionStatus: BookingSubmissionStatus.success,
      submittedBooking: submitted,
    )),
  );
}
```

### 3.2. Domain Layer (Entities, UseCases & Repo Contract)
Mendefinisikan entitas bisnis murni dan kontrak fungsional tunggal:

```dart
// lib/features/garage/domain/usecases/submit_booking_usecase.dart
class SubmitBookingUseCase implements UseCase<BookingEntity, BookingEntity> {
  final IGarageRepository repository;
  SubmitBookingUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(BookingEntity booking) {
    return repository.submitBooking(booking);
  }
}

// lib/features/garage/domain/repositories/i_garage_repository.dart
abstract class IGarageRepository {
  Future<Either<Failure, List<WorkshopEntity>>> getWorkshops();
  Future<Either<Failure, List<ServiceEntity>>> getServices({String? vehicleType});
  Future<Either<Failure, List<BookingAvailabilityEntity>>> getAvailability({
    required int workshopId,
    required String bookingDate,
  });
  Future<Either<Failure, BookingEntity>> submitBooking(BookingEntity booking);
}
```

### 3.3. Data Layer (Models, Datasource & Repository Implementation)
Menjembatani domain dengan infrastruktur luar dan menangani serialisasi DTO:

```dart
// lib/features/garage/data/repositories/garage_repository_impl.dart
class GarageRepositoryImpl implements IGarageRepository {
  final IGarageRemoteDataSource remoteDataSource;
  GarageRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, BookingEntity>> submitBooking(BookingEntity booking) async {
    try {
      final model = BookingModel.fromEntity(booking);
      final result = await remoteDataSource.submitBooking(model);
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Either.left(NetworkFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
```

### 3.4. Core & Infrastructure Layer (ApiClient & Interceptors)
Menjalankan request HTTP dengan penegakan idempotensi dan sanitasi error:

```dart
// lib/core/network/api_client.dart
Future<Response<T>> post<T>(String path, {dynamic data, Options? options}) {
  return dio.post<T>(path, data: data, options: options);
}
```

---

## 4. Tabel Normalisasi Error & Pemetaan Exception ke Failure

Setiap exception teknis wajib dinormalisasi menjadi pesan ramah pengguna non-teknis:

| HTTP Status / Penyebab | Exception di Data Layer | Failure di Domain Layer | Pesan Non-Teknis ke Pengguna (UI) |
| :---: | :--- | :--- | :--- |
| `0` / Socket / Timeout | `NetworkException` | `NetworkFailure` | "Koneksi jaringan terputus. Mohon periksa paket data internet Anda." |
| `400` Bad Request | `ServerException` | `ValidationFailure` | "Data formulir belum lengkap atau format nomor polisi salah." |
| `401` Unauthorized | `ServerException` | `AuthFailure` | "Sesi akun Anda telah berakhir. Silakan verifikasi ulang via WhatsApp." |
| `422` Unprocessable | `ServerException` | `ServerFailure` | "Slot jam kedatangan yang Anda pilih baru saja dipesan oleh pelanggan lain." |
| `500` Internal Error | `ServerException` | `ServerFailure` | "Sistem reservasi bengkel sedang sibuk. Silakan coba sesaat lagi." |

---

## 5. Pedoman Kepatuhan Kode: Do & Don't Clean Layering

### ✅ Do (Wajib Diterapkan):
1. **Dependency Injection:** Selalu gunakan `GetIt` (`sl<T>()`) untuk meregistrasi dan memanggil class dependencies.
2. **DTO Pruning:** Pastikan DTO Model hanya menyertakan properti yang benar-benar dipakai oleh antarmuka mobile.
3. **Immutability:** Seluruh Entity dan State BLoC wajib `const` dan meng-extend `Equatable`.
4. **Idempotency Key:** Selalu sertakan header `Idempotency-Key` pada semua mutasi transaksi finansial dan booking servis.

### ❌ Don't (Dilarang Keras):
1. **Dilarang memanggil `ApiClient` atau `Dio` langsung dari Widget atau BLoC.**
2. **Dilarang me-rethrow Exception teknis mentah (seperti `DioException` atau `SocketException`) ke antarmuka pengguna.**
3. **Dilarang mengimpor file di dalam folder `data/` ke dalam folder `domain/`.**
4. **Dilarang melakukan mutasi state UI di luar BLoC event handler.**
