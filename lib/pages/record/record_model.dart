import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../const/const.dart';

class RecordModel {
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  // Firestoreから値取得して、月ごとの合計時間を配列に格納
  Future<List<Map<String, int>>> getTimeSet() async {
    final totalTimeArray = <Map<String, int>>[];
    final target = await getSelectedTarget(_userId);
    final year = DateFormat.y().format(DateTime.now());

    // Reference(参照先の指定)
    final CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection(target);

    for (final month in ConstDate.months) {
      final docsSnapshot = await collectionRef.doc(year + month).get();
      final docsMap = docsSnapshot.data();

      if (docsMap is Map<String, dynamic>) {
        var total = 0;
        for (final value in docsMap.values) {
          total = total +
              int.parse(((value as Map<String, dynamic>)['minute']).toString());
        }
        totalTimeArray.add({month: total});
      } else {
        totalTimeArray.add({month: 0});
      }
    }
    // FutureBuilderに値返却
    return totalTimeArray;
  }
}

class RecordTotalModel {
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  // Firestoreから値取得して、累計時間を配列に格納
  Future<List<Map<String, int>>> getTimeSet() async {
    final totalTimeArray = <Map<String, int>>[];
    final target = await getSelectedTarget(_userId);
    var total = 0;

    final year = DateFormat.y().format(DateTime.now());

    // Reference(参照先の指定)
    final CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection(target);

    for (final month in ConstDate.months) {
      final docsSnapshot = await collectionRef.doc(year + month).get();
      final docsMap = docsSnapshot.data();

      if (docsMap is Map<String, dynamic>) {
        for (final value in docsMap.values) {
          total = total +
              int.parse((value as Map<String, dynamic>)['minute'].toString());
        }
        totalTimeArray.add({month: total});
      } else {
        totalTimeArray.add({month: 0});
      }
    }
    // FutureBuilderに値返却
    return totalTimeArray;
  }
}

// Firestoreから選択中の目標を取得
Future<String> getSelectedTarget(String? userId) async {
  final DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  final selectedTarget = (doc.data()! as Map)['target'].toString();
  return selectedTarget;
}

class RecordBarChart extends ConsumerWidget {
  const RecordBarChart({
    required this.totalTimeArray,
    required this.targetType,
    Key? key,
  }) : super(key: key);
  final List<Map<String, int>>? totalTimeArray;
  final String targetType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxY = maxYCalculation(totalTimeArray, targetType); // bar上限値を動的取得

    return BarChart(
      BarChartData(
        barTouchData: barTouchData, // ①タッチ時のアニメーションの設定
        titlesData: titlesData, // ②barタイトルの設定
        borderData: borderData, // ③barタイトルとbarとの境界線の設定
        barGroups: barGroups, // ④各barの表示設定。色や幅とか。
        gridData: FlGridData(show: false), // ⑤背景のグリッド表示設定
        alignment: BarChartAlignment.spaceAround, // ⑥barの表示起点の設定
        maxY: maxY, // barの表示上限値
      ),
    );
  }

  // ①タッチ時のアニメーションの設定
  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent, // bar上部の数字の背景色
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  // ②で使用⇛barタイトルの設定
  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    // double型の小数点がうざいからint型変換経由で文字列へ。
    final tmp = value.toInt();
    final text = tmp.toString();
    return Center(child: Text(text, style: style));
  }

  // ②barタイトルの設定
  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        // ↓デフォルでボトム以外のタイトルが表示されるので、非表示に。
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  // ③ボーダータイトルとbarとの境界線の設定
  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  // ④各barの表示設定。色や幅、値とか。
  List<BarChartGroupData> get barGroups => [
        for (int i = 0; i < 12; i++)
          BarChartGroupData(
            x: int.parse(ConstDate.months[i]),
            barRods: [
              BarChartRodData(
                // 月の合計時間をそれぞれ表示
                toY: (totalTimeArray![i][ConstDate.months[i]]!).toDouble(),
                color: Colors.lightBlue,
                //gradient: _barsGradient,
              )
            ],
            showingTooltipIndicators: [0],
          ),
      ];
}

double maxYCalculation(
  List<Map<String, int>>? totalTimeArray,
  String targetType,
) {
  final list = <int>[];
  final minY = ConstGraph.graphMinY[targetType]!;
  var maxY = 0.0;

  // 最大値(一番作業した月の値)を取得
  for (var i = 0; i < 12; i++) {
    list.add(totalTimeArray![i][ConstDate.months[i]]!);
  }
  final maxValue = list.reduce(max);
  final valueY = maxValue * 1.1;

  // 最低値:minYと最大値:valueYを比較して、値の大きい方をmaxYに代入
  if (minY >= valueY) {
    maxY = minY;
  } else {
    maxY = valueY;
  }
  return maxY;
}
