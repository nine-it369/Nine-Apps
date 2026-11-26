import 'package:flutter_test/flutter_test.dart';
import 'package:nine_apps/app.dart';
import 'package:nine_apps/core/di/injection.dart';
import 'package:nine_apps/core/network/api_client.dart';

void main() {
  setUp(() async {
    if (!sl.isRegistered<ApiClient>()) {
      await configureDependencies();
    }
  });

  testWidgets('NineApp launches and displays Garage Landing Screen', (WidgetTester tester) async {
    await tester.pumpWidget(const NineApp());
    await tester.pumpAndSettle();

    expect(find.text('Nine Garage®'), findsOneWidget);
    expect(find.text('Instalasi Presisi & Servis Kendaraan'), findsOneWidget);
    expect(find.text('Buat Reservasi Servis (Booking)'), findsOneWidget);
  });
}
