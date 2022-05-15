import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// 定数宣言
const List<String> constMonths = [
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11',
  '12',
];
const List<String> constDays = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30',
  '31',
];

const List<String> constTargetType = [
  '作業時間を登録',
  '実施回数を登録',
  '実施の有無を登録',
];

const List<String> constDropdownMinute = [
  '10',
  '20',
  '30',
  '40',
  '50',
  '60',
  '70',
  '80',
  '90',
  '100',
];
const List<String> countDropdownCount = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
];
const List<String> constDropdownFlags = [
  '1',
];

const List<List<String>> constTargetItems = [
  constDropdownMinute,
  countDropdownCount,
  constDropdownFlags
];

const String successMessage = '登録しました。';
const String mistakeMessage = '作業時間が選択されていません。';

final String year = DateFormat('yyyy').format(DateTime.now());
final String yearMonth = DateFormat('yyyyMM').format(DateTime.now());
final String month = DateFormat('MM').format(DateTime.now());
final String day = DateFormat.d().format(DateTime.now());

// Provider宣言
final homeChangeProvider =
    ChangeNotifierProvider<HomeModel>((ref) => HomeModel());
final homeFutureProvider = FutureProvider<String>((ref) async {
  return HomeModel().getTargetIndex();
});

class HomeModel extends ChangeNotifier {
  // UserID取得
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  String? dropdownSelectedMonth;
  String? dropdownSelectedDay;
  String? dropdownSelectedValue;
  String? targetName;
  String? targetType;

  // dropdownの文字列をセット
  void setValue(String? dropdownText) {
    dropdownSelectedValue = dropdownText;
    notifyListeners();
  }

  void setDay(String? dropdownText) {
    dropdownSelectedDay = dropdownText;
    notifyListeners();
  }

  void setMonth(String? dropdownText) {
    dropdownSelectedMonth = dropdownText;
    notifyListeners();
  }

  // dropdownの初期化
  void iniStr() {
    dropdownSelectedValue = null;
    dropdownSelectedDay = null;
    dropdownSelectedMonth = null;
    notifyListeners();
  }

  // Firestoreから選択中の目標と目標タイプを取得
  Future<void> getSelectedTarget() async {
    final DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(_userId).get();
    if (doc.data() != null) {
      targetName = (doc.data()! as Map)['target'].toString();
      targetType = (doc.data()! as Map)['type'].toString();
    }
    return;
  }

  // 定数の目標タイプリストのindexを取得
  Future<String> getTargetIndex() async {
    var indexNum = '';
    await getSelectedTarget();
    if (targetType != null) {
      indexNum = constTargetType.indexOf(targetType!).toString();
    }
    return indexNum;
  }

  // 登録する値が既に登録されているかどうかかのチェック
  Future<bool> checkRegistered() async {
    bool result;
    // 日時のドロップダウンメニュが選択されていないなら、今日の日付を入れる
    dropdownSelectedDay ??= day;
    dropdownSelectedMonth ??= month;

    await getSelectedTarget();
    try {
      final DocumentSnapshot docsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection(targetName!)
          .doc(year + dropdownSelectedMonth!)
          .get();
      final filedItems = docsSnapshot.data();

      // 値の存在判定をboolで返す
      if (filedItems is Map) {
        result = filedItems.containsKey(dropdownSelectedDay);
      } else {
        result = false;
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      result = false;
    }
    return result;
  }

  // Firestoreへ値登録
  Future<String> addRegister() async {
    var snackbarMessage = '';
    // 日時のドロップダウンメニュが選択されていないなら、今日の日付を入れる
    dropdownSelectedDay ??= day;
    dropdownSelectedMonth ??= month;

    try {
      // Firestoreに登録
      final doc = FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection(targetName!)
          .doc(year + dropdownSelectedMonth!);

      await doc.set(
        <String, Map<String, String>>{
          dropdownSelectedDay!: {'minute': dropdownSelectedValue!}
        },
        SetOptions(merge: true),
      );
      snackbarMessage = successMessage;
    } on Exception catch (e) {
      debugPrint(e.toString());
      snackbarMessage = e.toString();
    }
    return snackbarMessage;
  }
}

// ↓このコメントをするとimmutableの警告消せる。本質的な解決ではない。
// ignore: must_be_immutable
class DropDown extends StatelessWidget {
  DropDown(
    this.ins,
    this.hintText,
    this.targetItems, {
    this.buttonWidth,
    Key? key,
  }) : super(key: key);
  final HomeModel ins;
  final String hintText;
  final List<String> targetItems;
  double? buttonWidth;

  @override
  Widget build(BuildContext context) {
    buttonWidth ??= 150;

    return Container(
      padding: const EdgeInsets.only(left: 7),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          hint: Text(
            hintText,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          isExpanded: true,
          items: targetItems
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              )
              .toList(),
          // ↓itemsのリストにない値だとエラーになる。空文字も。初期化したらだめ。初期値はnull？
          value: (() {
            if (targetItems == constDays) {
              return ins.dropdownSelectedDay;
            } else if (targetItems == constMonths) {
              return ins.dropdownSelectedMonth;
            } else {
              return ins.dropdownSelectedValue;
            }
          })(),
          // ライブラリの指定の型をよく見る。ライブラリに合わして変数宣言等しないとうまくいかない。
          onChanged: (String? input) {
            if (targetItems == constDays) {
              ins.setDay(input);
            } else if (targetItems == constMonths) {
              ins.setMonth(input);
            } else {
              ins.setValue(input);
            }
          },

          buttonHeight: 40,
          buttonWidth: buttonWidth,
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
    );
  }
}

Future<bool?> dialog(BuildContext context) {
  return showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        // 戻るボタンを無効にする
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text('選択された日付には既に記録が登録されていますが、上書きしますか？'),
          actions: <Widget>[
            TextButton(
              child: const Text('上書き登録する'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            TextButton(
              child: const Text('登録しない'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      );
    },
  );
}
