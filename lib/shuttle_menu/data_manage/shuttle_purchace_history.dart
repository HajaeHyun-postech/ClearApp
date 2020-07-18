import 'dart:convert';
import 'dart:core';

import '../../login/login_info.dart';
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

    key = studentId + date.toString().replaceAll(new RegExp('\\D'), '');
  }

  ShuttlePrchHstr.fromMap(Map<String, String> map)
      : key = jsonDecode(map['key']),
        studentId = jsonDecode(map['studentId']),
        usage = jsonDecode(map['usage']),
        date = DateTime.parse(jsonDecode(map['date'])),
        price = jsonDecode(map['price']),
        amount = jsonDecode(map['amount']),
        shuttleList = (jsonDecode(map['shuttleList']) as List)
            ?.map((e) => e as int)
            ?.toList(),
        deleted = jsonDecode(map['deleted']),
        received = jsonDecode(map['received']),
        approved = jsonDecode(map['approved']);

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
