import 'dart:convert';

import 'package:clearApp/shuttle_menu/data_manage/shuttle_purchace_history.dart';
import 'package:clearApp/util/popup_widgets/popup_generator.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/cupertino.dart';
import '../../login/login_info.dart';
import '../../util/constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/* HTTP Format */
/* ONLY GET METHOD */
/* ?action=(value)&key=(value)&studentId=(value)&amount=(value)&body=(value) */

/* Action List */
/* <<Shuttle Purchase History Sheet Events>>*/
/* getMyHstr*/
/* getAllUnapprHstr */
/* updateRcved */
/* updateAppr */
/* addNewPrchHstr */
/* <<Shuttle Storage Events>> */
/* validateNewPrch */

class ShuttlePrchHstrHandler {
  List<ShuttlePrchHstr> shuttlePrchHstrList = new List<ShuttlePrchHstr>();
  List<ShuttlePrchHstr> totalUserShuttlePrchHstrList =
      new List<ShuttlePrchHstr>();

  List<Function(bool)> editingChangedCallback = new List<Function(bool)>();
  Function(List<ShuttlePrchHstr>) dataUpdateCallback;
  Future<ShuttlePrchHstr> Function() submitEventCallback;

  /* Singleton pattern */
  static final ShuttlePrchHstrHandler _shuttlePrchHstrHandler =
      ShuttlePrchHstrHandler._internal();

  factory ShuttlePrchHstrHandler() {
    return _shuttlePrchHstrHandler;
  }

  ShuttlePrchHstrHandler._internal();
  ///////////////////////

  /*Handling Settings*/
  void changeEditingState(bool editing) {
    editingChangedCallback.forEach((element) {
      element(editing);
    });
  }

  void submitEventHandle() async {
    ShuttlePrchHstr newHstr;
    try {
      newHstr = await submitEventCallback();
      addNewPrchHstr(newHstr);
      changeEditingState(false);
    } catch (error) {
      Logger().e(
          'class: ShuttlePrchHstrHandler, method: submitEvnetHandle, error: $error');
    }
  }

  /*Data Handlings*/
  Future<String> doAction(
      String baseURL, String action, Map<String, dynamic> params,
      {bool popupWhenError = false, Function errorHander}) async {
    String url = baseURL + '?action=$action';
    params.forEach((key, value) {
      url += '&$key=$value';
    });

    var response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    var statusCode = response.statusCode;
    Map<String, dynamic> body = jsonDecode(response.body);

    if (statusCode != 200 || body.containsKey('error')) {
      Logger().e(
          'class: ShuttlePrchHstrHandler, method: doAction, error: ${body['error'].toString()}');
      if (popupWhenError) {
        PopupGenerator.ErrorPopupWidget(
            Constants.homeContext,
            "Loading Error",
            "Please check your internet connection.",
            () => Navigator.pop(Constants.homeContext)).show();
      }
      throw ('error: ${body['error'].toString()}');
    } else {
      Logger()
          .i('class: ShuttlePrchHstrHandler, method: doAction, text: success');
    }
    return response.body;
  }

  Future<void> getMyHstr() async {
    Map<String, dynamic> map = {'studentId': LoginInfo().studentId};
    String response = await doAction(
        Constants.shuttlePrchHstrSheetURL, 'getMyHstr', map,
        popupWhenError: true,
        errorHander: () => Navigator.pop(Constants.homeContext));

    shuttlePrchHstrList = new List<ShuttlePrchHstr>();
    Map<String, dynamic> rcvedMap = jsonDecode(response);

    List<dynamic> jsonList = rcvedMap['data'];
    jsonList.forEach((element) {
      Map<String, dynamic> _map = element;
      shuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(_map));
    });

    Logger()
        .i('class: ShuttlePrchHstrHandler, method: getMyHstr, text: finished');
  }

  Future<void> getAllUnapprHstr() async {
    Map<String, dynamic> map = new Map<String, dynamic>();
    String response = await doAction(
        Constants.shuttlePrchHstrSheetURL, 'getAllUnapprHstr', map);

    totalUserShuttlePrchHstrList = new List<ShuttlePrchHstr>();
    Map<String, dynamic> rcvedMap = jsonDecode(response);
    List<dynamic> jsonList = rcvedMap['data'];
    jsonList.forEach((element) {
      totalUserShuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(element));
    });

    Logger().i(
        'class: ShuttlePrchHstrHandler, method: getAllUnapprHstr, text: finished');
  }

  Future<void> addNewPrchHstr(ShuttlePrchHstr newHstr) async {
    //Debug
    shuttlePrchHstrList.add(newHstr);
    dataUpdateCallback(shuttlePrchHstrList);
    changeEditingState(false);

    //string -> json -> utf8 byte -> base64
    Map<String, dynamic> map = {
      "studentId": newHstr.studentId,
      "body": base64Encode(utf8.encode(jsonEncode(newHstr.toMap()))),
    };

    doAction(Constants.shuttlePrchHstrSheetURL, 'addNewPrchHstr', map,
        popupWhenError: true,
        errorHander: () =>
            Navigator.pop(Constants.homeContext)).then((value) => Logger().i(
        'class: ShuttlePrchHstrHandler, method: addNewPrchHistory, text: sheet updated finished handled'));
  }

  void updateRcved(String _key) {
    shuttlePrchHstrList.firstWhere((element) => element.key == _key).received =
        true;
    dataUpdateCallback(shuttlePrchHstrList);

    Map<String, dynamic> map = {
      "key": _key,
    };

    doAction(Constants.shuttlePrchHstrSheetURL, 'updateRcved', map).then(
        (value) => Logger().i(
            'class: ShuttlePrchHstrHandler, method: updateRcved, text: sheet updated finished handled'));
  }

  void updateAppr(String _key) {
    shuttlePrchHstrList.firstWhere((element) => element.key == _key).approved =
        true;
    dataUpdateCallback(shuttlePrchHstrList);

    Map<String, dynamic> map = {
      "key": _key,
    };

    doAction(Constants.shuttlePrchHstrSheetURL, 'updateAppr', map).then(
        (value) => Logger().i(
            'class: ShuttlePrchHstrHandler, method: updateAppr, text: sheet updated finished handled'));
  }

  //tab update
  void updateTabChanged(Constants.ShuttleMenuCurrentTab tab) {
    switch (tab) {
      case Constants.ShuttleMenuCurrentTab.Total:
        Logger().i(
            'class: ShuttlePrchHstrHandler, method: updateTabChanged, text: changed to Total');
        getMyHstr().then((value) => dataUpdateCallback(shuttlePrchHstrList));
        break;

      case Constants.ShuttleMenuCurrentTab.Not_Rcved:
        Logger().i(
            'class: ShuttlePrchHstrHandler, method: updateTabChanged, text: changed to Not rcved');
        getMyHstr().then((value) => dataUpdateCallback(shuttlePrchHstrList
            .where((element) => element.received == false)
            .toList()));
        break;

      case Constants.ShuttleMenuCurrentTab.Admin:
        Logger().i(
            'class: ShuttlePrchHstrHandler, method: updateTabChanged, text: changed to Admin');
        getAllUnapprHstr()
            .then((value) => dataUpdateCallback(totalUserShuttlePrchHstrList));
    }
  }
}
