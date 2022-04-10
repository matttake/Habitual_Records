import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../record/record.dart';
import '../mypage/mypage.dart';
import '../setup/setup.dart';
import 'home_model.dart';

// Header部分
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("習慣化記録"),
        actions: [
          IconButton(
            // Screen transition to loginPage
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Record()));
            },
            icon: const Icon(Icons.bar_chart),
          ),
        ],
      ),
      drawerEdgeDragWidth: 0,
      drawer: Container(
        width: 200,
        child: SafeArea(
          child: Drawer(
            child: ListView(
              children: [
                SizedBox(
                    height: 60,
                    child: DrawerHeader(
                      child: Text('各種ページ'),
                    )),
                ListTile(
                  title: Text("記録"),
                  trailing: Icon(Icons.bar_chart),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Record()));
                  },
                ),
                ListTile(
                  title: Text("設定"),
                  trailing: Icon(Icons.settings),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Setup()));
                  },
                ),
                ListTile(
                  title: Text("マイページ"),
                  trailing: Icon(Icons.account_circle),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyPage()));
                  },
                ),
              ],
            ),
          ),
        ),
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
  String result_msg = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ins = ref.watch(ins_changeProvider);

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
          child: Text("登録"),
          onPressed: () async {
            result_msg = await ins.add_register();

            /// scackbar部分は別関数として切り出したい。ifの乱立は可読性悪い。
            // 登録成功時
            if (result_msg == register_ok) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.lightBlueAccent,
                content: Text(result_msg),
              ));
            }
            // 作業時間未選択時
            else if (result_msg == register_ng) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(result_msg),
              ));
            }
            // 二重登録時
            /// ダイアログ出して、（上書きしますか？)を表示したい
            // if (result_msg == register_ng) {
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     backgroundColor: Colors.red,
            //     content: Text(result_msg),
            //   ));
            // }
            // firebase側のエラー時
            else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.amberAccent,
                content: Text(result_msg),
              ));
            }
          },
        ),
      ],
    );
  }
}
