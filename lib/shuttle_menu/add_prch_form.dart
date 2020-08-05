import 'dart:async';
import 'dart:convert';
import 'package:clearApp/shuttle_menu/data_manage/events.dart';
import 'package:clearApp/shuttle_menu/data_manage/shuttle_hitsory_handler.dart';
import 'package:clearApp/shuttle_menu/data_manage/shuttle_purchace_history.dart';
import 'package:clearApp/shuttle_menu/usage_select_button.dart';
import 'package:clearApp/util/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../util/constants.dart' as Constants;
import 'package:clearApp/util/api_service.dart';

enum UsageLists {
  Regular_Meeting,
  Personal_Use,
  Training,
  Official_Event,
  Prize
}

class AddPrchForm extends StatefulWidget {
  //screen size
  final Size size;

  const AddPrchForm({Key key, this.size}) : super(key: key);

  @override
  AddPrchFormState createState() {
    return new AddPrchFormState();
  }
}

class AddPrchFormState extends State<AddPrchForm>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _textController;
  AnimationController _animCntroller;
  ScrollController _scrollController;
  Animation<RelativeRect> _rectAnimation;
  AnimationController _remainingController;
  bool loading;
  bool editing;
  bool amountOverflowed;
  int selectedAmount;
  int remainAmount;
  UsageLists selectedUsage;
  String selectedUsageString;

  void _setInitial() {
    selectedAmount = 0;
    remainAmount = 0;
    selectedUsage = null;
    selectedUsageString = '';
    editing = false;
    amountOverflowed = false;
    loading = true;
  }

  @override
  void initState() {
    super.initState();
    _setInitial();

    /*Animation Settings*/
    _scrollController = ScrollController();
    _textController = TextEditingController();
    _animCntroller = AnimationController(
        duration: Duration(milliseconds: 300), value: 0.0, vsync: this);
    _remainingController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);

    final Size size = widget.size;
    _rectAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, size.height, 0.0, -size.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_animCntroller);

    /*Callback registeration*/
    ShuttlePrchHstrHandler().registerErrorCallback(() {
      Logger().i('error call back in form');
      if (!mounted) return;
      _remainingController.forward(from: 0.0);

      setState(() {
        amountOverflowed = true;
      });
    });
    ShuttlePrchHstrHandler().registerEditingStateChangeCallback((_editing) {
      if (!mounted) return;

      setState(() {
        editing = _editing;
      });

      getRemainingShuttleAmount().then((value) {
        if (!mounted) return;

        setState(() {
          remainAmount = value;
          loading = false;
        });
      });

      if (!_editing) {
        _textController.text = '';
        _setInitial();
        _scrollController.animateTo(0.0,
            curve: Curves.ease, duration: Duration(microseconds: 100));
      }
      _animCntroller.fling(velocity: _editing ? 1.0 : -1.0);
    });
    ShuttlePrchHstrHandler().registerSubmitToAddNewCallback(() async {
      try {
        ShuttlePrchHstr newHstr = await validateNewPrch();
        _setInitial();
        _scrollController.animateTo(0.0,
            curve: Curves.ease, duration: Duration(microseconds: 100));
        _animCntroller.fling(velocity: -1.0);
        return newHstr;
      } catch (error) {
        throw (error);
      }
    });

    /*Data initializing*/
    getRemainingShuttleAmount().then((value) {
      if (!mounted) return;

      setState(() {
        remainAmount = value;
        loading = false;
      });
    });
  }

  Future<dynamic> getRemainingShuttleAmount() async {
    try {
      Logger().i('trying to get remaining counts..');
      Map<String, dynamic> response = await APIService.doGet(
          Constants.shuttlecockURL, 'getRemainingCount', new Map());

      int count = response['data'] as int;
      Logger().i('got count : $count');
      return count;
    } catch (error) {
      throw (error);
    }
  }

  Future<ShuttlePrchHstr> validateNewPrch() async {
    //form validation check
    if (selectedUsageString == '') throw ('invalid usage input');
    if (selectedAmount < 1) throw ('invalid amount input');

    Logger()
        .i('validation start.. Usage: $selectedUsage, Amount: $selectedAmount');

    //make instance
    ShuttlePrchHstr newHstr =
        new ShuttlePrchHstr(selectedUsageString, 0, selectedAmount);

    Map<String, dynamic> map = {
      'studentId': newHstr.studentId,
      'key': newHstr.key,
      'amount': newHstr.amount
    };

    try {
      Map<String, dynamic> response = await APIService.doGet(
          Constants.shuttlecockURL, 'validateNewPrch', map);

      Logger().i('validateNewPrch received response : $response');

      Map<String, dynamic> validationDataMap = response['data'];
      newHstr.shuttleList = validationDataMap['shuttleList'].cast<String>();
      newHstr.price = (validationDataMap['price'] as int);
      return newHstr;
    } catch (error) {
      throw (error);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _animCntroller.dispose();
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
          selected: selectedUsage == UsageLists.Personal_Use,
          onChange: (bool selected) {
            _handleUsageChange(
                selected, 'Personal Use', UsageLists.Personal_Use);
          },
        ),
        SizedBox(width: 10.0),
        UsageSelectButton(
          text: 'Regular Meeting',
          selected: selectedUsage == UsageLists.Regular_Meeting,
          onChange: (bool selected) {
            _handleUsageChange(
                selected, 'Regular Meeting', UsageLists.Regular_Meeting);
          },
        ),
        SizedBox(width: 10.0),
        UsageSelectButton(
          text: 'Training',
          selected: selectedUsage == UsageLists.Training,
          onChange: (bool selected) {
            _handleUsageChange(selected, 'Training', UsageLists.Training);
          },
        ),
        SizedBox(width: 10.0),
        UsageSelectButton(
          text: 'Offical Event',
          selected: selectedUsage == UsageLists.Official_Event,
          onChange: (bool selected) {
            _handleUsageChange(
                selected, 'Offical event', UsageLists.Official_Event);
          },
        ),
        SizedBox(width: 10.0),
        UsageSelectButton(
          text: 'Prize',
          selected: selectedUsage == UsageLists.Prize,
          onChange: (bool selected) {
            _handleUsageChange(selected, 'Prize', UsageLists.Prize);
          },
        )
      ],
    );
  }

  void _handleUsageChange(
      bool selected, String usage, UsageLists _selectedUsage) {
    setState(() {
      if (selected) {
        selectedUsageString = usage;
        selectedUsage = _selectedUsage;
      } else {
        selectedUsageString = '';
        selectedUsage = null;
      }
    });
  }

  Column _buildAmountSelection(Animation<double> animation) {
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
                        fontFamily: ClearAppTheme.fontName,
                        fontSize: 15,
                        color: amountOverflowed
                            ? ClearAppTheme.lightRed
                            : ClearAppTheme.grey)),
              ),
              Container(
                  padding: EdgeInsets.only(
                      top: 10,
                      left: animation.value + 20.0,
                      right: (20.0 - animation.value) < 0
                          ? 0
                          : 20.0 - animation.value),
                  child: loading
                      ? new CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              ClearAppTheme.grey),
                        )
                      : Text(remainAmount.toString(),
                          style: TextStyle(
                              fontFamily: ClearAppTheme.fontName,
                              fontSize: 30,
                              color: amountOverflowed
                                  ? ClearAppTheme.lightRed
                                  : ClearAppTheme.grey))),
            ],
          );
        },
      ),
      SizedBox(height: 20.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (selectedAmount - 1 >= 0)
                setState(() {
                  Logger().i('- button clicked, succeed');
                  amountOverflowed = false;
                  selectedAmount = selectedAmount - 1;
                });
              else {
                setState(() {
                  Logger().i('- button clicked, failed');
                  _remainingController.forward(from: 0.0);
                  amountOverflowed = true;
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
          SizedBox(width: 25.0),
          Container(
            child: Text(
              selectedAmount.toString(),
              style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
            ),
          ),
          SizedBox(width: 25.0),
          GestureDetector(
            onTap: () {
              if (selectedAmount + 1 <= remainAmount)
                setState(() {
                  Logger().i('+ button clicked, succeed');
                  amountOverflowed = false;
                  selectedAmount = selectedAmount + 1;
                });
              else {
                setState(() {
                  Logger().i('+ button clicked, failed');
                  _remainingController.forward(from: 0.0);
                  amountOverflowed = true;
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

    return PositionedTransition(
      rect: _rectAnimation,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => ShuttlePrchHstrHandler()
                  .eventHandle(EVENT.EditingStateChangeEvent, editing: false),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Form(
              key: _formKey,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 75.0),
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.all(25.0),
                  shrinkWrap: true,
                  children: <Widget>[
                    Text(
                      'Select Usage',
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
                    ),
                    SizedBox(height: 20.0),
                    _buildUsageSelectionRow(),
                    SizedBox(height: 25.0),
                    _buildAmountSelection(offsetAnimation)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
