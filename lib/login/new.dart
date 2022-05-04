import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitual_records/setup/setup.dart';
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
                        await register(
                            _emailProvider.state, _passwordProvider.state);
                        // ユーザー登録に成功した場合
                        await dialog(context, successMessage);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                          return const Setup(newJudge: true);
                        }), (_) => false);
                      } catch (e) {
                        // ユーザー登録に失敗した場合
                        String msg = "$mistakeMessage：${e.toString()}";
                        await dialog(context, msg);
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
