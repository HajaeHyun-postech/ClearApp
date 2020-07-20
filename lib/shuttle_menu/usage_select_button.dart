import 'package:clearApp/shuttle_menu/base_select.dart';
import 'package:clearApp/util/app_theme.dart';
import 'package:flutter/material.dart';

class UsageSelectButton extends StatelessWidget {
  final String text;
  final bool selected;
  final ValueChanged<bool> onChange;

  const UsageSelectButton({
    Key key,
    this.text,
    this.selected = false,
    this.onChange,
  }) : super(key: key);

  Widget _buildtext(color) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(
        text,
        style: TextStyle(
            color: color,
            fontFamily:
                ClearAppTheme.buildLightTheme().textTheme.bodyText1.fontFamily),
      ),
    );
  }

  Widget _buildContainer(Color color, [Color fillColor]) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor != null ? fillColor : Colors.white,
        border: Border.all(
          color: color,
          width: 1.0,
        ),
      ),
      child: fillColor != null ? _buildtext(Colors.white) : _buildtext(color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseSelect(
      selected: selected,
      onChange: onChange,
      builder: (BuildContext context, Animation animation) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(Colors.grey),
            SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              child: _buildContainer(
                  Colors.blue.withOpacity(0.8), Colors.blue.withOpacity(0.8)),
            ),
          ],
        );
      },
    );
  }
}
