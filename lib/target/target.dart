import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitual_records/home/home.dart';
import 'package:habitual_records/target/target_model.dart';
import '../login/login_model.dart';

class Target extends StatelessWidget {
  const Target({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("目標の設定"),
      ),
      body: const TargetBody(),
    );
  }
}

class TargetBody extends StatelessWidget {
  const TargetBody({Key? key}) : super(key: key);
  static const String successMessage = "目標を登録しました。";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Consumer(builder: (context, ref, _) {
            final _targetProvider = ref.watch(targetProvider.notifier);
            final _targetChangeProvider = ref.watch(targetChangeProvider);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 目標入力
                TextFormField(
                  decoration: const InputDecoration(labelText: '目標'),
                  onChanged: (String value) {
                    _targetProvider.setStr(value);
                  },
                ),
                Center(
                  child: DropDown(_targetChangeProvider),
                ),

                SizedBox(
                  width: double.infinity,
                  // 登録ボタン
                  child: ElevatedButton(
                    child: const Text('登録する'),
                    onPressed: () async {
                      var resultMsg = await _targetProvider
                          .register(_targetChangeProvider.selectedValue);
                      // 登録に成功した場合
                      if (resultMsg == successMessage) {
                        _targetProvider.resetStr();
                        await dialog(context, resultMsg);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => Home(rebuild: true)));
                      } else {
                        // 登録に失敗した場合
                        await dialog(context, resultMsg, btnText: '入力画面に戻る');
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
