import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habitual_records/main.dart';
import 'package:habitual_records/pages/setup/setup_model.dart';
import '../target/target.dart';

class Setup extends StatelessWidget {
  const Setup({this.newJudge, Key? key}) : super(key: key);
  final bool? newJudge;

  @override
  Widget build(BuildContext context) {
    if (newJudge == true) {
      return const Scaffold(body: NewSetup());
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('設定'),
        ),
        body: const SetupBody(),
      );
    }
  }
}

class NewSetup extends StatelessWidget {
  const NewSetup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 40),
          child: const Text('目標を設定して今すぐ始めよう！'),
        ),
        Center(
          child: TextButton(
            child: const Text(
              '目標を設定する',
              style: TextStyle(fontSize: 17),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(builder: (context) => const Target()),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SetupBody extends StatelessWidget {
  const SetupBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final insMyPage = SetupModel();

    return FutureBuilder(
      // FutureBuilderの仕組みがいまいち。なんか中でメソッド処理が複数回走ってる？
      future: insMyPage.targetSettingCheck(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // 通信が失敗した場合
        if (snapshot.hasError) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(5, 15, 5, 25),
                child: Text(snapshot.error.toString()),
              ),
              Center(
                child: TextButton(
                  child: const Text('ログアウト'),
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
                ),
              ),
            ],
          );
        }

        // snapshot.dataがnull以外の場合
        if (snapshot.hasData) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 10),
                    ),
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
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: const Center(child: Text('【目標】')),
              ),
              Text(
                snapshot.data!,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          );
        }
        return const Text('500 Error');
      },
    );
  }
}
