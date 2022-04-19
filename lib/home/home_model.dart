import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 定数宣言
const List<String> minItems = [
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
const List<String> countItems = [
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
const List<String> flgItems = [
  '1',
];
const Map<String, String> targetItems = {
  '作業時間を登録': 'min',
  '実施回数を登録': 'count',
  '実施の有無を登録': 'flg'
};

final String time = DateFormat.yMMMEd('ja').format(DateTime.now());
const String successMessage = "登録しました。";
const String mistakeMessage = "作業時間が選択されていません。";

// Provider宣言
final homeChangeProvider =
    ChangeNotifierProvider<HomeModel>((ref) => HomeModel());
final homeFutureProvider = FutureProvider<String>((ref) async {
  return await HomeModel().getSelectedTarget();
});

class HomeModel extends ChangeNotifier {
  String? selectedValue;
  String? targetType;
  String? selectedTarget;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  // textfiledの文字列をセット
  void setStr(String? filedText) {
    selectedValue = filedText;
    notifyListeners();
  }

  // textfiledの初期化
  void iniStr() {
    selectedValue = null;
    notifyListeners();
  }

  Future getSelectedTarget() async {
    // Firestoreから選択中の目標を取得
    final DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(_userId).get();
    selectedTarget = (doc.data() as Map)['selected target'];
    targetType = targetItems[(doc.data() as Map)['type']];
    return targetType;
  }

  Future<String> addRegister() async {
    String _snackbarMessage = '';
    // 作業時間が選択されていれば、Firebaseへの登録処理を実施
    if (selectedValue != null) {
      // 日付情報の取得
      final String yearMonth = DateFormat('yyyyMM').format(DateTime.now());
      final String day = DateFormat.d().format(DateTime.now());
      // UserID取得

      // Firestoreに登録
      final doc = FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          // .collection(yearMonth)
          .collection(selectedTarget!)
          .doc(yearMonth);

      try {
        await doc.set({
          day: {'minute': selectedValue}
        });
        _snackbarMessage = successMessage;
      } catch (e) {
        print(e.toString());
        _snackbarMessage = e.toString();
      }
    }

    // 作業時間が未選択なら処理せずエラー文だけ返す
    else {
      _snackbarMessage = mistakeMessage;
    }
    return _snackbarMessage;
  }
}

class DropDown extends StatelessWidget {
  DropDown(this.ins, this.hintText, this.targetItems, {Key? key})
      : super(key: key);
  final HomeModel ins;
  final String hintText;
  final List<String> targetItems;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
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
        // ↓itemsのリストにない値だとエラーになる。空文字も。初期化したらだめ。初期値はnull？
        value: ins.selectedValue,
        // ライブラリの指定の型をよく見る。ライブラリに合わして変数宣言等しないとうまくいかない。
        onChanged: (String? input) {
          ins.setStr(input);
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
    );
  }
}
