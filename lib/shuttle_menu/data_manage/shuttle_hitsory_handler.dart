import 'dart:convert';

import 'package:clearApp/shuttle_menu/data_manage/shuttle_purchace_history.dart';
import 'package:clearApp/util/popup_widgets/popup_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../login/login_info.dart';
import '../../util/constants.dart' as Constants;
import 'package:logger/logger.dart';
import 'events.dart';
import 'package:clearApp/util/api_service.dart';

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
  //DataUpdateEvent
  List<Function(List<ShuttlePrchHstr>)> dataUpdateCallback;
  Constants.ShuttleMenuCurrentTab previousTab;
  List<ShuttlePrchHstr> shuttlePrchHstrList;
  List<ShuttlePrchHstr> totalUserShuttlePrchHstrList;

  //StateChangeEvent
  List<Function(bool)> editingStateChangeCallback;

  //SubmitEvent
  Future<ShuttlePrchHstr> Function() submitToAddNewCallback;

  //ErrorEvent
  List<Function()> errorCallback;

  //etc
  BuildContext context;

  /* Singleton pattern */
  static final ShuttlePrchHstrHandler _shuttlePrchHstrHandler =
      ShuttlePrchHstrHandler._internal();

  factory ShuttlePrchHstrHandler() {
    return _shuttlePrchHstrHandler;
  }

  ShuttlePrchHstrHandler._internal();

  //Make sure call before make widget
  void initInstance(BuildContext _context) {
    previousTab = Constants.ShuttleMenuCurrentTab.Admin;
    dataUpdateCallback = new List<Function(List<ShuttlePrchHstr>)>();
    shuttlePrchHstrList = new List<ShuttlePrchHstr>();
    totalUserShuttlePrchHstrList = new List<ShuttlePrchHstr>();
    editingStateChangeCallback = new List<Function(bool)>();
    errorCallback = new List<Function()>();
    context = _context;
  }

  //Register
  void registerDataupdateCallback(Function(List<ShuttlePrchHstr>) callback) =>
      dataUpdateCallback.add(callback);

  void registerEditingStateChangeCallback(Function(bool) callback) =>
      editingStateChangeCallback.add(callback);

  void registerSubmitToAddNewCallback(
          Future<ShuttlePrchHstr> Function() callback) =>
      submitToAddNewCallback = callback;

  void registerErrorCallback(Function() callback) =>
      errorCallback.add(callback);

  void eventHandle(EVENT eventType,
      {Constants.ShuttleMenuCurrentTab tab,
      bool editing,
      String key,
      ShuttlePrchHstr newHstr,
      dynamic error}) {
    switch (eventType) {
      case EVENT.TabChangeEvent:
        Logger().i("Tab change event occured");
        updateTabChanged(tab).then((list) {
          previousTab = tab;
          dataUpdateCallback.forEach((callback) => callback(list));
        });
        break;

      case EVENT.UpdateRcvedEvent:
        Logger().i("Update rcved event occured");
        updateRcved(key).then(
            (list) => dataUpdateCallback.forEach((callback) => callback(list)));
        break;

      case EVENT.UpdateApprEvent:
        Logger().i("Update approved event occured");
        updateAppr(key).then(
            (list) => dataUpdateCallback.forEach((callback) => callback(list)));
        break;

      case EVENT.DeleteHstrEvent:
        Logger().i("Delelet hstr event occured");
        deleteHstr(key).then(
            (list) => dataUpdateCallback.forEach((callback) => callback(list)));
        break;

      case EVENT.EditingStateChangeEvent:
        Logger().i("Editing state change event occured");
        editingStateChangeCallback.forEach((callback) {
          callback(editing);
        });
        break;

      case EVENT.AddNewEvent:
        Logger().i("Add new event occured");
        addNewPrchHstr(newHstr).then(
            (list) => dataUpdateCallback.forEach((callback) => callback(list)));
        break;

      case EVENT.SubmitToAddNewEvent:
        Logger().i("Submit to add new event occured");
        submitEventHandle().then((hstr) {
          eventHandle(EVENT.EditingStateChangeEvent, editing: false);
          eventHandle(EVENT.AddNewEvent, newHstr: hstr);
        });
        break;

      case EVENT.ErrorEvent:
        Logger().e('Error event occured, $error');
        errorCallback.forEach((callback) {
          callback();
        });
        break;

      default:
        Logger().e('ERROR: unknown event: $eventType');
        throw ('unknown event');
    }
  }

  //acutal working functions
  Future<ShuttlePrchHstr> submitEventHandle() async {
    ShuttlePrchHstr newHstr;
    try {
      newHstr = await submitToAddNewCallback();
    } catch (error) {
      eventHandle(EVENT.ErrorEvent, error: error);
      PopupGenerator.errorPopupWidget(
          context,
          'ERROR!',
          'Please retry : $error',
          () => Navigator.pushNamed(context, '/homescreen/shuttlemenu')).show();
    }
    return newHstr;
  }

  Future<void> getMyHstr() async {
    Map<String, dynamic> map = {'studentId': LoginInfo().studentId};

    String response;
    try {
      response = await APIService.doGet(
          Constants.shuttlePrchHstrSheetURL, 'getMyHstr', map);
    } catch (error) {
      PopupGenerator.errorPopupWidget(
          context,
          'ERROR!',
          'Please check internet connection : $error',
          () => Navigator.pushNamed(context, '/homescreen')).show();
    }

    shuttlePrchHstrList = new List<ShuttlePrchHstr>();
    Map<String, dynamic> rcvedMap = jsonDecode(response);

    List<dynamic> jsonList = rcvedMap['data'];
    jsonList.forEach((element) {
      Map<String, dynamic> _map = element;
      shuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(_map));
    });
  }

  Future<void> getAllUnapprHstr() async {
    Map<String, dynamic> map = new Map<String, dynamic>();

    String response;
    try {
      response = await APIService.doGet(
          Constants.shuttlePrchHstrSheetURL, 'getAllUnapprHstr', map);
    } catch (error) {
      PopupGenerator.errorPopupWidget(
          context,
          'ERROR!',
          'Please check internet connection : $error',
          () => Navigator.pushNamed(context, '/homescreen')).show();
    }

    totalUserShuttlePrchHstrList = new List<ShuttlePrchHstr>();
    Map<String, dynamic> rcvedMap = jsonDecode(response);
    List<dynamic> jsonList = rcvedMap['data'];
    jsonList.forEach((element) {
      totalUserShuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(element));
    });
  }

  Future<List<ShuttlePrchHstr>> updateRcved(String _key) async {
    shuttlePrchHstrList.firstWhere((element) => element.key == _key).received =
        true;

    Map<String, dynamic> map = {
      "key": _key,
    };

    try {
      APIService.doPost(Constants.shuttlePrchHstrSheetURL, 'updateRcved',
          params: map);
    } catch (error) {
      PopupGenerator.errorPopupWidget(
          context,
          'ERROR!',
          'Please check internet connection : $error',
          () => Navigator.pushNamed(context, '/homescreen')).show();
    }

    return shuttlePrchHstrList;
  }

  Future<List<ShuttlePrchHstr>> updateAppr(String _key) async {
    totalUserShuttlePrchHstrList
        .firstWhere((element) => element.key == _key)
        .approved = true;

    Map<String, dynamic> map = {
      "key": _key,
    };

    try {
      APIService.doPost(Constants.shuttlePrchHstrSheetURL, 'updateAppr',
          params: map);
    } catch (error) {
      PopupGenerator.errorPopupWidget(
          context,
          'ERROR!',
          'Please check internet connection : $error',
          () => Navigator.pushNamed(context, '/homescreen')).show();
    }

    return totalUserShuttlePrchHstrList;
  }

  Future<List<ShuttlePrchHstr>> deleteHstr(String _key) async {
    shuttlePrchHstrList.firstWhere((element) => element.key == _key).deleted =
        true;

    shuttlePrchHstrList.removeWhere((element) => element.deleted == true);

    Map<String, dynamic> map = {
      "key": _key,
    };

    try {
      //TODO : doPost
      APIService.doGet(Constants.shuttleStorageSheetURL, 'deleteHstr', map);
      APIService.doPost(Constants.shuttlePrchHstrSheetURL, 'deleteHstr',
          params: map);
    } catch (error) {
      PopupGenerator.errorPopupWidget(
          context,
          'ERROR!',
          'Please check internet connection : $error',
          () => Navigator.pushNamed(context, '/homescreen')).show();
    }

    return shuttlePrchHstrList;
  }

  Future<List<ShuttlePrchHstr>> addNewPrchHstr(ShuttlePrchHstr newHstr) async {
    shuttlePrchHstrList.add(newHstr);

    try {
      APIService.doPost(Constants.shuttlePrchHstrSheetURL, 'addNewPrchHstr',
          body: jsonEncode(newHstr.toMap()));
    } catch (error) {
      PopupGenerator.errorPopupWidget(
          context,
          'ERROR!',
          'Please retry : $error',
          () => Navigator.pushNamed(context, '/homescreen')).show();
    }

    return shuttlePrchHstrList;
  }

  Future<List<ShuttlePrchHstr>> updateTabChanged(
      Constants.ShuttleMenuCurrentTab tab) async {
    try {
      switch (tab) {
        case Constants.ShuttleMenuCurrentTab.Total:
          Logger().i('Tab changed to Total');
          if (previousTab != Constants.ShuttleMenuCurrentTab.Admin) {
            return shuttlePrchHstrList;
          } else {
            await getMyHstr();
            return shuttlePrchHstrList;
          }
          break;

        case Constants.ShuttleMenuCurrentTab.Not_Rcved:
          Logger().i('Tab changed to Not rcved');
          if (previousTab != Constants.ShuttleMenuCurrentTab.Admin) {
            return shuttlePrchHstrList
                .where((element) => element.received == false)
                .toList();
          } else {
            await getMyHstr();
            return shuttlePrchHstrList
                .where((element) => element.received == false)
                .toList();
          }
          break;
        case Constants.ShuttleMenuCurrentTab.Admin:
          Logger().i('Tab changed to Admin');
          await getAllUnapprHstr();
          return totalUserShuttlePrchHstrList;
      }
    } catch (error) {
      PopupGenerator.errorPopupWidget(
          context,
          'ERROR!',
          'Please check internet connection : $error',
          () => Navigator.pushNamed(context, '/homescreen')).show();
    }
  }
}
