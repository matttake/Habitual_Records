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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Record()));
            },
          ),
        ],
      ),
      body: Center(
        child: HomeBody(),
      ),
    );
  }
}

// Body部分
class HomeBody extends ConsumerWidget {
  HomeBody({Key? key}) : super(key: key);

  // 変数宣言
  String _resultMessage = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _homeChangeProvider = ref.watch(homeChangeProvider);
    final _homeFutureProvider = ref.watch(homeFutureProvider);

    return Column(
      children: [
        // element0:Date
        Center(
          child: Text(time),
        ),
        // element1:DropdownButton
        Center(
          child: _homeFutureProvider.when(
            // FutureProviderのインスタンス範囲が、このdata配下でしか生きない？
            // data配下を離れると、インスタンス内の変数の値は破棄されるの？
            loading: () => const CircularProgressIndicator(),
            error: (err, stack) => Text('Error: $err'),
            data: (data) {
              print(data);
              if (data == 'count') {
                return DropDown(_homeChangeProvider, '回数を選択', countItems);
              } else if (data == 'min') {
                return DropDown(_homeChangeProvider, '時間を選択', minItems);
              } else if (data == 'flg') {
                return DropDown(_homeChangeProvider, '実施有無を選択', flgItems);
              } else {
                return const Text('Error');
              }
            },
          ),
        ),

        // element2:SubmitButton
        TextButton(
          child: const Text("登録"),
          onPressed: () async {
            await _homeChangeProvider.getSelectedTarget();
            _resultMessage = await _homeChangeProvider.addRegister();

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
            }
            // 二重登録時
            /// ダイアログ出して、（上書きしますか？)を表示したい
            // if (_resultMessage == register_ng) {
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     backgroundColor: Colors.red,
            //     content: Text(_resultMessage),
            //   ));
            // }
            // firebase側のエラー時
            else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.amberAccent,
                content: Text(_resultMessage),
              ));
            }
          },
        ),
      ],
    );
  }
}
