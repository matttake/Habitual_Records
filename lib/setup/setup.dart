import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habitual_records/main/main.dart';
import 'package:habitual_records/setup/setup_model.dart';
import '../target/target.dart';

class Setup extends StatelessWidget {
  const Setup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      body: const MyPageBody(),
    );
  }
}

class MyPageBody extends StatelessWidget {
  const MyPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _insMyPage = SetupModel();

    return FutureBuilder(
        // FutureBuilderの仕組みがいまいち。なんか中でメソッド処理が複数回走ってる？
        future: _insMyPage.targetSettingCheck(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 通信が失敗した場合
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          // snapshot.dataがnullの場合
          if (snapshot.data == null) {
            return Column(children: [
              const Text("目標を設定して今すぐ始めよう！"),
              Center(
                child: TextButton(
                  child: const Text('目標を設定する'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Target()));
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(builder: (context) {
                    //     return const New();
                    //   }),
                    // );
                  },
                ),
              ),
            ]);
          }

          // snapshot.dataがnull以外の場合
          if (snapshot.data != null) {
            return Column(children: [
              const Text("目標"),
              Text(snapshot.data),
              Center(
                child: TextButton(
                  child: const Text('ログアウト'),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return MyApp();
                      }),
                    );
                  },
                ),
              ),
            ]);
          }
          return const Text("500 Error");
        });
  }
}
