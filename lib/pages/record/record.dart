import 'package:flutter/material.dart';
import '../../common/is_release.dart';
import '../../const/const.dart';
import 'record_model.dart';

class Record extends StatelessWidget {
  const Record({required this.text, required this.targetType, Key? key})
      : super(key: key);
  final String text;
  final String targetType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: graphBackGroundColor,
      appBar: AppBar(
        title: Text(text + (isRelease() ? '' : '(開発環境)')),
        // 引数のtextの値でIconButton表示/非表示を判定
        actions: (() {
          if (text == '月毎の記録') {
            return [
              IconButton(
                icon: const Icon(Icons.signal_cellular_alt),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => Record(
                        text: '累計',
                        targetType: targetType,
                      ),
                    ),
                  );
                },
              ),
            ];
          } else {
            return null;
          }
        })(),
      ),
      body: SizedBox.expand(
        child: RecordBody(
          judgeText: text,
          targetType: targetType,
        ),
      ),
    );
  }
}

class RecordBody extends StatelessWidget {
  const RecordBody({
    required this.judgeText,
    required this.targetType,
    Key? key,
  }) : super(key: key);
  final String judgeText;
  final String targetType;

  @override
  Widget build(BuildContext context) {
    final insRecord = RecordModel();
    final insRecordTotal = RecordTotalModel();

    return FutureBuilder<List<Map<String, int>>>(
      // future: 引数のJudgeTextの値で、生成するインスタンスを判定
      future: (() {
        if (judgeText == '月毎の記録') {
          return insRecord.getTimeSet();
        } else {
          return insRecordTotal.getTimeSet();
        }
      })(),
      // builder:
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Map<String, int>>> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // 通信が失敗した場合
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        // snapshot.dataにデータが格納されていれば
        if (snapshot.hasData) {
          return SafeArea(
            child: AspectRatio(
              aspectRatio: 1.7,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                margin: EdgeInsets.zero,
                color: graphBackGroundColor,
                child: RecordBarChart(
                  totalTimeArray: snapshot.data,
                  targetType: targetType,
                ),
              ),
            ),
          );
        }
        return const Text('もう一度やり直してください。');
      },
    );
  }
}
