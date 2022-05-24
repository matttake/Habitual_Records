import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetupModel {
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  // 現在設定されている目標を取得
  Future<String> targetSettingCheck() async {
    final DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(_userId).get();
    final selectedTarget = (doc.data()! as Map)['target'].toString();
    return selectedTarget;
  }
}
