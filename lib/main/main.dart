import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../login/login_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('ja');
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: LoginPage(),
    ),
  );
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "Flutter App",
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text("Habitual Records"),
//           ),
//           body: MainPage()),
//     );
//   }
// }
