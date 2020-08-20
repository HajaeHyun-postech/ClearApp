import 'package:clearApp/store/shuttle/shuttle_form_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class OrderButton extends StatefulWidget {
  //screen size
  final Function onTap;

  const OrderButton({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton>
    with SingleTickerProviderStateMixin {
  ButtonState buttonState = ButtonState.Small;
  AnimationController _controller;
  Animation<double> _buttonTextAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 450), vsync: this);
    _buttonTextAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(curve: Interval(0.7, 1.0), parent: _controller));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shuttleFormStore = Provider.of<ShuttleFormStore>(context);
    _controller.forward();

    return Container(
      height: ScreenUtil().setHeight(180),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
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
          onTap: widget.onTap,
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
                child: Center(child: Observer(
                  builder: (_) {
                    return shuttleFormStore.loading
                        ? JumpingText('BUY',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: ScreenUtil().setSp(50),
                                color: Colors.white))
                        : Text(
                            'BUY',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                fontSize: ScreenUtil().setSp(50)),
                          );
                  },
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum ButtonState { Small, Enlarged }
