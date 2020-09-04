import 'package:clearApp/service/navigation_service.dart';
import 'package:clearApp/widget/toast_generator.dart';
import 'package:flutter/cupertino.dart';

class NavigationServiceImpl implements NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey =
      new GlobalKey<NavigatorState>();

  @override
  get navigatorKey => _navigatorKey;

  @override
  Future pushNamed(String routeName) {
    return _navigatorKey.currentState.pushNamed(routeName);
  }

  @override
  Future pushNamedAndRemoveAll(String routeName) {
    return _navigatorKey.currentState
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  void showErrorToast(String desc) {
    ToastGenerator.errorToast(_navigatorKey.currentContext, desc);
  }

  void showSuccessToast(String desc) {
    ToastGenerator.successToast(_navigatorKey.currentContext, desc);
  }

  void showInfoToast(String desc) {
    ToastGenerator.infoToast(_navigatorKey.currentContext, desc);
  }
}
