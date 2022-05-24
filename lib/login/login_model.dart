import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// エラーハンドリングメッセージ
const String emailAlreadyUse = '指定したメールアドレスは登録済みです';
const String emailInvalid = '指定したメールアドレスは無効な値です';
const String unknownText = '必要事項を記入してください';
const String wrongPassword = 'パスワードが一致しません';
const String userNotFount = '指定したメールアドレスに該当するユーザーが見つかりません';
const String weakPassword = 'パスワードは6桁以上で設定してください';

final emailProvider =
    StateNotifierProvider<LoginNotifier, String>((ref) => LoginNotifier());
final passwordProvider =
    StateNotifierProvider<LoginNotifier, String>((ref) => LoginNotifier());
final insProvider = Provider((ref) => LoginNotifier());

class LoginNotifier extends StateNotifier<String> {
  LoginNotifier() : super('');

  // textfiledの文字列をセット
  String setStr(String filedText) {
    return state = filedText;
  }

  // stateの初期化処理
  void stateCheck() {
    if (state != '') {
      state = '';
    }
  }

  // stateを返すだけ
  String returnState() {
    return state;
  }
}

// User新規登録
Future<void> register(String email, String password) async {
  final auth = FirebaseAuth.instance;
  await auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
}

// ログイン
Future<void> login(String email, String password) async {
  final auth = FirebaseAuth.instance;
  await auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

// ダイアログ
Future<void> dialog(
  BuildContext context,
  String message, {
  String btnText = 'OK',
}) {
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
              child: Text(btnText),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    },
  );
}

// FirebaseAuthのエラーハンドリングダイアログ
Future<void> errorHandlingDialog(
  BuildContext context,
  FirebaseAuthException e,
) {
  debugPrint(e.toString());
  var errorMessage = '';
  if (e.code == 'email-already-in-use') {
    errorMessage = emailAlreadyUse;
  } else if (e.code == 'invalid-email') {
    errorMessage = emailInvalid;
  } else if (e.code == 'unknown') {
    errorMessage = unknownText;
  } else if (e.code == 'weak-password') {
    errorMessage = weakPassword;
  } else if (e.code == 'user-not-found') {
    errorMessage = userNotFount;
  } else if (e.code == 'wrong-password') {
    errorMessage = wrongPassword;
  } else {
    errorMessage = '登録に失敗しました：${e.toString()}';
  }

  return dialog(context, errorMessage, btnText: '入力画面に戻る');
}
