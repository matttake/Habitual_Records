import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 定数宣言
final List<String> items = [
  '10',
  '20',
  '30',
  '40',
  '50',
];
final String time = DateFormat.yMMMEd('ja').format(DateTime.now());
final String register_ok = "登録しました。";
final String register_ng = "作業時間が選択されていません。";

// Provider宣言
final ins_changeProvider =
    ChangeNotifierProvider<HomeModel>((ref) => HomeModel());

class HomeModel extends ChangeNotifier {
  String? selectedValue;

  // textfiledの文字列をセット
  void setStr(String? filed_text) {
    selectedValue = filed_text;
    notifyListeners();
  }

  Future<String> add_register() async {
    String snackbar_msg = '';

    // 作業時間が選択されていれば、Firebaseへの登録処理を実施
    if (selectedValue != null) {
      // 日付情報の取得
      final String year = DateFormat.y().format(DateTime.now());
      final String month = DateFormat.M().format(DateTime.now());
      final String day = DateFormat.d().format(DateTime.now());
      // ユーザーのUserID取得
      final String? user_id = FirebaseAuth.instance.currentUser?.uid;

      // Firestoreに登録
      final doc = FirebaseFirestore.instance
          .collection('users')
          .doc(user_id)
          .collection(year)
          .doc(month);

      try {
        await doc.set({
          'day': day,
          'minute': selectedValue,
        });
        snackbar_msg = register_ok;
      } catch (e) {
        print(e.toString());
        snackbar_msg = e.toString();
      }
    }

    // 作業時間が未選択なら処理せずエラー文だけ返す
    else {
      snackbar_msg = register_ng;
    }
    return snackbar_msg;
  }
}

class DropDown extends StatelessWidget {
  final HomeModel ins;
  const DropDown(this.ins, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        hint: Text(
          '作業時間を選択',
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