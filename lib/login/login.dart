import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/home_page.dart';
import 'login_model.dart';

class Login extends StatelessWidget {
  final ok_message = "ユーザー登録が完了しました！";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Consumer(builder: (context, ref, _) {
            final email_provider = ref.watch(emailProvider.notifier);
            final password_provider = ref.watch(passwordProvider.notifier);
            final login_ins = ref.read(ins_Provider);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // メールアドレス入力
                TextFormField(
                  decoration: InputDecoration(labelText: 'メールアドレス'),
                  onChanged: (String value) {
                    email_provider.setStr(value);
                  },
                ),

                // パスワード入力
                TextFormField(
                  decoration: InputDecoration(labelText: 'パスワード'),
                  obscureText: true,
                  onChanged: (String value) {
                    password_provider.setStr(value);
                  },
                ),

                Container(
                  width: double.infinity,
                  // ユーザー登録ボタン
                  child: ElevatedButton(
                    child: Text('ユーザー登録'),
                    onPressed: () async {
                      try {
                        // メール/パスワードでユーザー登録
                        await login_ins.register(
                            email_provider.state, password_provider.state);
                        // ユーザー登録に成功した場合
                        await login_ins.Dialog(context, ok_message, HomePage());
                      } catch (e) {
                        // ユーザー登録に失敗した場合
                        String msg = "登録に失敗しました：${e.toString()}";
                        await login_ins.Dialog(context, msg, _);
                      }
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  // ログインボタン
                  child: ElevatedButton(
                    child: Text('ログイン'),
                    onPressed: () async {
                      try {
                        // メール/パスワードでログイン
                        await login_ins.login(
                            email_provider.state, password_provider.state);
                        // ログインに成功した場合
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return HomePage();
                          }),
                        );
                      } catch (e) {
                        // ログインに失敗した場合
                        String msg = "ログインに失敗しました：${e.toString()}";
                        await login_ins.Dialog(context, msg, _);
                      }
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
