import 'package:clearApp/ui/shuttle_menu/add_prch_button.dart';
import 'package:clearApp/ui/shuttle_menu/data_manage/events.dart';
import 'package:clearApp/ui/shuttle_menu/usage_select_button.dart';
import 'package:clearApp/widget/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:logger/logger.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

import 'data_manage/form_subject.dart';
import 'data_manage/shuttle_purchace_history.dart';

enum UsageLists {
  Regular_Meeting,
  Personal_Use,
  Training,
  Official_Event,
  Prize
}

class AddPrchForm extends StatefulWidget {
  const AddPrchForm({Key key}) : super(key: key);

  @override
  AddPrchFormState createState() {
    return new AddPrchFormState();
  }
}

class AddPrchFormState extends State<AddPrchForm>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  AnimationController _remainingController;
  AnimationController _invalidUsageController;

  bool _amountOverflowed;
  int _selectedAmount;
  UsageLists _selectedUsage;
  String _selectedUsageString;

  void _setInitial() {
    _selectedAmount = 0;
    _selectedUsage = null;
    _selectedUsageString = '';
    _amountOverflowed = false;
  }

  @override
  void initState() {
    super.initState();
    _setInitial();

    /*Animation Settings*/
    _scrollController = ScrollController();
    _remainingController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _invalidUsageController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  }

  Future<void> validateNewPrch() async {
    //form validation check
    if (_selectedUsageString == '') throw FormatException('usage');
    if (_selectedAmount < 1) throw FormatException('amount');

    Logger().i('Usage: $_selectedUsage, Amount: $_selectedAmount');

    ShuttlePrchHstr newHstr =
        new ShuttlePrchHstr(_selectedUsageString, 0, _selectedAmount);

    final formSubject = Provider.of<FormSubject>(context, listen: false);
    await formSubject.eventHandle(EVENT.AddNewEvent, newHstr: newHstr);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Wrap _buildUsageSelectionRow() {
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 10.0,
      children: <Widget>[
        UsageSelectButton(
          text: 'Personal Use',
          selected: _selectedUsage == UsageLists.Personal_Use,
          onChange: (bool selected) {
            _handleUsageChange(
                selected, 'Personal Use', UsageLists.Personal_Use);
          },
        ),
        SizedBox(width: ScreenUtil().setWidth(35)),
        UsageSelectButton(
          text: 'Regular Meeting',
          selected: _selectedUsage == UsageLists.Regular_Meeting,
          onChange: (bool selected) {
            _handleUsageChange(
                selected, 'Regular Meeting', UsageLists.Regular_Meeting);
          },
        ),
        SizedBox(width: ScreenUtil().setWidth(35)),
        UsageSelectButton(
          text: 'Training',
          selected: _selectedUsage == UsageLists.Training,
          onChange: (bool selected) {
            _handleUsageChange(selected, 'Training', UsageLists.Training);
          },
        ),
        SizedBox(width: ScreenUtil().setWidth(35)),
        UsageSelectButton(
          text: 'Offical Event',
          selected: _selectedUsage == UsageLists.Official_Event,
          onChange: (bool selected) {
            _handleUsageChange(
                selected, 'Offical event', UsageLists.Official_Event);
          },
        ),
        SizedBox(width: ScreenUtil().setWidth(35)),
        UsageSelectButton(
          text: 'Prize',
          selected: _selectedUsage == UsageLists.Prize,
          onChange: (bool selected) {
            _handleUsageChange(selected, 'Prize', UsageLists.Prize);
          },
        )
      ],
    );
  }

  void _handleUsageChange(
      bool selected, String usage, UsageLists selectedUsage) {
    setState(() {
      if (selected) {
        _invalidUsageController.reverse();
        _selectedUsageString = usage;
        _selectedUsage = selectedUsage;
      } else {
        _selectedUsageString = '';
        _selectedUsage = null;
      }
    });
  }

  Column _buildAmountSelection(Animation<double> animation) {
    final formSubject = Provider.of<FormSubject>(context);

    return Column(children: <Widget>[
      AnimatedBuilder(
        animation: animation,
        builder: (buildContext, child) {
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    left: animation.value + 20.0,
                    right: (20.0 - animation.value) < 0
                        ? 0
                        : 20.0 - animation.value),
                child: Text('Remaining',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: ScreenUtil().setSp(50),
                        color: _amountOverflowed
                            ? ClearAppTheme.lightRed
                            : ClearAppTheme.grey)),
              ),
              Container(
                  padding: EdgeInsets.only(
                      top: 15,
                      left: animation.value + 20.0,
                      right: (20.0 - animation.value) < 0
                          ? 0
                          : 20.0 - animation.value),
                  child: formSubject.isFeching
                      ? JumpingText('...',
                          style: TextStyle(fontSize: ScreenUtil().setSp(100)))
                      : Text(formSubject.remainingShuttles.toString(),
                          style: TextStyle(
                              fontFamily: ClearAppTheme.fontName,
                              fontSize: ScreenUtil().setSp(100),
                              color: _amountOverflowed
                                  ? ClearAppTheme.lightRed
                                  : ClearAppTheme.grey))),
            ],
          );
        },
      ),
      SizedBox(height: ScreenUtil().setHeight(48)),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (_selectedAmount - 1 >= 0)
                setState(() {
                  _amountOverflowed = false;
                  _selectedAmount = _selectedAmount - 1;
                });
              else {
                setState(() {
                  _remainingController.forward(from: 0.0);
                  _amountOverflowed = true;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: ClearAppTheme.white.withOpacity(0),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  Icons.remove,
                  color: ClearAppTheme.black,
                  size: 24,
                ),
              ),
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(70)),
          Container(
            child: Text(
              _selectedAmount.toString(),
              style: TextStyle(
                  fontFamily: 'Roboto', fontSize: ScreenUtil().setSp(65)),
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(70)),
          GestureDetector(
            onTap: () {
              if (_selectedAmount + 1 <= formSubject.remainingShuttles)
                setState(() {
                  _amountOverflowed = false;
                  _selectedAmount = _selectedAmount + 1;
                });
              else {
                setState(() {
                  _remainingController.forward(from: 0.0);
                  _amountOverflowed = true;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: ClearAppTheme.white..withOpacity(0),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  Icons.add,
                  color: ClearAppTheme.black,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_remainingController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _remainingController.reverse();
            }
          });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          color: Colors.white,
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.all(25.0),
            shrinkWrap: true,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Select Usage',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: ScreenUtil().setSp(72),
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(40)),
                  FadeTransition(
                    child: Text(
                      'Usage is required',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: ScreenUtil().setSp(40),
                          color: Colors.red),
                    ),
                    opacity: _invalidUsageController,
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(70)),
              _buildUsageSelectionRow(),
              SizedBox(height: ScreenUtil().setHeight(90)),
              _buildAmountSelection(offsetAnimation),
              SizedBox(height: ScreenUtil().setHeight(90)),
              AddPrchButton(
                tapCallback: () => validateNewPrch()
                    .catchError((e) => _invalidUsageController.forward(),
                        test: (e) =>
                            e is FormatException && e.message == 'usage')
                    .catchError(
                        (e) => setState(() {
                              _remainingController.forward(from: 0.0);
                              _amountOverflowed = true;
                            }),
                        test: (e) =>
                            e is FormatException && e.message == 'amount'),
              )
            ],
          ),
        ),
      ],
    );
  }
}
