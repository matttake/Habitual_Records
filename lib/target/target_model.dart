import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../const/const.dart';

// Provider宣言
final targetChangeProvider =
    ChangeNotifierProvider<TargetModel>((ref) => TargetModel());
final targetProvider =
    StateNotifierProvider<TargetNotifier, String>((ref) => TargetNotifier());

class TargetNotifier extends StateNotifier<String> {
  TargetNotifier() : super('');

  // textfiledの文字列をセット
  String setStr(String filedText) {
    return state = filedText;
  }

  // textfiledの文字列を初期化
  void resetStr() {
    state = '';
  }

  // 目標登録
  Future<String> register(String? type) async {
    var resultMessage = '';
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Firestoreに登録
    final DocumentReference doc =
        FirebaseFirestore.instance.collection('users').doc(userId);

    if (state != '' && type != null) {
      try {
        await doc.set({
          'type': type,
          'target': state,
        });
        resultMessage = RegisterMessage.success;
      } on Exception catch (e) {
        debugPrint(e.toString());
        resultMessage = RegisterMessage.failure + e.toString();
      }
    }
    // textFieldが空の場合
    else {
      resultMessage = RegisterMessage.notEntered;
    }
    return resultMessage;
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
  const DropDown(this.ins, {Key? key}) : super(key: key);
  final TargetModel ins;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        hint: Text(
          '目標タイプを選択',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        isExpanded: true,
        items: ConstDropdown.targetType
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
        value: ins.selectedValue,
        // ライブラリの指定の型をよく見る。ライブラリに合わして変数宣言等しないとうまくいかない。
        onChanged: ins.setStr,
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
