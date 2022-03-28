import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

final List<String> items = [
  '10',
  '20',
  '30',
  '40',
  '50',
];
final String time = DateFormat.yMMMEd('ja').format(DateTime.now());
final ins_changeProvider =
    ChangeNotifierProvider<HomeModel>((ref) => HomeModel());

class HomeModel extends ChangeNotifier {
  String? selectedValue;
  // DateTime now = DateTime.now();
  // String time = DateFormat.yMMMEd('ja').format(DateTime.now());

  // textfiledの文字列をセット
  void setStr(String? filed_text) {
    this.selectedValue = filed_text;
    notifyListeners();
  }
}

class DropDown extends StatelessWidget {
  final HomeModel ins;
  DropDown(this.ins);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
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
