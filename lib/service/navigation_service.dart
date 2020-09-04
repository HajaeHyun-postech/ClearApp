import 'package:flutter/cupertino.dart';

abstract class NavigationService {
  get navigatorKey;

  Future<dynamic> pushNamed(String routeName);

  Future<dynamic> pushNamedAndRemoveAll(String routeName);

  void showErrorToast(String desc);

  void showSuccessToast(String desc);

  void showInfoToast(String desc);
}
