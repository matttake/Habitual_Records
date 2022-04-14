import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

const List<String> monthArray = [
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11',
  '12'
];

// // Provider
// final recordProvider =
//     StateNotifierProvider<RecordNotifier, String>((ref) => RecordNotifier());
//
// class RecordNotifier extends StateNotifier<String> {
//   RecordNotifier() : super("");
//
//   // Firestoreから値取得して、月ごとの合計時間を配列に格納
//   Future getTimeSet() async {
//     List<Map<String, int>> _totalTimeArray = [];
//     final String? userId = FirebaseAuth.instance.currentUser?.uid;
//     final String year = DateFormat.y().format(DateTime.now());
//
//     /// Reference(参照先の指定)
//     final DocumentReference docRef =
//         FirebaseFirestore.instance.collection('users').doc(userId);
//
//     /// Snapshot:Reference(参照先)の中身の実態。
//     /// Snapshot(実態)から値を取り出す。
//     for (var month in monthArray) {
//       QuerySnapshot docesSnapshot = await docRef.collection(year + month).get();
//       final List<QueryDocumentSnapshot> docsDayArray = docesSnapshot.docs;
//
//       int total = 0;
//       for (var day in docsDayArray) {
//         int dayMinute = int.parse(day.get('minute'));
//         total = total + dayMinute;
//       }
//       _totalTimeArray.add({month: total});
//     }
//     // FutureBuilderに値返却
//     return _totalTimeArray;
//   }
// }

class RecordNotifier {
  // Firestoreから値取得して、月ごとの合計時間を配列に格納
  Future getTimeSet() async {
    List<Map<String, int>> _totalTimeArray = [];
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    final String year = DateFormat.y().format(DateTime.now());

    /// Reference(参照先の指定)
    final DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    /// Snapshot:Reference(参照先)の中身の実態。
    /// Snapshot(実態)から値を取り出す。
    for (var month in monthArray) {
      QuerySnapshot docesSnapshot = await docRef.collection(year + month).get();
      final List<QueryDocumentSnapshot> docsDayArray = docesSnapshot.docs;

      int total = 0;
      for (var day in docsDayArray) {
        int dayMinute = int.parse(day.get('minute'));
        total = total + dayMinute;
      }
      _totalTimeArray.add({month: total});
    }
    // FutureBuilderに値返却
    return _totalTimeArray;
  }
}

/// コンストラクタで'_'をつけると、同ファイルからしか参照できない？
/// コンストラクタのルールがいまいちわかっていない。。。
/// とりあえず別ファイルから参照したかったから、'_'無しにした。
class RecordBarChart extends ConsumerWidget {
  List<Map<String, int>> _totalTimeArray = [];
  RecordBarChart(this._totalTimeArray, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData, // ①タッチ時のアニメーションの設定
        titlesData: titlesData, // ②barタイトルの設定
        borderData: borderData, // ③barタイトルとbarとの境界線の設定
        barGroups: barGroups, // ④各barの表示設定。色や幅とか。
        gridData: FlGridData(show: false), // ⑤背景のグリッド表示設定
        alignment: BarChartAlignment.spaceAround, // ⑥barの表示起点の設定
        maxY: 300,
      ),
    );
  }

  // ①タッチ時のアニメーションの設定
  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent, // bar上部の数字の背景色
          tooltipPadding: const EdgeInsets.all(0),
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
    int tmp = value.toInt();
    String text = tmp.toString();
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
            x: int.parse(monthArray[i]),
            barRods: [
              BarChartRodData(
                // 月の合計時間をそれぞれ表示
                toY: (_totalTimeArray[i][monthArray[i]]!).toDouble(),
                color: Colors.lightBlue,
                //gradient: _barsGradient,
              )
            ],
            showingTooltipIndicators: [0],
          ),
      ];
}
