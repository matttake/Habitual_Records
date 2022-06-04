import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/dialog.dart';
import '../../const/const.dart';

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

// FirebaseAuthのエラーハンドリングダイアログ
Future<void> errorHandlingDialog(
  BuildContext context,
  FirebaseAuthException e,
) {
  debugPrint(e.toString());
  var errorMessage = '';
  if (e.code == 'email-already-in-use') {
    errorMessage = ErrorMessage.emailAlreadyUse;
  } else if (e.code == 'invalid-email') {
    errorMessage = ErrorMessage.emailInvalid;
  } else if (e.code == 'unknown') {
    errorMessage = ErrorMessage.unknownText;
  } else if (e.code == 'weak-password') {
    errorMessage = ErrorMessage.weakPassword;
  } else if (e.code == 'user-not-found') {
    errorMessage = ErrorMessage.userNotFount;
  } else if (e.code == 'wrong-password') {
    errorMessage = ErrorMessage.wrongPassword;
  } else {
    errorMessage = '登録に失敗しました：${e.toString()}';
  }

  return dialog(context, errorMessage, btnText: '入力画面に戻る');
}
