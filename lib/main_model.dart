import 'package:flutter/cupertino.dart';

class MainModel extends ChangeNotifier {
  String my_text = "sample";

  void change_cample_text() {
    my_text = "push to change text!";
    notifyListeners();
  }
}
