import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../login/login.dart';
import '../record/record.dart';
import '../mypage/mypage.dart';
import '../setup/setup.dart';
import 'home_model.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("習慣化記録"),
        // actions: [
        //   IconButton(
        //     // Screen transition to loginPage
        //     onPressed: () {
        //       Navigator.push(
        //           context, MaterialPageRoute(builder: (context) => Login()));
        //     },
        //     icon: const Icon(Icons.login),
        //   ),
        // ],
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
                  trailing: Icon(Icons.trending_up),
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

class HomeBody extends ConsumerWidget {
  // DateTime now = DateTime.now();
  // String time = DateFormat.yMMMEd('ja').format(DateTime.now());
  // String? selectedValue;

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
          onPressed: () {
            // todo:登録処理
            /// Firebaseに登録
            /// Datetimeの日付と連動させたい
            /// すでにDBに登録されている場合は、「上書きしてもいいか？」
            /// のpop-Up出して警告出したい。
          },
        ),
      ],
    );
  }
}
