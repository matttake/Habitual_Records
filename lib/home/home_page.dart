import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('記録帳'),
          // actions: [
          //   IconButton(
          //     // Screen transition to loginPage
          //     onPressed: () async {
          //       if (FirebaseAuth.instance.currentUser != null) {
          //         await Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const MyPage(),
          //               fullscreenDialog: true),
          //         );
          //       } else {
          //         await Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const LoginPage(),
          //               fullscreenDialog: true),
          //         );
          //       }
          //     },
          //     icon: const Icon(Icons.person),
          //   ),
          // ],
        ),
        body: HomePage(),
      ),
    );
  }
}

// Future showConfirmDialog(
//   BuildContext context,
//   Book book,
//   BookListModel model,
// ) {
//   return showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) {
//       return AlertDialog(
//         title: const Text("削除の確認"),
//         content: Text("『${book.title}』を削除しますか？"),
//         actions: [
//           TextButton(
//             child: const Text("いいえ"),
//             onPressed: () => Navigator.pop(context),
//           ),
//           TextButton(
//             child: const Text("はい"),
//             onPressed: () async {
//               // modelで削除
//               await model.delete(book);
//               Navigator.pop(context);
//               final snackBar = SnackBar(
//                 backgroundColor: Colors.red,
//                 content: Text('${book.title}を削除しました'),
//               );
//               model.fetchBookList();
//               ScaffoldMessenger.of(context).showSnackBar(snackBar);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime now = DateTime.now();
  String time = DateFormat('yyyy/MM/dd(E)').format(DateTime.now());
  String time_ja = DateFormat('yyyy/MM/dd(E)', "ja").format(DateTime.now());
  String hoge = DateFormat.yMMMEd('ja').format(DateTime.now());

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
          // element1:DropdownButton
          Center(
            child: Text(time),
          ),
          Center(
            child: Text(time_ja),
          ),
          Center(
            child: Text(hoge),
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
