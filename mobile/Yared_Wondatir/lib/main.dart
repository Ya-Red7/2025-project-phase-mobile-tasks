import 'package:flutter/material.dart';
import 'home_page.dart';
import 'details_page.dart';
import 'add_update_search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product UI',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomePage());
          case '/details':
            final args = settings.arguments as Map<String, dynamic>?;
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  DetailsPage(product: args?['product']),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          case '/add_edit':
            final args = settings.arguments as Map<String, dynamic>?;
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  AddUpdateSearchPage(product: args?['product']),
              transitionsBuilder: (_, animation, __, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          default:
            return null;
        }
      },
    );
  }
}
