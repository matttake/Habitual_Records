import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../const/const.dart';

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
      indexNum = (ConstDropdown.targetType).indexOf(targetType!).toString();
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
      snackbarMessage = ConstDropdown.success;
    } on Exception catch (e) {
      debugPrint(e.toString());
      snackbarMessage = e.toString();
    }
    return snackbarMessage;
  }
}

Future<bool?> registerDialog(BuildContext context) {
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
