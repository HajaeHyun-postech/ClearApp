import 'package:clearApp/routes.dart';
import 'package:flutter/cupertino.dart';

class AsyncNavigation {
  static pushNamedAndRemoveUntilAsync(
      BuildContext context, String route, Function(Route<dynamic>) predicate,
      {Object arguments}) async {
    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(route, predicate, arguments: arguments);
    });
  }

  static pushNamedAsync(BuildContext context, String route) async {
    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamed(Routes.homescreen);
    });
  }

  static popUntilAsync(BuildContext context, String route) {
    Navigator.popUntil(context, (route) => route.settings.name == route);
  }
}
