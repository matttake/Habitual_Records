const functions = require("firebase-functions");
const admin = require("firebase-admin");

// firebase-adminの初期化
admin.initializeApp();

exports.deleteUser = functions
    .region("asia-northeast2")
    .firestore.document("delete_users/{docId}")
    .onCreate(async (snap, context) => {
      const deleteDocument = snap.data();
      const uid = deleteDocument.uid;

      // Authenticationのユーザーを削除する
      await admin.auth().deleteUser(uid);
    });