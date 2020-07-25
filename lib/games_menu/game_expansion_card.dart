import 'package:clearApp/main.dart';
import 'package:clearApp/util/app_theme.dart';
import 'package:clearApp/games_menu/rolling_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class GameExpansionCard extends StatefulWidget {
  final bool initiallyExpanded;

  const GameExpansionCard({Key key, this.initiallyExpanded = false})
      : super(key: key);

  @override
  _GameExpansionCardState createState() => _GameExpansionCardState();
}

class _GameExpansionCardState extends State<GameExpansionCard>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  AnimationController _controller;
  Animation<double> _heightFactor;
  Animation<double> _iconTurns;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));

    _isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    return InkWell(
        onTap: _handleTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
            color: ClearAppTheme.nearlyWhite,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text('THU',
                              style: TextStyle(
                                  fontSize: 15, fontFamily: 'Roboto')),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '30',
                            style:
                                TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('10:30',
                              style: TextStyle(
                                  fontSize: 15, fontFamily: 'Roboto')),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('Regular Meeting',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600)),
                          SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            child: LiteRollingSwitch(
                              value: true,
                              textOn: 'Attend',
                              textOff: 'Absent',
                              colorOn: LinearGradient(colors: <Color>[
                                Color(0xFF36D1DC),
                                Color(0xFF5B86E5)
                              ]),
                              colorOff: LinearGradient(colors: <Color>[
                                Color(0xFFEB3349),
                                Color(0xFFF45C43)
                              ]),
                              iconOn: Icons.thumb_up,
                              iconOff: Icons.thumb_down,
                              textSize: 12.0,
                              width: 95,
                              height: 15,
                              iconSize: 10,
                              rollingOffset: 70,
                              onChanged: (bool state) {
                                //Use it to manage the different states
                                print('Current State of SWITCH IS: $state');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.center,
                          child: SleekCircularSlider(
                            min: 10,
                            max: 60,
                            initialValue: 20,
                            appearance: CircularSliderAppearance(
                                size: 60,
                                customColors: CustomSliderColors(
                                    trackColor: HexColor('#90E3D0'),
                                    progressBarColors: [
                                      HexColor('#FFC84B'),
                                      HexColor('#00BFD5')
                                    ],
                                    shadowColor: HexColor('#5FC7B0'),
                                    shadowMaxOpacity: 0.05),
                                infoProperties: InfoProperties(
                                    bottomLabelStyle: TextStyle(
                                        color: HexColor('#002D43'),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w200),
                                    bottomLabelText: '/60',
                                    mainLabelStyle: TextStyle(
                                        color: ClearAppTheme.grey,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w200),
                                    modifier: (double value) {
                                      final count = value.toInt();
                                      return '$count';
                                    }),
                                startAngle: 180,
                                angleRange: 340),
                          ),
                        )),
                  ],
                ),
              ),
              ClipRect(
                child: Align(
                  heightFactor: _heightFactor.value,
                  child: child,
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return Theme(
      data: ClearAppTheme.buildLightTheme(),
      child: AnimatedBuilder(
        animation: _controller.view,
        builder: _buildChildren,
        child: closed
            ? null
            : Row(
                children: <Widget>[
                  Text('expanded'),
                ],
              ),
      ),
    );
  }
}
