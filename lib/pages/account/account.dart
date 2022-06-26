import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habitual_records/pages/account/account_model.dart';

import '../../common/dialog.dart';
import '../../const/const.dart';
import '../../main.dart';

class Account extends StatelessWidget {
  const Account({this.newJudge, Key? key}) : super(key: key);
  final bool? newJudge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント設定'),
      ),
      body: const AccountBody(),
    );
  }
}

class AccountBody extends StatelessWidget {
  const AccountBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool? deleteJudge; // アカウント削除判定変数

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 10),
              ),
              // ログアウトしてログイン画面へ遷移
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                await Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(
                    builder: (context) {
                      return const MyApp();
                    },
                  ),
                  (_) => false,
                );
              },
              child: const Text('ログアウト'),
            ),
          ],
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 10),
          ),
          // アカウント削除の確認&警告
          onPressed: () async {
            deleteJudge = await boolDialog(
              context,
              AccountDelete.bodyMsg,
              AccountDelete.trueMsg,
              AccountDelete.falseMsg,
              Colors.yellow,
            );

            // アカウント削除処理
            if (deleteJudge == true) {
              try {
                // アカウント削除処理
                await deleteAccount();
                await FirebaseAuth.instance.signOut();

                // アカウントが削除されたことを通告
                await dialog(context, AccountDelete.resultMsg);

                // ログイン画面へ遷移
                await Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(
                    builder: (context) {
                      return const MyApp();
                    },
                  ),
                  (_) => false,
                );
              } on Exception catch (e) {
                debugPrint(e.toString());
                await dialog(context, AccountDelete.errorMsg + e.toString());
              }
            }
          },
          child: const Text('アカウントを削除'),
        ),
      ],
    );
  }
}
