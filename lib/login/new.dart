import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/home.dart';
import 'login_model.dart';

class New extends StatelessWidget {
  const New({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新規登録"),
      ),
      body: const NewBody(),
    );
  }
}

class NewBody extends StatelessWidget {
  const NewBody({Key? key}) : super(key: key);
  final String successMessage = "ユーザー登録が完了しました！";
  final String mistakeMessage = "登録に失敗しました";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Consumer(builder: (context, ref, _) {
            final _emailProvider = ref.watch(emailProvider.notifier);
            final _passwordProvider = ref.watch(passwordProvider.notifier);
            final _loginInstance = ref.read(insProvider);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // メールアドレス入力
                TextFormField(
                  decoration: const InputDecoration(labelText: 'メールアドレス'),
                  onChanged: (String value) {
                    _emailProvider.setStr(value);
                  },
                ),

                // パスワード入力
                TextFormField(
                  decoration: const InputDecoration(labelText: 'パスワード'),
                  obscureText: true,
                  onChanged: (String value) {
                    _passwordProvider.setStr(value);
                  },
                ),

                SizedBox(
                  width: double.infinity,
                  // ユーザー登録ボタン
                  child: ElevatedButton(
                    child: const Text('ユーザー登録'),
                    onPressed: () async {
                      try {
                        // メール/パスワードでユーザー登録
                        await _loginInstance.register(
                            _emailProvider.state, _passwordProvider.state);
                        // ユーザー登録に成功した場合
                        await _loginInstance.dialog(
                            context, successMessage, Home());
                      } catch (e) {
                        // ユーザー登録に失敗した場合
                        String msg = "$mistakeMessage：${e.toString()}";
                        await _loginInstance.dialog(context, msg, _);
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
