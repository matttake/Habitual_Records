import 'package:flutter/material.dart';

// 通知用のダイアログ
Future<void> dialog(
  BuildContext context,
  String message, {
  String btnText = 'OK',
}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        // 戻るボタンを無効にする
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(btnText),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    },
  );
}

// 選択ダイアログ(選択肢によってtrue/falseを返す)
Future<bool?> boolDialog(
  BuildContext context,
  String bodyMsg,
  String trueMsg,
  String falseMsg,
) {
  return showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        // 戻るボタンを無効にする
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(bodyMsg),
          actions: <Widget>[
            TextButton(
              child: Text(trueMsg),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            TextButton(
              child: Text(falseMsg),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      );
    },
  );
}
