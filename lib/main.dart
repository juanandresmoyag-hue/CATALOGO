import 'package:flutter/material.dart';

import 'screens/login_page.dart';
import 'screens/product_detail_page.dart';
import 'models/product.dart';

void main() {
  runApp(const CatalogoSenatiApp());
}

class CatalogoSenatiApp extends StatelessWidget {
  const CatalogoSenatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF176B58);

    return MaterialApp(
      title: 'Catálogo SENATI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          surface: const Color(0xFFF7F9F8),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F9F8),
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE2E9E6)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE2E9E6)),
          ),
        ),
      ),
      home: const LoginPage(),
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final product = settings.arguments;
          if (product is Product) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => ProductDetailPage(product: product),
            );
          }
        }
        return null;
      },
    );
  }
}
