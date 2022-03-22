import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../home/home_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('ja');
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp(); // new
    return MaterialApp(
      title: "Flutter App",
      home: HomePage(),
    );
  }
}
