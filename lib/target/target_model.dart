import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

// 定数宣言
const List<String> items = [
  '作業時間を登録',
  '実施回数を登録',
  '実施の有無を登録',
];

// Provider宣言
final targetChangeProvider =
    ChangeNotifierProvider<TargetModel>((ref) => TargetModel());
final targetProvider =
    StateNotifierProvider<TargetNotifier, String>((ref) => TargetNotifier());

class TargetNotifier extends StateNotifier<String> {
  TargetNotifier() : super("");

  // textfiledの文字列をセット
  String setStr(String filedText) {
    return state = filedText;
  }

  // textfiledの文字列を初期化
  void resetStr() {
    state = '';
  }

  // 目標登録
  Future register(String? type) async {
    String _resultMessage = '';
    const String _successMessage = "目標を登録しました。";
    const String _failureMessage = "登録に失敗しました。";
    const String _nullMessage = "未入力 or 未選択";
    final String _userId = FirebaseAuth.instance.currentUser!.uid;

    // Firestoreに登録
    final DocumentReference doc =
        FirebaseFirestore.instance.collection('users').doc(_userId);

    if (state != '' && type != null) {
      try {
        await doc.set({
          'type': type,
          'target': state,
        });
        _resultMessage = _successMessage;
      } catch (e) {
        print(e.toString());
        _resultMessage = _failureMessage + e.toString();
      }
    }
    // textFieldが空の場合
    else {
      _resultMessage = _nullMessage;
    }
    return _resultMessage;
  }
}

class TargetModel extends ChangeNotifier {
  String? selectedValue;

  // textfiledの文字列をセット
  void setStr(String? filedText) {
    selectedValue = filedText;
    notifyListeners();
  }
}

/// 他モデル全て共通化したい。重複している。
class DropDown extends StatelessWidget {
  final TargetModel ins;
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
        dropdownWidth: 200,
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
