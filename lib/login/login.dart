import 'package:firebase_auth/firebase_auth.dart';
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
                    decoration: const InputDecoration(labelText: 'メールアドレス'),
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
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            debugPrint(e.toString());
                            await dialog(
                              context,
                              userNotFount,
                              btnText: '入力画面に戻る',
                            );
                          } else if (e.code == 'invalid-email') {
                            debugPrint(e.toString());
                            await dialog(
                              context,
                              emailInvalid,
                              btnText: '入力画面に戻る',
                            );
                          } else if (e.code == 'unknown') {
                            debugPrint(e.toString());
                            await dialog(
                              context,
                              unknownText,
                              btnText: '入力画面に戻る',
                            );
                          } else if (e.code == 'wrong-password') {
                            debugPrint(e.toString());
                            await dialog(
                              context,
                              unknownText,
                              btnText: '入力画面に戻る',
                            );
                          } else {
                            debugPrint(e.toString());
                            await dialog(
                              context,
                              '登録に失敗しました：${e.toString()}',
                              btnText: '入力画面に戻る',
                            );
                          }
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
    );
  }
}
