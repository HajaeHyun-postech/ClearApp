import 'dart:async';
import 'dart:convert';

import 'package:clearApp/shuttle_menu/data_manage/shuttle_hitsory_handler.dart';
import 'package:clearApp/shuttle_menu/data_manage/shuttle_purchace_history.dart';
import 'package:clearApp/shuttle_menu/usage_select_button.dart';
import 'package:clearApp/util/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../util/constants.dart' as Constants;

enum UsageLists { Regular_Meeting, Personal_Use, Event }

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
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _textController;
  AnimationController _animCntroller;
  ScrollController _scrollController;
  Animation<RelativeRect> _rectAnimation;
  bool editing;
  UsageLists selectedUsage;
  Map<String, dynamic> formData = {
    'text': null,
    'usage': null,
    'amount': null,
  };

  void _setInitial() {
    formData['text'] = '';
    formData['usage'] = '';
    formData['amount'] = 0;
  }

  @override
  void initState() {
    super.initState();
    _setInitial();
    _scrollController = ScrollController();
    _textController = TextEditingController();
    _animCntroller = AnimationController(
        duration: Duration(milliseconds: 300), value: 0.0, vsync: this);

    final Size size = widget.size;
    _rectAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, size.height, 0.0, -size.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_animCntroller);

    ShuttlePrchHstrHandler().editingChangedCallback.add((_editing) {
      if (!mounted) return;

      setState(() {
        editing = _editing;
      });

      if (!_editing) {
        _textController.text = '';
        _setInitial();
        _scrollController.animateTo(0.0,
            curve: Curves.ease, duration: Duration(microseconds: 100));
      }
      _animCntroller.fling(velocity: _editing ? 1.0 : -1.0);
    });

    ShuttlePrchHstrHandler().submitEventCallback = () async {
      try {
        ShuttlePrchHstr newHstr = await validateNewPrch();
        _setInitial();
        _scrollController.animateTo(0.0,
            curve: Curves.ease, duration: Duration(microseconds: 100));
        _animCntroller.fling(velocity: -1.0);
      } catch (error) {
        throw (error);
      }
    };
  }

  Future<ShuttlePrchHstr> validateNewPrch() async {
    //TODO : add some callbacks. Like focus, send error... etc
    //form validation check
    if (formData['usage'].isEmpty) throw ('invalid input');
    if (formData['amount'] < 1) throw ('invalid input');

    //make instance
    ShuttlePrchHstr newHstr =
        new ShuttlePrchHstr(formData['usage'], 0, formData['amount']);

    Map<String, dynamic> map = {
      'studentId': newHstr.studentId,
      'key': newHstr.key,
      'amount': newHstr.amount
    };

    try {
      String response = await ShuttlePrchHstrHandler()
          .doAction(Constants.shuttleStorageSheetURL, 'validateNewPrch', map);

      Map<String, dynamic> rcvedMap = (jsonDecode(response))['data'];
      newHstr.shuttleList = rcvedMap['shuttleList'].cast<String>();
      newHstr.price = (rcvedMap['price'] as int);
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

  Widget _buildTodoTextInput() {
    return TextFormField(
      controller: _textController,
      decoration: InputDecoration(
        hintText: 'NEEDED FILED??? (THINKGING..)',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      onSaved: (String text) {
        formData['text'] = text;
      },
    );
  }

  Row _buildUsageSelectionRow() {
    return Row(
      children: <Widget>[
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
          text: 'Personal Use',
          selected: selectedUsage == UsageLists.Personal_Use,
          onChange: (bool selected) {
            _handleUsageChange(
                selected, 'Personal Use', UsageLists.Personal_Use);
          },
        ),
        SizedBox(width: 10.0),
        UsageSelectButton(
          text: 'For Event',
          selected: selectedUsage == UsageLists.Event,
          onChange: (bool selected) {
            _handleUsageChange(selected, 'Event', UsageLists.Event);
          },
        ),
      ],
    );
  }

  void _handleUsageChange(
      bool selected, String usage, UsageLists _selectedUsage) {
    setState(() {
      if (selected) {
        formData['usage'] = usage;
        selectedUsage = _selectedUsage;
      } else {
        formData['usage'] = null;
        selectedUsage = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: _rectAnimation,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => ShuttlePrchHstrHandler().changeEditingState(false),
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
                      'DEBUG TEXT FIELD',
                      style:
                          ClearAppTheme.buildLightTheme().textTheme.bodyText1,
                    ),
                    _buildTodoTextInput(),
                    SizedBox(height: 25.0),
                    _buildUsageSelectionRow(),
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
