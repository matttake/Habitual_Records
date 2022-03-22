import 'package:flutter/material.dart';

class Setup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      body: SetupBody(),
    );
  }
}

class SetupBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('hoge'),
    );
  }
}
