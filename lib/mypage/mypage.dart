import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("マイページ"),
      ),
      body: MyPageBody(),
    );
  }
}

class MyPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('hoge'),
    );
  }
}
