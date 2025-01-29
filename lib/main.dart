import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/vpn_provider.dart';
import 'views/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VPNProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
          .copyWith(secondary: Colors.tealAccent),
      scaffoldBackgroundColor: const Color(0xFFE0E7FF),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: Colors.white,
      ),
      textTheme: const TextTheme(
        headline6: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        bodyText2: TextStyle(fontSize: 16, color: Colors.black54),
        button: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Братский VPN',
      theme: _buildTheme(),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
