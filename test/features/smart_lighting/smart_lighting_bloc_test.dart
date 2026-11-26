import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nine_apps/features/smart_lighting/data/datasources/led_ble_datasource.dart';
import 'package:nine_apps/features/smart_lighting/data/repositories/smart_lighting_repository_impl.dart';
import 'package:nine_apps/features/smart_lighting/domain/entities/led_device_entity.dart';
import 'package:nine_apps/features/smart_lighting/domain/entities/led_rgb_color.dart';
import 'package:nine_apps/features/smart_lighting/domain/entities/smart_lamp_state_entity.dart';
import 'package:nine_apps/features/smart_lighting/domain/usecases/connect_led_device_usecase.dart';
import 'package:nine_apps/features/smart_lighting/domain/usecases/send_led_color_usecase.dart';
import 'package:nine_apps/features/smart_lighting/domain/usecases/smart_lamp_commands_usecases.dart';
import 'package:nine_apps/features/smart_lighting/presentation/blocs/smart_lighting_bloc.dart';
import 'package:nine_apps/features/smart_lighting/presentation/blocs/smart_lighting_event.dart';
import 'package:nine_apps/features/smart_lighting/presentation/screens/sensor_override_screen.dart';
import 'package:nine_apps/features/smart_lighting/presentation/screens/smart_lamp_studio_screen.dart';
import 'package:nine_apps/shared/widgets/lighting/nine_color_wheel.dart';
import 'package:nine_apps/shared/widgets/lighting/nine_vertical_dimmer.dart';

SmartLightingBloc _createTestBloc() {
  final ds = SimulatedLedBleDataSourceImpl();
  final repo = SmartLightingRepositoryImpl(ds);
  return SmartLightingBloc(
    scanDevicesUseCase: ScanLedDevicesUseCase(repo),
    connectDeviceUseCase: ConnectLedDeviceUseCase(repo),
    sendPowerUseCase: SendLampPowerUseCase(repo),
    sendColorUseCase: SendLedColorUseCase(repo),
    sendModeUseCase: SendLampModeUseCase(repo),
    sendRunningTextUseCase: SendRunningTextUseCase(repo),
    sendSettingUseCase: SendLampSettingUseCase(repo),
    repository: repo,
  );
}

void main() {
  group('SmartLightingBloc & Studio Integration Tests', () {
    test('InitSmartLightingEvent loads simulated BLE devices and connects', () async {
      final bloc = _createTestBloc();
      bloc.add(const InitSmartLightingEvent());
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(bloc.state.availableDevices.length, 3);
      expect(bloc.state.lampState.activeDevice.id, 'NINE-LED-12093');

      bloc.add(const ConnectLedDeviceEvent('LEDCAR-02-8812'));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(bloc.state.lampState.activeDevice.id, 'LEDCAR-02-8812');
      await bloc.close();
    });

    test('Power, Color, Brightness, Mode, Signal & Hardware Calibration events update state', () async {
      final bloc = _createTestBloc();

      bloc.add(const ToggleLampPowerEvent());
      bloc.add(const ChangeLampColorEvent(LedRgbColor(0xED, 0x1C, 0x24)));
      bloc.add(const ChangeLampBrightnessEvent(128));
      bloc.add(const SelectLampModeEvent(SmartLampMode.dynamicSign));
      bloc.add(const SelectSignStyleEvent(SignLightStyle.wave));
      bloc.add(const UpdateSignSpeedEvent(90));
      bloc.add(const SelectBrakeStyleEvent(BrakeLightStyle.tripleBlink));
      bloc.add(const SelectWelcomeStyleEvent(WelcomeLightStyle.cyberRainbow));
      bloc.add(const SelectSideStyleEvent(SideLightStyle.brightWhiteDrl));
      bloc.add(const UpdateTransitionSpeedEvent(180));
      bloc.add(const UpdateTextSpeedEvent(100));
      bloc.add(const UpdateRgbPinOrderEvent(RgbPinOrder.bgr));
      bloc.add(const UpdateIcChipConfigEvent(LedIcChipType.ws2811, 60));
      bloc.add(const ToggleTurnSafetyOverrideEvent(false));

      await Future<void>.delayed(const Duration(milliseconds: 120));

      expect(bloc.state.lampState.isPowerOn, isFalse);
      expect(bloc.state.lampState.color.toHex(), '#ED1C24');
      expect(bloc.state.lampState.brightness, 128);
      expect(bloc.state.lampState.activeMode, SmartLampMode.dynamicSign);
      expect(bloc.state.lampState.signStyle, SignLightStyle.wave);
      expect(bloc.state.lampState.signSpeedMs, 90);
      expect(bloc.state.lampState.brakeStyle, BrakeLightStyle.tripleBlink);
      expect(bloc.state.lampState.welcomeStyle, WelcomeLightStyle.cyberRainbow);
      expect(bloc.state.lampState.sideStyle, SideLightStyle.brightWhiteDrl);
      expect(bloc.state.lampState.transitionSpeedMs, 180);
      expect(bloc.state.lampState.textSpeedMs, 100);
      expect(bloc.state.lampState.activeDevice.pinOrder, RgbPinOrder.bgr);
      expect(bloc.state.lampState.activeDevice.icChipType, LedIcChipType.ws2811);
      expect(bloc.state.lampState.activeDevice.pixelCount, 60);
      expect(bloc.state.lampState.turnOverrideEnabled, isFalse);
      await bloc.close();
    });

    test('UpdateRunningTextEvent validates empty text and formats uppercase', () async {
      final bloc = _createTestBloc();
      bloc.add(const UpdateRunningTextEvent('   '));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.errorMessage, isNotNull);

      bloc.add(const UpdateRunningTextEvent('jaga jarak aman'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.lampState.runningText, 'JAGA JARAK AMAN');
      await bloc.close();
    });

    testWidgets('SmartLampStudioScreen renders dark cockpit, modals, and 4 slides', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => _createTestBloc(),
            child: const SmartLampStudioScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('NINE-LED-12093'), findsOneWidget);
      expect(find.text('Mode: Running Text'), findsOneWidget);
      expect(find.text('TEKS BERJALAN'), findsOneWidget);
      expect(find.text('#8DC63F'), findsNWidgets(2));
      expect(find.byType(NineColorWheel), findsOneWidget);
      expect(find.byType(NineVerticalDimmer), findsOneWidget);

      // Open Mode Selector Bottom Sheet
      await tester.tap(find.text('Mode: Running Text'));
      await tester.pumpAndSettle();
      expect(find.text('Pilih Mode Smart Lamp'), findsOneWidget);
      await tester.tap(find.text('Sein Dinamis'));
      await tester.pumpAndSettle();
      expect(find.text('Mode: Sein Dinamis'), findsOneWidget);

      // Open Hardware Calibration Sheet via BLE pill
      await tester.tap(find.text('NINE-LED-12093'));
      await tester.pumpAndSettle();
      expect(find.text('Kalibrasi Hardware & BLE'), findsOneWidget);
      expect(find.text('WS2811'), findsOneWidget);
      await tester.tap(find.text('BGR'));
      await tester.pump();
      await tester.tap(find.text('WS2811'));
      await tester.pump();
      await tester.tap(find.text('60 LED'));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Switch back to Running Text and open Running Text Editor Sheet via HUD pill
      await tester.tap(find.text('Mode: Sein Dinamis'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Running Text'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('NINE AUTOSERIES').first);
      await tester.pumpAndSettle();
      expect(find.text('Atur Running Text'), findsOneWidget);
      await tester.tap(find.text('KEEP DISTANCE').last);
      await tester.pump();
      await tester.tap(find.text('Cepat (80 ms)'));
      await tester.pump();
      await tester.tap(find.text('Kirim Running Text ke Smart LED'));
      await tester.pumpAndSettle();

      // Switch to Warna Solid & open Color Picker Sheet via HUD pill
      await tester.tap(find.text('Mode: Running Text'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Warna Solid'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Warna Solid').first);
      await tester.pumpAndSettle();
      expect(find.text('Color Wheel Picker'), findsOneWidget);
      await tester.tap(find.text('Devil'));
      await tester.pump();
      await tester.ensureVisible(find.text('Terapkan Warna ke Smart LED'));
      await tester.tap(find.text('Terapkan Warna ke Smart LED'));
      await tester.pumpAndSettle();
      expect(find.text('#ED1C24'), findsNWidgets(2));

      // Navigate through slides 1, 2, 3 via PageView fling & test controls
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 800);
      await tester.pumpAndSettle();
      expect(find.text('LAMPU SEIN & REM'), findsOneWidget);
      await tester.tap(find.text('2. Balok'));
      await tester.pump();

      await tester.fling(find.byType(PageView), const Offset(-400, 0), 800);
      await tester.pumpAndSettle();
      expect(find.text('WELCOME & LAMPU SENJA'), findsOneWidget);

      await tester.fling(find.byType(PageView), const Offset(-400, 0), 800);
      await tester.pumpAndSettle();
      expect(find.text('KECERAHAN & TRANSISI'), findsOneWidget);
      await tester.tap(find.text('Malam 35%'));
      await tester.pump();

      // Test Power Toggle & Color Wheel center tap
      await tester.tap(find.byIcon(Icons.power_settings_new_rounded));
      await tester.pump();
      await tester.tapAt(tester.getCenter(find.byType(NineColorWheel)));
      await tester.pump();
      await tester.tapAt(tester.getCenter(find.byType(NineVerticalDimmer)));
      await tester.pump();
    });

    testWidgets('SensorOverrideScreen displays road safety SOP and toggles turn override', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => _createTestBloc(),
            child: const SensorOverrideScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('SOP Keamanan Standar Jalan Raya'), findsOneWidget);
      expect(find.text('Override Rem (Wajib Merah)'), findsOneWidget);
      expect(find.text('Override Lampu Sein (Kuning Running)'), findsOneWidget);

      final turnSwitch = find.byType(Switch).last;
      await tester.tap(turnSwitch);
      await tester.pump();
    });
  });
}
