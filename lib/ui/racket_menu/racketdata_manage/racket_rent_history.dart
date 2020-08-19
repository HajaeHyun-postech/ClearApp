import 'dart:convert';
import 'dart:core';

import '../../login/login_info.dart';

class RacketRentHstr{
  String key;
  String username;
  int studentId;
  DateTime rentdate;
  DateTime returndate;
  int racketnumber;
  bool isrenting;

  RacketRentHstr(){
    studentId = LoginInfo().studentId;
    username = LoginInfo().name;
    rentdate = new DateTime.now();
    isrenting = true;

    key = studentId.toString() + 'W' + rentdate.toString().replaceAll(new RegExp('\\D'), ' ');
  }

  RacketRentHstr.fromMap(Map<String, dynamic> map)
    : key = (jsonDecode(map['key']) as String),
      username = (jsonDecode(map['name']) as String),
      studentId = (jsonDecode(map['studentId']) as int),
      rentdate = DateTime.parse(jsonDecode(map['rentdate'])),
      returndate = DateTime.parse(jsonDecode(map['returndate'])),
      isrenting = (jsonDecode(map['name']) as bool),
      racketnumber = (jsonDecode(map['racketnumber']) as int);

      Map<String, dynamic> toMap() => {
        'key' : key,
        'name' : username,
        'studentId' : studentId,
        'rentdate' : rentdate.toIso8601String(),
        'returndate' : returndate.toIso8601String(),
        'racketnumber' : racketnumber,
        'isrenting' : isrenting,
      };
}
