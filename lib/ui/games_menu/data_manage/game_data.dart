import 'dart:convert';

import 'package:clearApp/ui/login/login_info.dart';

class GameData implements Comparable {
  int key;
  String gameType;
  String description;
  String location;
  DateTime dateTime;
  bool canAttend;
  bool constructed;
  bool deleted;
  double maxCapacity;
  List<LoginInfo> participantList;

  GameData(Map<String, dynamic> formData) {
    key = 0;
    gameType = formData['gameType'];
    description = formData['description'];
    location = formData['location'];
    dateTime = formData['dateTime'];
    canAttend = true;
    constructed = false;
    deleted = false;
    maxCapacity = formData['maxCapacity'];
    participantList = new List();
  }

  GameData.fromMap(Map<String, dynamic> map)
      : key = (jsonDecode(map['key']) as int),
        gameType = (jsonDecode(map['gameType']) as String),
        description = (jsonDecode(map['description']) as String),
        location = (jsonDecode(map['location']) as String),
        dateTime = DateTime.parse(jsonDecode(map['dateTime'])),
        canAttend = jsonDecode(map['canAttend']),
        constructed = jsonDecode(map['constructed']),
        deleted = jsonDecode(map['deleted']),
        maxCapacity = double.parse((map['maxCapacity'])),
        participantList = (jsonDecode(map['participantList']) as List)
            .map((info) => LoginInfo.fromMap(info))
            .toList();

  Map<String, dynamic> toMap() => {
        'key': key,
        'gameType': gameType,
        'description': description,
        'location': location,
        'dateTime': dateTime.toString(),
        'canAttend': canAttend,
        'constructed': constructed,
        'deleted': deleted,
        'maxCapacity': maxCapacity,
        'participantList': participantList.map((info) => info.toMap()).toList()
      };
  @override
  int compareTo(other) {
    if (this.key < other.key) {
      return 1;
    }
    if (this.key > other.key) {
      return -1;
    }
  }
}
