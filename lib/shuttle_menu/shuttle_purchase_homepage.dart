import 'package:clearApp/shuttle_menu/add_prch_button.dart';
import 'package:clearApp/shuttle_menu/add_prch_form.dart';
import 'package:flutter/cupertino.dart';

class ShuttlePrchHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        AddPrchForm(
          size: size,
        ),
        AddPrchButton(
          size: size,
        ),
      ],
    );
  }
}
