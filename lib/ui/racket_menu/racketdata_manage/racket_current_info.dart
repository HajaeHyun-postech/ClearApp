import 'dart:convert';
import 'dart:core';

import '../../login/login_info.dart';

class RacketCurrentInfo{
  int racketnumber;
  String brand;
  bool rentable;
  String racketname;
  String info;

  RacketCurrentInfo.fromMap(Map<String, dynamic> map) :
    racketnumber = (jsonDecode(map['racketnumber']) as int),
    brand = (jsonDecode(map['brand']) as String),
    rentable = (jsonDecode(map['rentable']) as bool),
    racketname = (jsonDecode(map['racketname']) as String),
    info = (jsonDecode(map['info']) as String);

  Map<String, dynamic> toMap() =>{
    'racketnumber' : racketnumber,
    'rentable' : rentable,
  };

}