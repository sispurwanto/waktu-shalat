import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/data_provider.dart';
import 'providers/schedule_provider.dart';
import 'screens/main_display_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()..loadMockData()),
        ChangeNotifierProxyProvider<DataProvider, ScheduleProvider>(
          create: (context) => ScheduleProvider(
            Provider.of<DataProvider>(context, listen: false),
          ),
          update: (context, dataProvider, previous) =>
              previous ?? ScheduleProvider(dataProvider),
        ),
      ],
      child: MaterialApp(
        title: 'Jadwal Shalat Android TV',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(
            0xFF0D3B2E,
          ), // Dark greenish background
          primarySwatch: Colors.teal,
          fontFamily: 'Roboto', // Default font, can be updated later
        ),
        home: const MainDisplayScreen(),
      ),
    );
  }
}
