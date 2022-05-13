import 'package:flutter/material.dart';
import 'record_model.dart';

class Record extends StatelessWidget {
  const Record({required this.text, Key? key}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(text),
          // 引数のtextの値でIconButton表示/非表示を判定
          actions: (() {
            if (text == '月毎の記録') {
              return [
                IconButton(
                  icon: const Icon(Icons.signal_cellular_alt),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Record(text: '累計')));
                  },
                ),
              ];
            } else {
              return null;
            }
          })(),
        ),
        body: SizedBox.expand(child: RecordBody(judgeText: text)));
  }
}

class RecordBody extends StatelessWidget {
  const RecordBody({required this.judgeText, Key? key}) : super(key: key);
  final String judgeText;

  @override
  Widget build(BuildContext context) {
    final insRecord = RecordModel();
    final insRecordTotal = RecordTotalModel();

    return FutureBuilder(
        // future: 引数のJudgeTextの値で、生成するインスタンスを判定
        future: (() {
      if (judgeText == '月毎の記録') {
        return insRecord.getTimeSet();
      } else {
        return insRecordTotal.getTimeSet();
      }
    })(),
        // builder:
        builder: (BuildContext context, AsyncSnapshot snapshot) {
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
        return AspectRatio(
          aspectRatio: 1.7,
          child: Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            margin: const EdgeInsets.all(0.0),
            color: const Color(0xff2c4260),
            child: RecordBarChart(snapshot.data),
          ),
        );
      }
      return const Text('もう一度やり直してください。');
    });
  }
}
