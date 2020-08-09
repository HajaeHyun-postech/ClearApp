import 'dart:convert';
import 'dart:io';

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
  bool _isFeching;
  List<ShuttlePrchHstr> _shuttlePrchHstrList;
  List<ShuttlePrchHstr> _userSpecificShuttlePrchHstrList;
  List<ShuttlePrchHstr> _totalUserShuttlePrchHstrList;

  bool get isFeching => _isFeching;
  List<ShuttlePrchHstr> get shuttlePrchHstrList => _shuttlePrchHstrList;

  ShuttlePrchHstrSubject(BuildContext context) {
    _context = context;
    _isFeching = false;
    _shuttlePrchHstrList = new List<ShuttlePrchHstr>();
    _userSpecificShuttlePrchHstrList = new List<ShuttlePrchHstr>();
    _totalUserShuttlePrchHstrList = new List<ShuttlePrchHstr>();
    _previousTab = ShuttleMenuCurrentTab.Admin;

    eventHandle(EVENT.TabChangeEvent, tab: ShuttleMenuCurrentTab.Total);
  }

  void notifyListenersWith({bool isFeching = false}) {
    _isFeching = isFeching;
    notifyListeners();
  }

  Future<void> eventHandle(EVENT eventType,
      {ShuttleMenuCurrentTab tab, String key, ShuttlePrchHstr newHstr}) async {
    try {
      switch (eventType) {
        case EVENT.TabChangeEvent:
          Logger().i("Tab change event occured");
          await updateTabChanged(tab);
          Toast_generator.successToast(_context, 'Loading complete');
          break;

        case EVENT.AddNewEvent:
          Logger().i("Add new event occured");
          await addNewPrchHstr(newHstr);
          Toast_generator.successToast(_context, 'Added');
          break;

        case EVENT.UpdateRcvedEvent:
          Logger().i("Update rcved event occured");
          await updateRcved(key);
          Toast_generator.successToast(_context, 'Received');
          break;

        case EVENT.UpdateApprEvent:
          Logger().i("Update approved event occured");
          await updateAppr(key);
          Toast_generator.successToast(_context, 'Approved');
          break;

        case EVENT.DeleteHstrEvent:
          Logger().i("Delelet hstr event occured");
          await deleteHstr(key);
          Toast_generator.successToast(_context, 'Deleted');
          break;

        default:
          Logger().e('ERROR: unknown event: $eventType');
          throw ('unknown event');
      }
    } catch (error) {
      Logger().e('error... $error');
      Toast_generator.errorToast(_context, '$error');
    } finally {
      Logger().i('Event handling finished');
    }
  }

  Future<void> getMyHstr() async {
    notifyListenersWith(isFeching: true);
    Map<String, dynamic> map = {'studentId': LoginInfo().studentId};
    Map<String, dynamic> response =
        await APIService.doGet(Constants.shuttlecockURL, 'getMyHstr', map);

    _userSpecificShuttlePrchHstrList = new List<ShuttlePrchHstr>();

    List<dynamic> jsonList = response['data'];
    jsonList.forEach((element) {
      Map<String, dynamic> _map = element;
      _userSpecificShuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(_map));
    });
    _shuttlePrchHstrList = _userSpecificShuttlePrchHstrList;
    notifyListenersWith(isFeching: false);
  }

  Future<void> getAllUnapprHstr() async {
    notifyListenersWith(isFeching: true);
    Map<String, dynamic> map = new Map<String, dynamic>();
    Map<String, dynamic> response = await APIService.doGet(
        Constants.shuttlecockURL, 'getAllUnapprHstr', map);

    _totalUserShuttlePrchHstrList = new List<ShuttlePrchHstr>();
    List<dynamic> jsonList = response['data'];
    jsonList.forEach((element) {
      _totalUserShuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(element));
    });
    _shuttlePrchHstrList = _totalUserShuttlePrchHstrList;
    notifyListenersWith(isFeching: false);
  }

  Future<void> updateRcved(String key) async {
    Map<String, dynamic> map = {
      "key": key,
    };

    await APIService.doPost(Constants.shuttlecockURL, 'updateRcved',
        params: map);

    _userSpecificShuttlePrchHstrList
        .firstWhere((element) => element.key == key)
        .received = true;
    _shuttlePrchHstrList = _userSpecificShuttlePrchHstrList;
    notifyListenersWith(isFeching: false);
  }

  Future<void> updateAppr(String key) async {
    Map<String, dynamic> map = {
      "key": key,
    };

    await APIService.doPost(Constants.shuttlecockURL, 'updateAppr',
        params: map);

    _totalUserShuttlePrchHstrList
        .firstWhere((element) => element.key == key)
        .approved = true;
    _shuttlePrchHstrList = _totalUserShuttlePrchHstrList;
    notifyListenersWith(isFeching: false);
  }

  Future<void> deleteHstr(String key) async {
    Map<String, dynamic> map = {
      "key": key,
    };
    await APIService.doPost(Constants.shuttlecockURL, 'deleteHstr',
        params: map);

    _userSpecificShuttlePrchHstrList
        .removeWhere((element) => element.key == key);
    _shuttlePrchHstrList = _userSpecificShuttlePrchHstrList;
    notifyListenersWith(isFeching: false);
  }

  Future<void> addNewPrchHstr(ShuttlePrchHstr newHstr) async {
    notifyListenersWith(isFeching: true);

    Map<String, dynamic> response = await APIService.doPost(
            Constants.shuttlecockURL, 'addNewPrchHstr',
            body: jsonEncode(newHstr.toMap()))
        .catchError((e) {
      notifyListenersWith(isFeching: false);
      throw ('Not enough shuttlecocks');
    }, test: (e) => e is HttpException);

    Map<String, dynamic> transactionDataMap = response['data'];
    newHstr.shuttleList = transactionDataMap['shuttleList'].cast<String>();
    newHstr.price = (transactionDataMap['price'] as int);

    _userSpecificShuttlePrchHstrList.add(newHstr);
    _shuttlePrchHstrList = _userSpecificShuttlePrchHstrList;

    notifyListenersWith(isFeching: false);
  }

  Future<void> updateTabChanged(ShuttleMenuCurrentTab tab) async {
    notifyListenersWith(isFeching: true);
    switch (tab) {
      case ShuttleMenuCurrentTab.Total:
        Logger().i('Tab changed to Total');
        if (_previousTab == ShuttleMenuCurrentTab.Admin) {
          await getMyHstr();
        }
        _shuttlePrchHstrList = _userSpecificShuttlePrchHstrList;
        break;

      case ShuttleMenuCurrentTab.Not_Rcved:
        Logger().i('Tab changed to Not rcved');
        if (_previousTab == ShuttleMenuCurrentTab.Admin) {
          await getMyHstr();
        }
        _shuttlePrchHstrList = _userSpecificShuttlePrchHstrList
            .where((element) => element.received == false)
            .toList();
        break;
      case ShuttleMenuCurrentTab.Admin:
        Logger().i('Tab changed to Admin');
        await getAllUnapprHstr();
        _shuttlePrchHstrList = _totalUserShuttlePrchHstrList;
    }
    _previousTab = tab;
    notifyListenersWith(isFeching: false);
  }
}
