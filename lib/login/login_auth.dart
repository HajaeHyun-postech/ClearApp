import 'dart:convert';

import 'package:logger/logger.dart';
import '../util/constants.dart' as Constants;
import 'login_info.dart';
import 'package:http/http.dart' as http;
import 'login_info.dart';

class LoginAuth {
  static Future<String> loginAuth(String povisId, int studentId) async {
    Map<String, dynamic> map = {'povisId': povisId, 'studentId': studentId};
    String url = Constants.subscriberListURL + '?action=loginAuth';
    map.forEach((key, value) {
      url += '&$key=$value';
    });

    var response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    var statusCode = response.statusCode;
    Map<String, dynamic> body = jsonDecode(response.body);

    if (statusCode != 200 || body.containsKey('error')) {
      Logger().e('error: ${body['error'].toString()}');
      return Future.error('error: ${body['error'].toString()}');
    } else {
      Logger().i('Loggin success with $povisId, $studentId');
      Logger().i('data: ${body['data']}');
      LoginInfo.fromMap(body['data']);
    }
  }
}
