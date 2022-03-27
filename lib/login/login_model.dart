import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailProvider =
    StateNotifierProvider<LoginNotifier, String>((ref) => LoginNotifier());
final passwordProvider =
    StateNotifierProvider<LoginNotifier, String>((ref) => LoginNotifier());
final ins_Provider = Provider((ref) => LoginNotifier());

class LoginNotifier extends StateNotifier<String> {
  LoginNotifier() : super("");

  // textfiledの文字列をセット
  String setStr(String filed_text) {
    return this.state = filed_text;
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
  Future Dialog(context, message, page) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            // 登録成功時 => 画面遷移
            if (page != null)
              FlatButton(
                child: Text("ok"),
                onPressed: () => Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return page;
                })),
              ),

            // 登録失敗時 => 入力画面に戻る
            if (page == null)
              FlatButton(
                child: Text("ok"),
                onPressed: () => Navigator.pop(context),
              ),
          ],
        );
      },
    );
  }
}
