import 'dart:convert';

import 'package:clearApp/shuttle_menu/data_manage/shuttle_purchace_history.dart';
import 'package:clearApp/util/popup_widgets/popup_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  Constants.ShuttleMenuCurrentTab previousTab =
      Constants.ShuttleMenuCurrentTab.Admin;

  List<ShuttlePrchHstr> shuttlePrchHstrList = new List<ShuttlePrchHstr>();
  List<ShuttlePrchHstr> totalUserShuttlePrchHstrList =
      new List<ShuttlePrchHstr>();

  List<Function(bool)> editingChangedCallback = new List<Function(bool)>();
  Function(List<ShuttlePrchHstr>) dataUpdateCallback;
  Future<ShuttlePrchHstr> Function() submitEventCallback;
  List<Function()> errorCallback = new List<Function()>();

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
      errorCallback.forEach((element) {
        element();
      });
      Logger().e('error: $error');
    }
  }

  /*Data Handlings*/
  Future<String> doAction(
      String baseURL, String action, Map<String, dynamic> params,
      {bool popupWhenError = false, String errorTitle}) async {
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
      Logger().e('error: ${body['error'].toString()}');
      if (popupWhenError) {
        Fluttertoast.showToast(
            msg: errorTitle,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xFFF45C43).withOpacity(1),
            textColor: Colors.white,
            fontSize: 13.0);
      }
      throw ('error: ${body['error'].toString()}');
    } else {
      Logger().i('success');
    }
    return response.body;
  }

  Future<void> getMyHstr() async {
    Map<String, dynamic> map = {'studentId': LoginInfo().studentId};
    String response = await doAction(
        Constants.shuttlePrchHstrSheetURL, 'getMyHstr', map,
        popupWhenError: true, errorTitle: "Invalid amount");

    shuttlePrchHstrList = new List<ShuttlePrchHstr>();
    Map<String, dynamic> rcvedMap = jsonDecode(response);

    List<dynamic> jsonList = rcvedMap['data'];
    jsonList.forEach((element) {
      Map<String, dynamic> _map = element;
      shuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(_map));
    });

    Logger().i('finished');
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

    Logger().i(' finished');
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
            popupWhenError: true, errorTitle: "Invalid input")
        .then((value) => Logger().i('sheet updated finished handled'));
  }

  void updateRcved(String _key) {
    shuttlePrchHstrList.firstWhere((element) => element.key == _key).received =
        true;
    dataUpdateCallback(shuttlePrchHstrList);

    Map<String, dynamic> map = {
      "key": _key,
    };

    doAction(Constants.shuttlePrchHstrSheetURL, 'updateRcved', map)
        .then((value) => Logger().i('sheet updated finished handled'));
  }

  void updateAppr(String _key) {
    shuttlePrchHstrList.firstWhere((element) => element.key == _key).approved =
        true;

    dataUpdateCallback(shuttlePrchHstrList);

    Map<String, dynamic> map = {
      "key": _key,
    };

    doAction(Constants.shuttlePrchHstrSheetURL, 'updateAppr', map)
        .then((value) => Logger().i('sheet updated finished handled'));
  }

  void deleteHstr(String _key) {
    shuttlePrchHstrList.firstWhere((element) => element.key == _key).deleted =
        true;

    shuttlePrchHstrList.removeWhere((element) => element.deleted == true);

    Map<String, dynamic> map = {
      "key": _key,
    };

    doAction(Constants.shuttleStorageSheetURL, 'deleteHstr', map)
        .then((value) => Logger().i('sheet updated finished handled'));

    doAction(Constants.shuttlePrchHstrSheetURL, 'deleteHstr', map)
        .then((value) => Logger().i('sheet updated finished handled'));
  }

  //tab update
  void updateTabChanged(Constants.ShuttleMenuCurrentTab tab) {
    switch (tab) {
      case Constants.ShuttleMenuCurrentTab.Total:
        Logger().i('Tab changed to Total');
        if (previousTab != Constants.ShuttleMenuCurrentTab.Admin) {
          dataUpdateCallback(shuttlePrchHstrList);
        } else {
          getMyHstr().then((value) => dataUpdateCallback(shuttlePrchHstrList));
        }
        previousTab = Constants.ShuttleMenuCurrentTab.Total;
        break;

      case Constants.ShuttleMenuCurrentTab.Not_Rcved:
        Logger().i('Tab changed to Not rcved');
        if (previousTab != Constants.ShuttleMenuCurrentTab.Admin) {
          dataUpdateCallback(shuttlePrchHstrList
              .where((element) => element.received == false)
              .toList());
        } else {
          getMyHstr().then((value) => dataUpdateCallback(shuttlePrchHstrList
              .where((element) => element.received == false)
              .toList()));
        }
        previousTab = Constants.ShuttleMenuCurrentTab.Not_Rcved;
        break;
      case Constants.ShuttleMenuCurrentTab.Admin:
        Logger().i('Tab changed to Admin');
        getAllUnapprHstr()
            .then((value) => dataUpdateCallback(totalUserShuttlePrchHstrList));
        previousTab = Constants.ShuttleMenuCurrentTab.Admin;
    }
  }
}
