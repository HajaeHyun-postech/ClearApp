import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class APIService {
  static Future<String> doGet(
      String baseURL, String action, Map<String, dynamic> params) async {
    String url = baseURL + '?action=$action';
    params.forEach((key, value) {
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
      throw ('error: ${body['error'].toString()}');
    } else {
      Logger().i('http  reqeust response success');
    }
    return response.body;
  }
}
