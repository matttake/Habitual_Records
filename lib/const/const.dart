// 日付に関する定数
class ConstDate {
  static const List<String> months = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
  ];

  static const List<String> days = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
  ];
}

// ドロップダウンメニューに関する定数
class ConstDropdown {
  static const List<String> minute = [
    '10',
    '20',
    '30',
    '40',
    '50',
    '60',
    '70',
    '80',
    '90',
    '100',
  ];
  static const List<String> count = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
  ];
  static const List<String> flag = [
    '1',
  ];
  static const List<String> targetType = [
    '作業時間を登録',
    '実施回数を登録',
    '実施の有無を登録',
  ];
  static const List<List<String>> targetItems = [
    ConstDropdown.minute,
    ConstDropdown.count,
    ConstDropdown.flag,
  ];
  static const String success = '登録しました。';
  static const String mistake = '作業時間が選択されていません。';
}

// FirebaseAuthエラーハンドリングメッセージ
class ErrorMessage {
  static const String emailAlreadyUse = '指定したメールアドレスは登録済みです';
  static const String emailInvalid = '指定したメールアドレスは無効な値です';
  static const String unknownText = '必要事項を記入してください';
  static const String wrongPassword = 'パスワードが一致しません';
  static const String userNotFount = '指定したメールアドレスに該当するユーザーが見つかりません';
  static const String weakPassword = 'パスワードは6桁以上で設定してください';
}

// 新規登録時のDialogメッセージ
class RegisterMessage {
  static const success = '目標を登録しました。';
  static const failure = '登録に失敗しました。';
  static const notEntered = '未入力 or 未選択';
}

// 積み上げ登録時のDialogメッセージ
const String registerBodyMsg = '選択された日付には既に記録が登録されていますが、上書きしますか？';
const String registerTrueMsg = '上書き登録する';
const String registerFalseMsg = '登録しない';
