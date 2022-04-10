import 'package:flutter/material.dart';
import 'record_model.dart';

class Record extends StatelessWidget {
  const Record({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("記録"),
        ),
        body: const SizedBox.expand(child: RecordBody()));
  }
}

class RecordBody extends StatelessWidget {
  const RecordBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        margin: const EdgeInsets.all(0.0),
        color: const Color(0xff2c4260),
        child: RecordBarChart(),
      ),
    );
  }
}
