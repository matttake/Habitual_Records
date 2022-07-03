import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/dialog.dart';
import '../../common/dropdown.dart';
import '../../common/is_release.dart';
import '../../const/const.dart';
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
          final hintText = ConstDropdown.targetType[int.parse(indexNum)];
          final targetItems = ConstDropdown.targetItems[int.parse(indexNum)];

          return Scaffold(
            appBar: AppBar(
              title: Text(isRelease() ? '習慣化記録' : '習慣化記録(開発環境)'),
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
                  onPressed: () async {
                    final targetType = await getTargetType();
                    await Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => Record(
                          text: '月毎の記録',
                          targetType: targetType,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Wrap(
                      children: <Widget>[
                        DropDown(
                          hintText: month,
                          targetItems: ConstDate.months,
                          homeModelIns: changeProvider,
                          buttonWidth: 45,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 30,
                          child: const Text('月'),
                        ),
                        DropDown(
                          hintText: day,
                          targetItems: ConstDate.days,
                          homeModelIns: changeProvider,
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
                            child: DropDown(
                              hintText: hintText,
                              targetItems: targetItems,
                              homeModelIns: changeProvider,
                            ),
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
                            var color = Colors.lightBlueAccent;

                            // ドロップダウンの値が選択されているなら、Firestoreに本日の値が既に登録済みかを確認。
                            if (changeProvider.dropdownSelectedValue != null) {
                              checkResult =
                                  await changeProvider.checkRegistered();
                            } else {
                              resultMessage = ConstDropdown.mistake;
                              overwriteJudgment = false;
                            }

                            // 既に登録済みならダイアログ表示
                            if (checkResult == true) {
                              overwriteJudgment = await boolDialog(
                                context,
                                TaskRegister.bodyMsg,
                                TaskRegister.trueMsg,
                                TaskRegister.falseMsg,
                              );
                            }

                            // REVIEW: なぜかprintが2重呼び出しされてる。要確認。
                            // print('bool: ' + _overwriteJudgment.toString());
                            // print('Message: ' + _resultMessage);

                            // 既存登録アイテム無し or 上書きOKなら、登録処理実行
                            if (overwriteJudgment == true) {
                              resultMessage =
                                  await changeProvider.addRegister();
                            }

                            // 登録成功時
                            if (resultMessage == ConstDropdown.success) {
                              // Pass
                            }
                            // 作業時間未選択時
                            else if (resultMessage == ConstDropdown.mistake) {
                              color = Colors.redAccent;
                            }
                            // 上書きNGにした場合
                            else if (resultMessage == '') {
                              color = Colors.greenAccent;
                              resultMessage = '登録はキャンセルされました';
                            }
                            // FireStore側のエラーの場合
                            else {
                              color = Colors.amberAccent;
                            }

                            // 登録結果をSnackBarで通知
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: color,
                                content: Text(resultMessage),
                              ),
                            );
                            // 作業時間未登録以外はState更新
                            if (resultMessage != ConstDropdown.mistake) {
                              changeProvider.iniStr();
                            }
                          },
                          child: const Text('登録'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
