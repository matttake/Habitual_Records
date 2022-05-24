import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'home/home.dart';
import 'login/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ja');
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
      debugShowCheckedModeBanner: false, // DEBUG表記を消す
      title: 'Flutter App',
      home: (() {
        // ログイン状態の有無で遷移先を決定
        if (FirebaseAuth.instance.currentUser != null) {
          return Home();
        } else {
          return const Login();
        }
      })(),
    );
  }
}
