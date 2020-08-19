import 'package:clearApp/main.dart';
import 'package:clearApp/util/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'data_manage/game_data.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class GameExpansionCard extends StatefulWidget {
  final bool initiallyExpanded;
  final GameData gameData;

  const GameExpansionCard(
      {Key key, this.initiallyExpanded = false, this.gameData})
      : super(key: key);

  @override
  _GameExpansionCardState createState() => _GameExpansionCardState();
}

class _GameExpansionCardState extends State<GameExpansionCard>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  AnimationController _controller;
  Animation<double> _heightFactor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              DateFormat('E')
                                  .format(widget.gameData.dateTime)
                                  .toUpperCase(),
                              style: TextStyle(
                                  fontSize: 13, fontFamily: 'Roboto')),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            DateFormat('d').format(widget.gameData.dateTime),
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              DateFormat('Hm').format(widget.gameData.dateTime),
                              style: TextStyle(
                                  fontSize: 13, fontFamily: 'Roboto')),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        width: 1,
                        height: 50,
                        color: Colors.grey.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.gameData.gameType,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500)),
                          Text(
                              widget.gameData.description != ''
                                  ? widget.gameData.description
                                  : 'no description',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Poppins',
                                color: ClearAppTheme.grey.withOpacity(0.8),
                              )),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.mapMarkerAlt,
                                size: 10,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                widget.gameData.location,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'Poppins',
                                    color: ClearAppTheme.grey.withOpacity(0.8),
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          /*
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 7),
                            child: LiteRollingSwitch(
                              value: true,
                              textOn: 'Attend',
                              textOff: 'Rest',
                              colorOn: LinearGradient(colors: <Color>[
                                Color(0xFF36D1DC),
                                Color(0xFF5B86E5)
                              ]),
                              colorOff: LinearGradient(colors: <Color>[
                                Color(0xFFEB3349),
                                Color(0xFFF45C43)
                              ]),
                              iconOn: Icons.thumb_up,
                              iconOff: Icons.hotel,
                              textSize: 12.0,
                              width: 90,
                              height: 15,
                              iconSize: 10,
                              rollingOffset: 65,
                              onChanged: (bool state) {
                                //Use it to manage the different states
                                print('Current State of SWITCH IS: $state');
                              },
                              onTap: () {},
                            ),
                          ),
                          */
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.center,
                          child: SleekCircularSlider(
                            min: 0,
                            max: widget.gameData.maxCapacity,
                            initialValue: widget.gameData.participantList.length
                                .toDouble(),
                            appearance: CircularSliderAppearance(
                                size: 60,
                                customColors: CustomSliderColors(
                                    trackColor: HexColor('#90E3D0'),
                                    progressBarColors: [
                                      HexColor('#96c93d'),
                                      HexColor('#00BFD5')
                                    ],
                                    shadowColor: HexColor('#5FC7B0'),
                                    shadowMaxOpacity: 0.05),
                                infoProperties: InfoProperties(
                                    bottomLabelStyle: TextStyle(
                                        color: HexColor('#002D43'),
                                        fontSize: 9,
                                        fontWeight: FontWeight.w200),
                                    bottomLabelText:
                                        '/${widget.gameData.maxCapacity.toInt()}',
                                    mainLabelStyle: TextStyle(
                                        color: ClearAppTheme.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w200),
                                    modifier: (double value) {
                                      final count = value.toInt();
                                      return '$count';
                                    }),
                                startAngle: 180,
                                angleRange: 360),
                          ),
                        )),
                    Icon(
                      FontAwesomeIcons.chevronRight,
                      size: 13,
                      color: ClearAppTheme.grey.withOpacity(0.8),
                    ),
                    SizedBox(
                      width: 10,
                    )
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
