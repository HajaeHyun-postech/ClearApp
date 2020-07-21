import 'package:clearApp/shuttle_menu/data_manage/actions.dart';
import 'package:clearApp/shuttle_menu/data_manage/shuttle_hitsory_handler.dart';
import 'package:clearApp/util/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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
  bool adding;

  @override
  void initState() {
    super.initState();
    editing = false;
    adding = false;
    _controller =
        AnimationController(duration: Duration(milliseconds: 450), vsync: this);
    _buttonTextAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: Interval(0.7, 1.0), parent: _controller));

    //register
    ShuttlePrchHstrHandler().registerEditingStateChangeCallback((_editing) {
      if (!mounted) return;

      setState(() {
        editing = _editing;
        if (_editing)
          _controller.forward();
        else {
          adding = false;
          _controller.reverse();
        }
      });
    });

    ShuttlePrchHstrHandler().registerErrorCallback(() {
      if (!mounted) return;

      setState(() {
        adding = false;
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
    final Size buttonSize = Size(65.0, 65.0);
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
                  colors: <Color>[
                    Color(0xFF36D1DC),
                    Color(0xFF5B86E5),
                  ],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Logger().i('Shuttle button clicked');
                    if (!adding) {
                      if (editing) {
                        setState(() {
                          adding = true;
                        });
                        ShuttlePrchHstrHandler()
                            .eventHandle(EVENT.SubmitToAddNewEvent);
                      } else
                        ShuttlePrchHstrHandler().eventHandle(
                            EVENT.EditingStateChangeEvent,
                            editing: true);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      !adding
                          ? Icon(
                              Icons.add,
                              color: Colors.white,
                            )
                          : new CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  ClearAppTheme.white),
                            ),
                      SizeTransition(
                        sizeFactor: _buttonTextAnimation,
                        axis: Axis.horizontal,
                        axisAlignment: -1.0,
                        child: Center(
                          child: Text(
                            !adding ? 'BUY' : '',
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
            )));
  }
}

enum ButtonState { Small, Enlarged }
