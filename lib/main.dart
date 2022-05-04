import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home/home.dart';
import 'login/login.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('ja');
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp(); // new
    return MaterialApp(
      title: "Flutter App",
      home: (() {
        // まだAuthを実装していない
        if (FirebaseAuth.instance.currentUser != null) {
          return const Home();
        } else {
          return const Login();
        }
      })(),
    );
  }
}
