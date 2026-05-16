import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'providers/data_provider.dart';
import 'providers/schedule_provider.dart';
import 'screens/main_display_screen.dart';

void main() async {
  // Capture errors in the main function
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    debugPrint('[Main] Starting app initialization...');

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('[Main] Flutter Error: ${details.exception}');
    };

    try {
      await initializeDateFormatting('id_ID', null);
      debugPrint('[Main] Date formatting initialized.');
    } catch (e) {
      debugPrint('[Main] Date formatting failed: $e');
    }

    try {
      WakelockPlus.enable();
      debugPrint('[Main] Wakelock enabled.');
    } catch (e) {
      debugPrint('[Main] Wakelock failed: $e');
    }

    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyAesCwgAyCTaWLLOMC2kp5og3xwm1VpjDI',
          appId: '1:76836580513:android:83ecad80bd3abcc62c14e0',
          messagingSenderId: '76836580513',
          projectId: 'masjid-app-f0906',
          storageBucket: 'masjid-app-f0906.firebasestorage.app',
        ),
      );
      debugPrint('[Main] Firebase initialized.');
    } catch (e) {
      debugPrint('[Main] Firebase failed: $e');
    }

    runApp(const MyApp());
  }, (error, stack) {
    debugPrint('[Main] Uncaught Error: $error');
    debugPrint('[Main] Stacktrace: $stack');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()..loadData()),
        ChangeNotifierProxyProvider<DataProvider, ScheduleProvider>(
          create: (context) => ScheduleProvider(
            Provider.of<DataProvider>(context, listen: false),
          ),
          update: (context, dataProvider, previous) {
            previous?.updateFromDataProvider(dataProvider);
            return previous ?? ScheduleProvider(dataProvider);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Jadwal Shalat Android TV',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0D3B2E),
          primarySwatch: Colors.teal,
          fontFamily: 'Roboto',
        ),
        home: const MainDisplayScreen(),
      ),
    );
  }
}
