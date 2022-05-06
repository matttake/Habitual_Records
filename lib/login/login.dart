import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitual_records/home/home.dart';
import 'login_model.dart';
import 'new.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Consumer(builder: (context, ref, _) {
            final _emailProvider = ref.watch(emailProvider.notifier);
            final _passwordProvider = ref.watch(passwordProvider.notifier);

            // stateのスタックを破棄(絶対もっといい方法がある。。)
            if (_emailProvider.state != '' || _passwordProvider.state != '') {
              _emailProvider.state = '';
              _passwordProvider.state = '';
            }

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
                  // ログインボタン
                  child: ElevatedButton(
                    child: const Text('ログイン'),
                    onPressed: () async {
                      try {
                        // メール/パスワードでログイン
                        await login(
                            _emailProvider.state, _passwordProvider.state);
                        // ログインに成功した場合
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return Home(rebuild: true);
                          }),
                        );
                      } catch (e) {
                        // ログインに失敗した場合
                        String msg = "ログインに失敗しました：${e.toString()}";
                        await dialog(context, msg);
                      }
                    },
                  ),
                ),
                Center(
                  child: TextButton(
                    child: const Text('新規登録'),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const New()));
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
