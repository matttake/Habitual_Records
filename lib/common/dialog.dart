import 'package:flutter/material.dart';

// ダイアログ
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
