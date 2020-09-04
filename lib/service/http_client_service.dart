import 'package:flutter/cupertino.dart';

abstract class HttpClientService {
  set accessToken(token);

  Future<dynamic> send(
      {@required String method,
      @required String address,
      String host,
      String port,
      Map<String, dynamic> params = const {},
      Map<String, dynamic> body = const {}});
}
