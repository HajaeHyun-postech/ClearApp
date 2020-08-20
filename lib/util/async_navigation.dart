import 'package:clearApp/routes.dart';
import 'package:flutter/cupertino.dart';

class AsyncNavigation {
  static pushNamedAndRemoveUntilAsync(BuildContext context, String route,
      Function(Route<dynamic>) predicate) async {
    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(route, predicate);
    });
  }

  static pushNamedAsync(BuildContext context, String route) async {
    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamed(Routes.homescreen);
    });
  }
}
