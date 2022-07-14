import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/is_release.dart';
import '../home/home.dart';
import 'login_model.dart';
import 'new.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Consumer(
              builder: (context, ref, _) {
                final emailStateProvider = ref.watch(emailProvider.notifier);
                final passwordStateProvider =
                    ref.watch(passwordProvider.notifier);

                // stateのスタックを破棄(絶対もっといい方法がある。。)
                emailStateProvider.stateCheck();
                passwordStateProvider.stateCheck();

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // メールアドレス入力
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: isRelease() ? 'メールアドレス' : 'メールアドレス(開発環境)',
                      ),
                      onChanged: emailStateProvider.setStr,
                    ),

                    // パスワード入力
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'パスワード'),
                      obscureText: true,
                      onChanged: passwordStateProvider.setStr,
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
                              emailStateProvider.returnState(),
                              passwordStateProvider.returnState(),
                            );
                            // ログインに成功した場合
                            await Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (context) {
                                  return Home(rebuild: true);
                                },
                              ),
                            );
                            // ログイン失敗した場合
                          } on FirebaseAuthException catch (e) {
                            await errorHandlingDialog(
                              context,
                              e,
                            );
                          }
                        },
                      ),
                    ),
                    Center(
                      child: TextButton(
                        child: const Text('新規登録'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) => const New(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
