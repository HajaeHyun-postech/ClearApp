import 'dart:convert';

import 'package:clearApp/login/login_info.dart';
import 'package:flutter/material.dart';

class GameData {
  String gameType;
  String description;
  DateTime date;
  TimeOfDay time;
  bool canAttend;
  bool constructed;
  bool deleted;
  int maxCapacity;
  List<LoginInfo> participants;

  GameData(Map<String, dynamic> formData) {
    gameType = formData['gameType'];
    description = formData['description'];
    date = formData['date'];
    time = formData['time'];
    canAttend = true;
    constructed = false;
    deleted = false;
    maxCapacity = formData['maxCapacity'];
    participants = new List();
  }

  GameData.fromMap(Map<String, dynamic> map)
      : gameType = (jsonDecode(map['gameType']) as String),
        description = (jsonDecode(map['description']) as String),
        date = DateTime.parse(jsonDecode(map['date'])),
        time = jsonDecode(map['time']),
        canAttend = jsonDecode(map['canAttend']),
        constructed = jsonDecode(map['constructed']),
        deleted = jsonDecode(map['deleted']),
        maxCapacity = jsonDecode(map['maxCapacity']),
        participants = (jsonDecode(map['participants']) as List)
            .map((i) => LoginInfo.fromMap(i))
            .toList();

  Map<String, dynamic> toMap() => {
        'gameType': gameType,
        'description': description,
        'date': date.toString(),
        'time': time.toString(),
        'canAttend': canAttend,
        'constructed': constructed,
        'deleted': deleted,
        'maxCapacity': maxCapacity,
        'participants': participants
      };
}
