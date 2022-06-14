import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/dialog.dart';
import '../../common/is_release.dart';
import '../setup/setup.dart';
import 'login_model.dart';

class New extends StatelessWidget {
  const New({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録'),
      ),
      body: const NewBody(),
    );
  }
}

const String successMessage = 'ユーザー登録が完了しました！';
const String mistakeMessage = '登録に失敗しました';

class NewBody extends StatelessWidget {
  const NewBody({Key? key}) : super(key: key);

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
                    // ユーザー登録ボタン
                    child: ElevatedButton(
                      child: const Text('ユーザー登録'),
                      onPressed: () async {
                        try {
                          // メール/パスワードでユーザー登録
                          await register(
                            emailStateProvider.returnState(),
                            passwordStateProvider.returnState(),
                          );
                          // ユーザー登録に成功した場合
                          await dialog(context, successMessage);
                          await Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute<void>(
                              builder: (context) {
                                return const Setup(newJudge: true);
                              },
                            ),
                            (_) => false,
                          );
                          // ユーザー登録に失敗した場合
                        } on FirebaseAuthException catch (e) {
                          await errorHandlingDialog(
                            context,
                            e,
                          );
                        }
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
