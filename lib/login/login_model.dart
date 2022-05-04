import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailProvider =
    StateNotifierProvider<LoginNotifier, String>((ref) => LoginNotifier());
final passwordProvider =
    StateNotifierProvider<LoginNotifier, String>((ref) => LoginNotifier());
final insProvider = Provider((ref) => LoginNotifier());

class LoginNotifier extends StateNotifier<String> {
  LoginNotifier() : super("");

  // textfiledの文字列をセット
  String setStr(String filedText) {
    return state = filedText;
  }
}

// User新規登録
Future register(String email, String password) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  await auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
}

// ログイン
Future login(String email, String password) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  await auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

// ダイアログ
Future dialog(context, message) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        // 戻るボタンを無効にする
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("入力画面に戻る"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    },
  );
}
