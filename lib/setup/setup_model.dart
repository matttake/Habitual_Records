import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SetupModel {
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  // 現在設定されている目標を取得
  Future targetSettingCheck() async {
    final DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(_userId).get();
    String selectedTarget = (doc.data() as Map)['target'];
    return selectedTarget;
  }
}
