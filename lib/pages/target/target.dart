import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitual_records/pages/target/target_model.dart';
import '../../common/dialog.dart';
import '../../common/dropdown.dart';
import '../../const/const.dart';
import '../home/home.dart';

class Target extends StatelessWidget {
  const Target({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('目標の設定'),
      ),
      body: const TargetBody(),
    );
  }
}

class TargetBody extends StatelessWidget {
  const TargetBody({Key? key}) : super(key: key);
  static const String successMessage = '目標を登録しました。';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Consumer(
            builder: (context, ref, _) {
              final targetStateProvider = ref.watch(targetProvider.notifier);
              final changeProvider = ref.watch(targetChangeProvider);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 目標入力
                  TextFormField(
                    decoration: const InputDecoration(labelText: '目標'),
                    onChanged: targetStateProvider.setStr,
                  ),
                  Center(
                    child: DropDown(
                      hintText: '目標タイプを選択',
                      targetItems: ConstDropdown.targetType,
                      targetModelIns: changeProvider,
                      buttonWidth: double.infinity,
                      menuWidth: 200,
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    // 登録ボタン
                    child: ElevatedButton(
                      child: const Text('登録する'),
                      onPressed: () async {
                        /// check
                        final resultMsg = await targetStateProvider
                            .register(changeProvider.selectedValue);
                        // 登録に成功した場合
                        if (resultMsg == successMessage) {
                          targetStateProvider.resetStr();
                          await dialog(context, resultMsg);
                          await Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (context) => Home(rebuild: true),
                            ),
                          );
                        } else {
                          // 登録に失敗した場合
                          await dialog(context, resultMsg, btnText: '入力画面に戻る');
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
