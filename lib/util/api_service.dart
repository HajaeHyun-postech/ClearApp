import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class APIService {
  static Future<Map<String, dynamic>> doGet(
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
      throw HttpException('Get failed with ${body['error'].toString()}');
    } else {
      Logger().i('http  reqeust response success');
    }
    return body;
  }

  static Future<Map<String, dynamic>> doPost(String baseURL, String action,
      {String body: '{}', Map<String, dynamic> params: const {}}) async {
    String url = baseURL + '?action=$action';
    params.forEach((key, value) {
      url += '&$key=$value';
    });

    var response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: body);

    var statusCode = response.statusCode;

    if (statusCode == 302) {
      Logger().i('Redirecting...');
      var redirectResponse =
          await http.get(response.headers['location'], headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });

      Map<String, dynamic> body = jsonDecode(redirectResponse.body);
      if (body.containsKey('error')) {
        Logger().e('error: ${body['error'].toString()}');
        throw HttpException('Post failed with ${body['error'].toString()}');
      } else {
        Logger().i('http  redirect post response success');
        return body;
      }
    } else if (statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      if (body.containsKey('error')) {
        Logger().e('error: ${body['error'].toString()}');
        throw HttpException('Post failed with ${body['error'].toString()}');
      } else {
        Logger().i('http  post response success');
        return body;
      }
    } else {
      Logger().e('error: $statusCode');
      throw ('error: $statusCode');
    }
  }
}
