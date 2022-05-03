import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../record/record.dart';
import '../setup/setup.dart';
import 'home_model.dart';

// Header部分
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("習慣化記録"),
        leading: IconButton(
            icon: const Icon(Icons.settings),
            iconSize: 20.0,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Setup()));
            }),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Record(text: '月毎の記録')));
            },
          ),
        ],
      ),
      body: const HomeBody(),
    );
  }
}

// Body部分
class HomeBody extends ConsumerWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _homeChangeProvider = ref.watch(homeChangeProvider);
    final _homeFutureProvider = ref.watch(homeFutureProvider);
    return _homeFutureProvider.when(
        // FutureProviderのインスタンス範囲が、このdata配下でしか生きない？
        // data配下を離れると、インスタンス内の変数の値は破棄されるの？
        // インスタンス変数のスコープではなくなるからそらそうか、、
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (_indexNum) {
          String _hintText = constTargetType[int.parse(_indexNum)];
          List<String> _targetItems = constTargetItems[int.parse(_indexNum)];

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    DropDown(_homeChangeProvider, month, constMonths),
                    DropDown(_homeChangeProvider, day, constDays),
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
                            _homeChangeProvider, _hintText, _targetItems),
                      ),
                    ),
                    ElevatedButton(
                      child: const Text("登録"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () async {
                        String _resultMessage = '';
                        bool _overwriteJudgment = true;
                        bool _checkResult = false;

                        // ドロップダウンの値が選択されているなら、Firestoreに本日の値が既に登録済みかを確認。
                        if (_homeChangeProvider.dropdownSelectedValue != null) {
                          _checkResult =
                              await _homeChangeProvider.checkRegistered();
                        } else {
                          _resultMessage = mistakeMessage;
                          _overwriteJudgment = false;
                        }

                        // 既に登録済みならダイアログ表示
                        if (_checkResult == true) {
                          _overwriteJudgment = await dialog(context);
                        }

                        // REVIEW: なぜかprintが2重呼び出しされてる。要確認。
                        // print('bool: ' + _overwriteJudgment.toString());
                        // print('Message: ' + _resultMessage);

                        // 既存登録アイテム無し or 上書きOKなら、登録処理実行
                        if (_overwriteJudgment == true) {
                          _resultMessage =
                              await _homeChangeProvider.addRegister();
                        }

                        /// scackbar部分は別関数として切り出したい。ifの乱立は可読性悪い。
                        // 登録成功時
                        if (_resultMessage == successMessage) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.lightBlueAccent,
                            content: Text(_resultMessage),
                          ));
                          _homeChangeProvider.iniStr();
                        }
                        // 作業時間未選択時
                        else if (_resultMessage == mistakeMessage) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(_resultMessage),
                          ));
                          // 上書きNGにした場合
                        } else if (_resultMessage == '') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: Colors.lightGreen,
                            content: Text('登録はキャンセルされました'),
                          ));
                          _homeChangeProvider.iniStr();
                          // FireStore側のエラーの場合
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.amberAccent,
                            content: Text(_resultMessage),
                          ));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
