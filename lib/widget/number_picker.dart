import 'dart:async';

import 'package:clearApp/widget/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberPicker extends StatefulWidget {
  final ShapeBorder shape;
  final TextStyle valueTextStyle;
  final Function(dynamic) onValue;
  final dynamic maxValue;
  final dynamic minValue;
  final dynamic initialValue;
  final dynamic step;
  final bool enablePicker;

  NumberPicker(
      {Key key,
      this.shape,
      this.valueTextStyle,
      @required this.onValue,
      @required this.initialValue,
      @required this.maxValue,
      @required this.minValue,
      this.step = 1,
      this.enablePicker = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NumberPickerState();
  }
}

class NumberPickerState extends State<NumberPicker> {
  dynamic _initialValue;
  dynamic _maxValue;
  dynamic _minValue;
  dynamic _step;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _initialValue = widget.initialValue;
    _maxValue = widget.maxValue;
    _minValue = widget.minValue;
    _step = widget.step;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      elevation: 0.0,
      semanticContainer: true,
      color: Colors.transparent,
      shape: widget.shape ??
          RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0.0)),
              side: BorderSide(width: 1.0, color: Color(0xffF0F0F0))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: minus,
            onTapDown: (details) {
              onLongPress(DoAction.MINUS);
            },
            onTapUp: (details) {
              _timer.cancel();
            },
            onTapCancel: () {
              _timer.cancel();
            },
            child: Padding(
                padding: EdgeInsets.only(left: 6, right: 6, bottom: 6, top: 6),
                child: Icon(Icons.remove, size: 11)),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(30),
          ),
          Container(
              child: InkWell(
            onTap: widget.enablePicker
                ? () => showPickerNumber(context)
                : () => {},
            child: AutoSizeText(
              "$_initialValue",
              style: widget.valueTextStyle ?? TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          )),
          SizedBox(
            width: ScreenUtil().setWidth(30),
          ),
          GestureDetector(
            onTap: add,
            onTapDown: (details) {
              onLongPress(DoAction.ADD);
            },
            onTapUp: (details) {
              _timer.cancel();
            },
            onTapCancel: () {
              _timer.cancel();
            },
            child: Padding(
                padding: EdgeInsets.only(left: 6, right: 6, bottom: 6, top: 6),
                child: Icon(Icons.add, size: 11)),
          ),
        ],
      ),
    );
  }

  Size _textSize(TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: _maxValue.toString(), style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(
          minWidth: 0, maxWidth: _maxValue.toString().length * style.fontSize);
    return textPainter.size;
  }

  void minus() {
    if (canDoAction(DoAction.MINUS)) {
      setState(() {
        _initialValue -= _step;
      });
    }
    if (widget.onValue != null) {
      widget.onValue(_initialValue);
    }
  }

  void add() {
    if (canDoAction(DoAction.ADD)) {
      setState(() {
        _initialValue += _step;
      });
    }
    if (widget.onValue != null) {
      widget.onValue(_initialValue);
    }
  }

  void onLongPress(DoAction action) {
    var timer = Timer.periodic(Duration(milliseconds: 150), (t) {
      action == DoAction.MINUS ? minus() : add();
    });
    setState(() {
      _timer = timer;
    });
  }

  bool canDoAction(DoAction action) {
    if (action == DoAction.MINUS) {
      return _initialValue - _step >= _minValue;
    }
    if (action == DoAction.ADD) {
      return _initialValue + _step <= _maxValue;
    }
  }

  showPickerNumber(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
              begin: _minValue,
              end: _maxValue,
              jump: _step,
              initValue: _initialValue),
        ]),
        hideHeader: true,
        cancelTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: ScreenUtil().setSp(60),
            color: ClearAppTheme.grey),
        confirmTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: ScreenUtil().setSp(60),
            color: ClearAppTheme.grey),
        textStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: ScreenUtil().setSp(60),
            color: ClearAppTheme.black),
        selectedTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: ScreenUtil().setSp(70),
            color: ClearAppTheme.black),
        onConfirm: (Picker picker, List value) {
          setState(() {
            _initialValue = picker.getSelectedValues()[0];
          });
          widget.onValue(_initialValue);
        }).showDialog(context);
  }
}

enum DoAction { MINUS, ADD }
