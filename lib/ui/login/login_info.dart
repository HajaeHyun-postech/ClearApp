/*
 * Class : LoginInfo
 * Description : Holding povisId & student id, using singeton pattern
 * Example code :
 * LoginInfo().getName() == LoginInfo().getName() //true 
 */

import 'dart:convert';

@deprecated
class LoginInfo {
  static final LoginInfo _loginInfo = LoginInfo._internal();
  String name;
  String povisId;
  int studentId;
  bool isAdmin;
  int uniqueRow;

  factory LoginInfo() {
    return _loginInfo;
  }

  LoginInfo._internal();

  LoginInfo.fromMap(Map<String, dynamic> map) {
    LoginInfo().name = (jsonDecode(map['name']) as String);
    LoginInfo().povisId = (jsonDecode(map['povisId']) as String);
    LoginInfo().studentId = (jsonDecode(map['studentId']) as int);
    LoginInfo().isAdmin = (jsonDecode(map['isAdmin']) as bool);
    LoginInfo().uniqueRow = (jsonDecode(map['uniqueRow']) as int);
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'povisId': povisId,
        'studentId': studentId,
        'isAdmin': isAdmin,
        'uniqueRow': uniqueRow,
      };
}
