import 'package:clearApp/util/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:logger/logger.dart';
import '../util/constants.dart' as Constants;
import 'login_info.dart';

class LoginAuth extends ChangeNotifier {
  bool isFetching = false;
  final GlobalKey<FormBuilderState> fbKey = new GlobalKey<FormBuilderState>();

  Future<void> doLoginAuth() async {
    if (fbKey.currentState.saveAndValidate()) {
      isFetching = true;
      notifyListeners();
      String povisId = fbKey.currentState.value['povisId'];
      int studentId = fbKey.currentState.value['studentId'];

      try {
        Logger().i('Login with... $povisId, $studentId');
        Map<String, dynamic> map = {'povisId': povisId, 'studentId': studentId};
        var response =
            await APIService.doGet(Constants.memberlistURL, 'loginAuth', map);

        LoginInfo.fromMap(response['data']);
      } catch (e) {
        throw e;
      } finally {
        isFetching = false;
        notifyListeners();
      }
    } else {
      return Future.error(FormatException());
    }
  }
}
