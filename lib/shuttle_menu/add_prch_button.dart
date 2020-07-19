import 'package:clearApp/shuttle_menu/data_manage/shuttle_hitsory_handler.dart';
import 'package:clearApp/util/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class AddPrchButton extends StatefulWidget {
  //screen size
  final Size size;

  const AddPrchButton({
    Key key,
    this.size,
  }) : super(key: key);

  @override
  _AddPrchButtonState createState() => _AddPrchButtonState();
}

class _AddPrchButtonState extends State<AddPrchButton>
    with SingleTickerProviderStateMixin {
  ButtonState buttonState = ButtonState.Small;
  AnimationController _controller;
  Animation<RelativeRect> _buttonAnimation;
  Animation<double> _buttonTextAnimation;
  bool editing;

  @override
  void initState() {
    super.initState();
    editing = false;

    _controller =
        AnimationController(duration: Duration(milliseconds: 450), vsync: this);

    _buttonTextAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: Interval(0.7, 1.0), parent: _controller));

    ShuttlePrchHstrHandler().editingChangedCallback.add((_editing) {
      if (!mounted) return;
      setState(() {
        editing = _editing;
        if (editing)
          _controller.forward();
        else
          _controller.reverse();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = widget.size;
    final Size buttonSize = Size(75.0, 75.0);
    final double top = size.height - buttonSize.height;
    final double initialLeftRight = (size.width - buttonSize.width) / 2;

    _buttonAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          initialLeftRight, top - 25.0, initialLeftRight, 25.0),
      end: RelativeRect.fromLTRB(0.0, top, 0.0, 0.0),
    ).animate(CurvedAnimation(curve: Interval(0.0, 0.7), parent: _controller));

    return Theme(
        data: ClearAppTheme.buildLightTheme(),
        child: PositionedTransition(
          rect: _buttonAnimation,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              shape: editing ? BoxShape.rectangle : BoxShape.circle,
              gradient: LinearGradient(
                colors: <Color>[Color(0xFF60a0d7), Color(0xFF5fa0d6)],
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (editing)
                    ShuttlePrchHstrHandler().submitEventHandle();
                  else
                    ShuttlePrchHstrHandler().changeEditingState(true);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizeTransition(
                      sizeFactor: _buttonTextAnimation,
                      axis: Axis.horizontal,
                      axisAlignment: -1.0,
                      child: Center(
                        child: Text(
                          'BUY',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

enum ButtonState { Small, Enlarged }
