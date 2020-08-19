import 'package:clearApp/exception/auth_exception.dart';
import 'package:clearApp/util/http_client.dart';
import 'package:clearApp/vo/user/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  ///Store Variables///
  @observable
  bool loading = false;

  @observable
  bool success = false;

  ///Other Variable///
  final GlobalKey<FormBuilderState> fbKey = new GlobalKey<FormBuilderState>();

  String errorMsg;

  ///Actions///
  @action
  Future login() async {
    loading = true;
    if (fbKey.currentState.saveAndValidate()) {
      String povisId = fbKey.currentState.value['povisId'];
      int studentId = fbKey.currentState.value['studentId'];
      Map<String, dynamic> body = {'studentId': studentId, 'povisId': povisId};

      HttpClient.send(method: "POST", address: "/api/clear/login", body: body)
          .then((response) {
            String token = response['token'];
            HttpClient.token = token;
            User.fromJson(JwtDecoder.decode(token));
            success = true;
            loading = false;
          })
          .catchError((e) => errorMsg = "Login Failed",
              test: (e) => e is AuthException)
          .catchError((e) => errorMsg = "Unknown Error Occured")
          .whenComplete(() {
            loading = false;
            success = false;
          });
    } else {
      loading = false;
      success = false;
    }
  }
}
