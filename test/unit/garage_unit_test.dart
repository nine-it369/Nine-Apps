import 'package:flutter_test/flutter_test.dart';
import 'package:nine_apps/core/utils/currency_formatter.dart';
import 'package:nine_apps/core/utils/error_sanitizer.dart';
import 'package:nine_apps/core/utils/input_validators.dart';
import 'package:nine_apps/features/garage/data/models/booking_availability_model.dart';
import 'package:nine_apps/features/garage/data/models/booking_model.dart';
import 'package:nine_apps/features/garage/domain/entities/booking_entity.dart';

void main() {
  group('CurrencyFormatter Unit Tests', () {
    test('formats IDR without decimal digits', () {
      expect(CurrencyFormatter.format(600000), contains('600.000'));
      expect(CurrencyFormatter.format(0), contains('0'));
      expect(CurrencyFormatter.format(null), 'Rp 0');
    });
  });

  group('InputValidators Unit Tests', () {
    test('validates phone and normalizes 08 to 628', () {
      expect(InputValidators.phone('08123456789'), isNull);
      expect(InputValidators.phone('123'), isNotNull);
      expect(InputValidators.normalizePhoneForBackend('0812-3456-7890'), '6281234567890');
    });

    test('validates email regex properly', () {
      expect(InputValidators.email('user@nine.co.id'), isNull);
      expect(InputValidators.email('invalid-email'), isNotNull);
      expect(InputValidators.email(''), isNull); // optional
    });

    test('validates license plate length', () {
      expect(InputValidators.licensePlate('B 1234 NNE'), isNull);
      expect(InputValidators.licensePlate('AB'), isNotNull);
    });
  });

  group('ErrorSanitizer Unit Tests (Non-Technical Error Policy)', () {
    test('masks technical SQL / Dio / StackTrace errors with friendly Indonesian', () {
      expect(
        ErrorSanitizer.sanitize('pq: duplicate key value violates unique constraint'),
        ErrorSanitizer.defaultFallback,
      );
      expect(
        ErrorSanitizer.sanitize('DioException [connection error]: ECONNREFUSED'),
        contains('koneksi internet'),
      );
      expect(
        ErrorSanitizer.sanitize('slot 13:00 on 2026-11-27 already booked'),
        contains('baru saja dipesan'),
      );
      expect(
        ErrorSanitizer.sanitize('you already have a booking with the same service at this time'),
        contains('jadwal reservasi aktif'),
      );
    });
  });

  group('Garage DTO Models Unit Tests', () {
    test('BookingAvailabilityModel parses live backend JSON shape', () {
      final avail = BookingAvailabilityModel.fromJson({
        'hour': '13:00',
        'status': 'available',
        'remaining_capacity': 2,
      });
      expect(avail.hour, '13:00');
      expect(avail.isAvailable, isTrue);
      expect(avail.remainingCapacity, 2);

      final full = BookingAvailabilityModel.fromJson({
        'hour': '14:00',
        'status': 'full',
        'remaining_capacity': 0,
      });
      expect(full.isAvailable, isFalse);
    });

    test('BookingModel.toCreateJson produces pruned DTO matching Go backend', () {
      const entity = BookingEntity(
        customerName: 'Budi Santoso',
        customerPhone: '628123456789',
        customerEmail: 'budi@example.com',
        custAddress: 'Jl. Merdeka No. 10',
        cityId: 156,
        vehicleType: 'car',
        vehicleModel: 'Toyota Innova Zenix',
        vehiclePlat: 'b 1234 nne',
        vehicleColor: 'Hitam',
        isEv: false,
        workshopId: 1,
        bookingDate: '2026-11-27',
        endDate: '2026-11-27',
        hour: '13:00',
        referralSource: 'Google Search',
        serviceIds: [1, 3],
        subTotal: 850000,
        totalAmount: 850000,
      );

      final json = BookingModel.fromEntity(entity).toCreateJson();

      expect(json['workshop_id'], 1);
      expect(json['vehicle_plat'], 'B 1234 NNE');
      expect(json['cust_address'], 'Jl. Merdeka No. 10');
      expect(json['city_id'], 156);
      expect(json['hour'], '13:00');
      expect(json['service_items'], [
        {'service_id': 1},
        {'service_id': 3},
      ]);
      // Ensure pruned DTO doesn't send extraneous/legacy fields
      expect(json.containsKey('time_slot'), isFalse);
      expect(json.containsKey('license_plate'), isFalse);
    });
  });
}
