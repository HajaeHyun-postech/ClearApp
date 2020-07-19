import 'dart:convert';
import 'dart:core';

import '../../login/login_info.dart';

class ShuttlePrchHstr {
  String key;
  int studentId;
  String usage;
  DateTime date;
  int price;
  int amount;
  List<String> shuttleList;
  bool deleted;
  bool received;
  bool approved;

  ShuttlePrchHstr(String _usage, int _price, int _amount) {
    studentId = LoginInfo().studentId;
    usage = _usage;
    date = new DateTime.now();
    price = _price;
    amount = _amount;
    shuttleList = new List<String>();
    received = false;
    approved = false;
    deleted = false;

    key = studentId.toString() +
        'W' +
        date.toString().replaceAll(new RegExp('\\D'), '');
  }

  ShuttlePrchHstr.fromMap(Map<String, dynamic> map)
      : key = (jsonDecode(map['key']) as String),
        studentId = (jsonDecode(map['studentId']) as int),
        usage = jsonDecode(map['usage'] as String),
        date = DateTime.parse(jsonDecode(map['date'])),
        price = (jsonDecode(map['price']) as int),
        amount = (jsonDecode(map['amount']) as int),
        shuttleList = (jsonDecode(map['shuttleList'])).cast<String>(),
        deleted = (jsonDecode(map['deleted']) as bool),
        received = (jsonDecode(map['received']) as bool),
        approved = (jsonDecode(map['approved']) as bool);

  Map<String, dynamic> toMap() => {
        'key': key,
        'studentId': studentId,
        'usage': usage,
        'date': date.toIso8601String(),
        'price': price,
        'amount': (amount),
        'shuttleList': shuttleList,
        'deleted': deleted,
        'received': received,
        'approved': approved,
      };
}
