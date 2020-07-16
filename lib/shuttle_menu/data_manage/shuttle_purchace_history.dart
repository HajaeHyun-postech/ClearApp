import 'dart:core';

import '../../login/login_info.dart';

class ShuttlePrchHstr {
  String key;
  String studentId;
  String usage;
  DateTime date;
  int price;
  int amount;
  List<int> shuttleList;
  bool deleted;
  bool received;
  bool approved;

  ShuttlePrchHstr(String _usage, int _price, int _amount) {
    studentId = LoginInfo().studentId;
    usage = _usage;
    date = new DateTime.now();
    price = _price;
    amount = _amount;
    shuttleList = new List<int>();
    received = false;
    approved = false;
    deleted = false;

    key = studentId + date.toString();
  }

  ShuttlePrchHstr.fromMap(Map<String, dynamic> map)
      : key = map['key'],
        studentId = map['studentId'],
        usage = map['usage'],
        date = map['date'],
        price = map['price'],
        amount = map['amount'],
        shuttleList = map['shuttleList'],
        deleted = map['deleted'],
        received = map['received'],
        approved = map['approved'];

  Map<String, dynamic> toMap() => {
        'key': key,
        'studentId': studentId,
        'usage': usage,
        'date': date,
        'price': price,
        'amount': amount,
        'shuttleList': shuttleList,
        'deleted': deleted,
        'received': received,
        'approved': approved,
      };
}
