import 'dart:convert';

import 'package:clearApp/shuttle_menu/data_manage/shuttle_purchace_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../login/login_info.dart';
import '../tab_model.dart';
import 'package:logger/logger.dart';
import 'events.dart';
import 'package:clearApp/util/api_service.dart';
import '../../util/constants.dart' as Constants;
import '../../util/toast_generator.dart';

class ShuttlePrchHstrSubject extends ChangeNotifier {
  ShuttleMenuCurrentTab _previousTab;
  BuildContext _context;
  bool isFeching;
  bool isEditing;
  List<ShuttlePrchHstr> shuttlePrchHstrList;
  List<ShuttlePrchHstr> _userSpecificShuttlePrchHstrList;
  List<ShuttlePrchHstr> _totalUserShuttlePrchHstrList;

  ShuttlePrchHstrSubject(BuildContext context) {
    _context = context;
    isFeching = false;
    isEditing = false;
    shuttlePrchHstrList = new List<ShuttlePrchHstr>();
    _userSpecificShuttlePrchHstrList = new List<ShuttlePrchHstr>();
    _totalUserShuttlePrchHstrList = new List<ShuttlePrchHstr>();

    eventHandle(EVENT.TabChangeEvent, tab: ShuttleMenuCurrentTab.Total);
  }

  void notifyListenersWith({bool isFeching = false, bool isEditing = false}) {
    this.isFeching = isFeching;
    this.isEditing = isEditing;
    notifyListeners();
  }

  Future<void> eventHandle(EVENT eventType,
      {ShuttleMenuCurrentTab tab,
      bool editing,
      String key,
      ShuttlePrchHstr newHstr,
      dynamic error}) async {
    try {
      switch (eventType) {
        case EVENT.TabChangeEvent:
          Logger().i("Tab change event occured");
          await updateTabChanged(tab);
          break;

        case EVENT.AddNewEvent:
          Logger().i("Add new event occured");
          await addNewPrchHstr(newHstr);
          break;

        case EVENT.UpdateRcvedEvent:
          Logger().i("Update rcved event occured");
          await updateRcved(key);
          break;

        case EVENT.UpdateApprEvent:
          Logger().i("Update approved event occured");
          await updateAppr(key);
          break;

        case EVENT.DeleteHstrEvent:
          Logger().i("Delelet hstr event occured");
          await deleteHstr(key);
          break;

        case EVENT.EditingStateChangeEvent:
          Logger().i('Editing change event occured');
          notifyListenersWith(isFeching: false, isEditing: true);
          break;
        default:
          Logger().e('ERROR: unknown event: $eventType');
          throw ('unknown event');
      }
    } catch (error) {
      Logger().e('error... $error');
      Toast_generator.errorToast(_context, 'failed with $error');
    }
    Toast_generator.successToast(_context, 'completed');
    Logger().i('Event handling finished');
  }

  Future<void> getMyHstr() async {
    notifyListenersWith(isFeching: true, isEditing: false);

    Map<String, dynamic> map = {'studentId': LoginInfo().studentId};
    Map<String, dynamic> response =
        await APIService.doGet(Constants.shuttlecockURL, 'getMyHstr', map);

    _userSpecificShuttlePrchHstrList = new List<ShuttlePrchHstr>();

    List<dynamic> jsonList = response['data'];
    jsonList.forEach((element) {
      Map<String, dynamic> _map = element;
      _userSpecificShuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(_map));
    });
    shuttlePrchHstrList = _userSpecificShuttlePrchHstrList;

    notifyListenersWith(isFeching: false, isEditing: false);
  }

  Future<void> getAllUnapprHstr() async {
    notifyListenersWith(isFeching: true, isEditing: false);

    Map<String, dynamic> map = new Map<String, dynamic>();
    Map<String, dynamic> response = await APIService.doGet(
        Constants.shuttlecockURL, 'getAllUnapprHstr', map);

    _totalUserShuttlePrchHstrList = new List<ShuttlePrchHstr>();
    List<dynamic> jsonList = response['data'];
    jsonList.forEach((element) {
      _totalUserShuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(element));
    });
    shuttlePrchHstrList = _totalUserShuttlePrchHstrList;

    notifyListenersWith(isFeching: false, isEditing: false);
  }

  Future<void> updateRcved(String key) async {
    _userSpecificShuttlePrchHstrList
        .firstWhere((element) => element.key == key)
        .received = true;
    shuttlePrchHstrList = _userSpecificShuttlePrchHstrList;
    notifyListenersWith(isFeching: false, isEditing: false);

    Map<String, dynamic> map = {
      "key": key,
    };

    await APIService.doPost(Constants.shuttlecockURL, 'updateRcved',
        params: map);
  }

  Future<void> updateAppr(String key) async {
    _totalUserShuttlePrchHstrList
        .firstWhere((element) => element.key == key)
        .approved = true;
    shuttlePrchHstrList = _totalUserShuttlePrchHstrList;
    notifyListenersWith(isFeching: false, isEditing: false);

    Map<String, dynamic> map = {
      "key": key,
    };

    await APIService.doPost(Constants.shuttlecockURL, 'updateAppr',
        params: map);
  }

  Future<void> deleteHstr(String key) async {
    _userSpecificShuttlePrchHstrList
        .removeWhere((element) => element.key == key);
    shuttlePrchHstrList = _userSpecificShuttlePrchHstrList;
    notifyListenersWith(isFeching: false, isEditing: false);

    Map<String, dynamic> map = {
      "key": key,
    };
    await APIService.doPost(Constants.shuttlecockURL, 'deleteHstr',
        params: map);
  }

  Future<void> addNewPrchHstr(ShuttlePrchHstr newHstr) async {
    notifyListenersWith(isFeching: true, isEditing: true);

    await APIService.doPost(Constants.shuttlecockURL, 'addNewPrchHstr',
        body: jsonEncode(newHstr.toMap()));

    _userSpecificShuttlePrchHstrList.add(newHstr);
    shuttlePrchHstrList = _userSpecificShuttlePrchHstrList;

    notifyListenersWith(isFeching: false, isEditing: false);
  }

  Future<void> updateTabChanged(ShuttleMenuCurrentTab tab) async {
    notifyListenersWith(isFeching: true, isEditing: false);
    switch (tab) {
      case ShuttleMenuCurrentTab.Total:
        Logger().i('Tab changed to Total');
        if (_previousTab == ShuttleMenuCurrentTab.Admin) {
          await getMyHstr();
        }
        shuttlePrchHstrList = _userSpecificShuttlePrchHstrList;
        break;

      case ShuttleMenuCurrentTab.Not_Rcved:
        Logger().i('Tab changed to Not rcved');
        if (_previousTab == ShuttleMenuCurrentTab.Admin) {
          await getMyHstr();
        }
        shuttlePrchHstrList = _userSpecificShuttlePrchHstrList
            .where((element) => element.received == false)
            .toList();
        break;
      case ShuttleMenuCurrentTab.Admin:
        Logger().i('Tab changed to Admin');
        await getAllUnapprHstr();
        shuttlePrchHstrList = _totalUserShuttlePrchHstrList;
    }
    _previousTab = tab;
    notifyListenersWith(isFeching: false, isEditing: false);
  }
}
