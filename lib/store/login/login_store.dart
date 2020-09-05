import 'package:clearApp/contants/globals.dart';
import 'package:clearApp/routes.dart';
import 'package:clearApp/service/navigation_service.dart';
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
            httpClient.accessToken = response['token'];
            success("Login Success");
            locator<NavigationService>().pushNamedAndRemoveAll(
                Routes.homescreen,
                arguments: User.fromJson(JwtDecoder.decode(response['token'])));
          })
          .catchError((e) => error(e.cause))
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
