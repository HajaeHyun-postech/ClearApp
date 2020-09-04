import 'package:clearApp/store/base_client_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobx/mobx.dart';

import '../../vo/user/user.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore extends BaseClientStore with Store {
  // other stores:--------------------------------------------------------------

  // disposers:-----------------------------------------------------------------
  List<ReactionDisposer> disposers = [];

  // store variables:-----------------------------------------------------------
  @observable
  bool loading = false;

  // other variables:-----------------------------------------------------------
  final GlobalKey<FormBuilderState> fbKey = new GlobalKey<FormBuilderState>();

  User user;

  // actions:-------------------------------------------------------------------
  @action
  Future login() async {
    if (loading) return; //No login during login

    loading = true;
    if (fbKey.currentState.saveAndValidate()) {
      String povisId = fbKey.currentState.value['povisId'];
      int studentId = fbKey.currentState.value['studentId'];
      Map<String, dynamic> body = {'studentId': studentId, 'povisId': povisId};

      httpClient
          .send(method: "POST", address: "/jwt/token", body: body)
          .then((response) {
            String token = response['token'];
            httpClient.accessToken = token;
            user = User.fromJson(JwtDecoder.decode(token));
            updateOnSuccess("Login Success");
          })
          .catchError((e) => updateOnError(e.cause))
          .whenComplete(() => loading = false);
    } else {
      loading = false;
    }
  }

  // dispose:-------------------------------------------------------------------
  @action
  dispose() {
    super.dispose();
    for (final d in disposers) {
      d();
    }
  }

  // functions:-----------------------------------------------------------------
}
