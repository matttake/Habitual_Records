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
    final ins = ref.watch(homeChangeProvider);

    return Column(
      children: [
        // element0:Date
        Center(
          child: Text(time),
        ),
        if (ins.selectedValue != null)
          Center(
            child: Text(ins.selectedValue!),
          ),

        // element1:DropdownButton
        Center(
          child: DropDown(ins),
        ),

        // element2:SubmitButton
        TextButton(
          child: const Text("登録"),
          onPressed: () async {
            _resultMessage = await ins.add_register();

            /// scackbar部分は別関数として切り出したい。ifの乱立は可読性悪い。
            // 登録成功時
            if (_resultMessage == successMessage) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.lightBlueAccent,
                content: Text(_resultMessage),
              ));
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
