import 'package:flutter/material.dart';

import 'diagnostico/diagnostico_screen.dart';
import 'folios/folios_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto - Diagnóstico de Celulares',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF137F75),
          primary: const Color(0xFF137F75),
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: const Color(0xFF192D40),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7F9),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(height: 1.5),
          bodySmall: TextStyle(height: 1.5),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 52),
            textStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8FAFB),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDCE4EA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDCE4EA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF137F75), width: 1.5),
          ),
        ),
      ),
      home: const DiagnosticoScreen(),
      routes: {
        '/folios': (context) => const FoliosScreen(),
        '/diagnostico': (context) => const DiagnosticoScreen(),
      },
    );
  }
}
