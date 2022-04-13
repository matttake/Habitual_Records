import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:async';

// できればグローバル変数はあまり使いたくない。Widget内に動的に値変える方法検討
List<Map<String, int>> total_time_array = [];
final List<String> month_array = [
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

// Provider
final recordProvider =
    StateNotifierProvider<RecordNotifier, String>((ref) => RecordNotifier());

class RecordNotifier extends StateNotifier<String> {
  RecordNotifier() : super("");

  // Firestoreから値取得して、月ごとの合計時間を配列に格納
  Future total_time_set() async {
    final String? user_id = FirebaseAuth.instance.currentUser?.uid;
    final String year = DateFormat.y().format(DateTime.now());

    /// Reference(参照先の指定)
    final DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(user_id);

    /// Snapshot:Reference(参照先)の中身の実態。
    /// Snapshot(実態)から値を取り出す。
    for (var month in month_array) {
      final QuerySnapshot doces_snapshot =
          await docRef.collection(year + month).get();
      final List<QueryDocumentSnapshot> day_doces_array = doces_snapshot.docs;

      int total = 0;
      for (var day in day_doces_array) {
        int day_minute = int.parse(day.get('minute'));
        total = total + day_minute;
      }
      total_time_array.add({month: total});
    }
    // FutureBuilder用に適当に値返却
    return 'ok';
  }

  // 配列初期化
  // 関数が呼ばれる度に内部的に初期化したい。できるはず。
  void value_initialize() {
    total_time_array = [];
  }
}

/// コンストラクタで'_'をつけると、同ファイルからしか参照できない？
/// コンストラクタのルールがいまいちわかっていない。。。
/// とりあえず別ファイルから参照したかったから、'_'無しにした。
class RecordBarChart extends ConsumerWidget {
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
  // ↓WidgetのKey：valueの挙動はどうなっている？なんでTitleItem分だけ何回も読み込まれる？
  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    /// double型の小数点がうざいからint型変換経由で文字列へ。
    int tmp = value.toInt();
    String text = tmp.toString();
    // switch (value.toInt()) {
    //   case 0:
    //     text = 'Mn';
    //     break;
    //   case 1:
    //     text = 'Te';
    //     break;
    //   case 2:
    //     text = 'Wd';
    //     break;
    //   case 3:
    //     text = 'Tu';
    //     break;
    //   case 4:
    //     text = 'Fr';
    //     break;
    //   case 5:
    //     text = 'St';
    //     break;
    //   case 6:
    //     text = 'Sn';
    //     break;
    //   default:
    //     text = '';
    //     break;
    // }
    return Center(child: Text(text, style: style));
  }

  // ②barタイトルの設定
  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            // "関連軸に指定された値を持つタイトルウィジェットを取得する関数です。"
            // getTitlesWidgetが内部的に繰り返し処理をしているのだろう。と推測
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
            x: int.parse(month_array[i]),
            barRods: [
              // 各barの表示設定。色や幅とか。他のプロパティも今後、色々試してみる。
              BarChartRodData(
                // 月の合計時間をそれぞれ表示
                toY: (total_time_array[i][month_array[i]]!).toDouble(),
                color: Colors.lightBlue,
                //gradient: _barsGradient,
              )
            ],
            showingTooltipIndicators: [0],
          ),
      ];
}
