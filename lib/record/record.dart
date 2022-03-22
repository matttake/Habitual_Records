import 'package:flutter/material.dart';

class Record extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("記録"),
      ),
      body: RecordBody(),
    );
  }
}

class RecordBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('hoge'),
    );
  }
}
