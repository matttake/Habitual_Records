import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userId = FirebaseAuth.instance.currentUser?.uid;
final data = {
  'uid': userId,
  'createdAt': Timestamp.now(),
};

// "delete_users"にuserid登録がトリガーで、cloudFunctionsにてアカウント削除
Future<void> deleteAccount() async {
  await FirebaseFirestore.instance.collection('delete_users').add(data);
}
