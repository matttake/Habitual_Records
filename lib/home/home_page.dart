import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import '../login/login.dart';
import '../record/record.dart';
import '../mypage/mypage.dart';
import '../setup/setup.dart';

class HomePage extends StatelessWidget {
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
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            icon: const Icon(Icons.login),
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
      body: HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  State<HomeBody> createState() => _HomePageState();
}

class _HomePageState extends State<HomeBody> {
  DateTime now = DateTime.now();
  String time = DateFormat.yMMMEd('ja').format(DateTime.now());

  String? selectedValue;
  List<String> items = [
    '10',
    '20',
    '30',
    '40',
    '50',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // element0:Date
          Center(
            child: Text(time),
          ),

          // element1:DropdownButton
          Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                hint: Text(
                  'minute',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                isExpanded: true,
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                  });
                },
                buttonHeight: 40,
                buttonWidth: 140,
                itemHeight: 40,
                dropdownMaxHeight: 200,
                dropdownWidth: 100,
                //dropdownPadding: const EdgeInsets.symmetric(vertical: 33),
                dropdownPadding: null,
                dropdownElevation: 8,
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
                //offset: const Offset(-20, 0),
              ),
            ),
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
      ),
    );
  }
}
