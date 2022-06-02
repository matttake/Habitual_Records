import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../const/const.dart';
import '../home/home_model.dart';
import '../target/target_model.dart';

// ↓このコメントをするとimmutableの警告消せる。本質的な解決ではない。
// ignore: must_be_immutable
class DropDown extends StatelessWidget {
  DropDown({
    // 必須のパラメータ
    required this.hintText,
    required this.targetItems,
    // 任意のパラメータ
    this.homeModelIns,
    this.targetModelIns,
    this.buttonWidth = 150,
    this.menuWidth = 100,
    Key? key,
  }) : super(key: key);
  final String hintText;
  final List<String> targetItems;
  HomeModel? homeModelIns;
  TargetModel? targetModelIns;
  double? buttonWidth;
  double? menuWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 7),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
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
          value: (() {
            if (targetItems == ConstDate.days) {
              return homeModelIns!.dropdownSelectedDay;
            } else if (targetItems == ConstDate.months) {
              return homeModelIns!.dropdownSelectedMonth;
            } else if (targetItems == ConstDropdown.targetType) {
              return targetModelIns!.selectedValue;
            } else {
              return homeModelIns!.dropdownSelectedValue;
            }
          })(),
          // ライブラリの指定の型をよく見る。ライブラリに合わして変数宣言等しないとうまくいかない。
          onChanged: (String? input) {
            if (targetItems == ConstDate.days) {
              homeModelIns!.setDay(input);
            } else if (targetItems == ConstDate.months) {
              homeModelIns!.setMonth(input);
            } else if (targetItems == ConstDropdown.targetType) {
              targetModelIns!.setStr(input);
            } else {
              homeModelIns!.setValue(input);
            }
          },

          buttonHeight: 40,
          buttonWidth: buttonWidth,
          itemHeight: 40,
          dropdownMaxHeight: 200,
          dropdownWidth: menuWidth,
          //dropdownPadding: const EdgeInsets.symmetric(vertical: 33),
          dropdownPadding: null,
          dropdownElevation: 8,
          scrollbarRadius: const Radius.circular(40),
          scrollbarThickness: 6,
          scrollbarAlwaysShow: true,
          //offset: const Offset(-20, 0),
        ),
      ),
    );
  }
}
