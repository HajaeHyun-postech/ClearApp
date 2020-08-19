import 'dart:convert';
import 'dart:io';
import 'package:clearApp/exception/auth_exception.dart';
import 'package:clearApp/exception/invalid_req_exception.dart';
import 'package:clearApp/exception/method_not_allowed_exception.dart';
import 'package:clearApp/exception/not_found_exception.dart';
import 'package:clearApp/exception/server_error_exception.dart';
import 'package:clearApp/exception/unexpected_conflict_exception.dart';
import 'package:clearApp/exception/unknown_status_code_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class HttpClient {
  static const String APIHost = "49.50.165.208";
  static const String APIPort = "8096";
  static String token;

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

  static Future<Map<String, dynamic>> doPatch(
      {@required String address,
      Map<String, dynamic> params,
      String body}) async {
    String url = '$APIHost:$APIPort?';
    params.forEach((key, value) {
      url += '&$key=$value';
    });

    http
        .post(url,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token'
            },
            body: body)
        .then((response) {
      Map<String, dynamic> body = jsonDecode(response.body);
      var statusCode = response.statusCode;

      if (statusCode == 200) {
        return body;
      } else {
        String errMsg = body['err'];
        switch (statusCode) {
          case 400:
            return Future.error(InvalidReqException(errMsg));
            break;
          case 401:
            return Future.error(AuthException(errMsg));
            break;
          case 403:
            return Future.error(NotFoundException(errMsg));
            break;
          case 405:
            return Future.error(MethodNotAllowedException(errMsg));
            break;
          case 409:
            return Future.error(UnexpectedConflictException(errMsg));
            break;
          case 500:
            return Future.error(ServerErrorException(errMsg));
            break;
          default:
            return Future.error(UnknownStatusCodeException(errMsg));
            break;
        }
      }
    });
  }
}
