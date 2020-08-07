import 'package:clearApp/util/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import '../util/constants.dart' as Constants;
import 'login_info.dart';

class LoginAuth extends ChangeNotifier {
  bool isFetching = false;
  String povisId;
  int studentId;

  Future<void> doLoginAuth() async {
    isFetching = true;
    notifyListeners();

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
  }
}
