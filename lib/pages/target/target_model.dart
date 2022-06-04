import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../const/const.dart';

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
