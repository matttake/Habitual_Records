import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../record/record.dart';
import '../setup/setup.dart';
import 'home_model.dart';

// finalをつけると、22行のif文で変数:rebuildを変更できない。
// ↓このコメントをするとimmutableの警告消せる。本質的な解決ではない。
// ignore: must_be_immutable
class Home extends ConsumerWidget {
  Home({this.rebuild = false, Key? key}) : super(key: key);
  bool? rebuild;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changeProvider = ref.watch(homeChangeProvider);
    final futureProvider = ref.watch(homeFutureProvider);
    // FutureProviderのインスタンス範囲が、このdata配下でしか生きない？
    // data配下を離れると、インスタンス内の変数の値は破棄されるの？
    // インスタンス変数のスコープではなくなるからそらそうか、、

    if (rebuild == true) {
      ref.refresh(homeFutureProvider);
      rebuild = false;
    }

    return futureProvider.when(
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (err, stack) => Text('Error: $err'),
      data: (indexNum) {
        if (indexNum != '') {
          final hintText = constTargetType[int.parse(indexNum)];
          final targetItems = constTargetItems[int.parse(indexNum)];

          return Scaffold(
            appBar: AppBar(
              title: const Text('習慣化記録'),
              leading: IconButton(
                icon: const Icon(Icons.settings),
                iconSize: 20,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const Setup(),
                    ),
                  );
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.bar_chart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const Record(text: '月毎の記録'),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Wrap(
                    children: <Widget>[
                      DropDown(
                        changeProvider,
                        month,
                        constMonths,
                        buttonWidth: 45,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 30,
                        child: const Text('月'),
                      ),
                      DropDown(
                        changeProvider,
                        day,
                        constDays,
                        buttonWidth: 45,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 30,
                        child: const Text('日'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 50),
                        child: Center(
                          child:
                              DropDown(changeProvider, hintText, targetItems),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          minimumSize: const Size(155, 40),
                        ),
                        onPressed: () async {
                          bool? overwriteJudgment = true;
                          var resultMessage = '';
                          var checkResult = false;

                          // ドロップダウンの値が選択されているなら、Firestoreに本日の値が既に登録済みかを確認。
                          if (changeProvider.dropdownSelectedValue != null) {
                            checkResult =
                                await changeProvider.checkRegistered();
                          } else {
                            resultMessage = mistakeMessage;
                            overwriteJudgment = false;
                          }

                          // 既に登録済みならダイアログ表示
                          if (checkResult == true) {
                            overwriteJudgment = await dialog(context);
                          }

                          // REVIEW: なぜかprintが2重呼び出しされてる。要確認。
                          // print('bool: ' + _overwriteJudgment.toString());
                          // print('Message: ' + _resultMessage);

                          // 既存登録アイテム無し or 上書きOKなら、登録処理実行
                          if (overwriteJudgment == true) {
                            resultMessage = await changeProvider.addRegister();
                          }

                          /// scackbar部分は別関数として切り出したい。ifの乱立は可読性悪い。
                          // 登録成功時
                          if (resultMessage == successMessage) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.lightBlueAccent,
                                content: Text(resultMessage),
                              ),
                            );
                            changeProvider.iniStr();
                          }
                          // 作業時間未選択時
                          else if (resultMessage == mistakeMessage) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(resultMessage),
                              ),
                            );
                            // 上書きNGにした場合
                          } else if (resultMessage == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.lightGreen,
                                content: Text('登録はキャンセルされました'),
                              ),
                            );
                            changeProvider.iniStr();
                            // FireStore側のエラーの場合
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.amberAccent,
                                content: Text(resultMessage),
                              ),
                            );
                          }
                        },
                        child: const Text('登録'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('習慣化記録'),
            ),
            // FIXME:目標未設定でFutureProvider起動後、目標設定を完了してもFutureProviderが再発火せず
            //       (watchを値の監視がされない)、
            // FIXME: indexnumが空のままなので、ずっとループ的に設定するページが表示される。
            body: const NewSetup(),
          );
        }
      },
    );
  }
}
