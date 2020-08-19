import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../util/http_client.dart';
import '../../../contants/constants.dart' as Constants;
import '../../../widget_generator/toast_generator.dart';
import '../../login/login_info.dart';
import '../tab_model.dart';
import 'events.dart';
import 'shuttle_purchace_history.dart';

class ShuttlePrchHstrSubject extends ChangeNotifier {
  ShuttleMenuCurrentTab _previousTab;
  BuildContext _context;
  bool _isFetching;
  List<ShuttlePrchHstr> _shuttlePrchHstrList;
  List<ShuttlePrchHstr> _userSpecificShuttlePrchHstrList;
  List<ShuttlePrchHstr> _totalUserShuttlePrchHstrList;

  bool get isFetching => _isFetching;
  List<ShuttlePrchHstr> get shuttlePrchHstrList => _shuttlePrchHstrList;

  ShuttlePrchHstrSubject(BuildContext context) {
    _context = context;
    _isFetching = false;
    _shuttlePrchHstrList = new List<ShuttlePrchHstr>();
    _userSpecificShuttlePrchHstrList = new List<ShuttlePrchHstr>();
    _totalUserShuttlePrchHstrList = new List<ShuttlePrchHstr>();
    _previousTab = ShuttleMenuCurrentTab.Admin;

    eventHandle(EVENT.TabChangeEvent, tab: ShuttleMenuCurrentTab.Total);
  }

  void notifyListenersWith({bool isFetching = false}) {
    _isFetching = isFetching;
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
    notifyListenersWith(isFetching: true);
    Map<String, dynamic> map = {'studentId': LoginInfo().studentId};
    Map<String, dynamic> response =
        await HttpClient.doGet(Constants.shuttlecockURL, 'getMyHstr', map);

    _userSpecificShuttlePrchHstrList = new List<ShuttlePrchHstr>();

    List<dynamic> jsonList = response['data'];
    jsonList.forEach((element) {
      Map<String, dynamic> _map = element;
      _userSpecificShuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(_map));
    });
    _shuttlePrchHstrList = _userSpecificShuttlePrchHstrList;
    notifyListenersWith(isFetching: false);
  }

  Future<void> getAllUnapprHstr() async {
    notifyListenersWith(isFetching: true);
    Map<String, dynamic> map = new Map<String, dynamic>();
    Map<String, dynamic> response = await HttpClient.doGet(
        Constants.shuttlecockURL, 'getAllUnapprHstr', map);

    _totalUserShuttlePrchHstrList = new List<ShuttlePrchHstr>();
    List<dynamic> jsonList = response['data'];
    jsonList.forEach((element) {
      _totalUserShuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(element));
    });
    _shuttlePrchHstrList = _totalUserShuttlePrchHstrList;
    notifyListenersWith(isFetching: false);
  }

  Future<void> updateRcved(String key) async {
    Map<String, dynamic> map = {
      "key": key,
    };

    await HttpClient.doPost(Constants.shuttlecockURL, 'updateRcved',
        params: map);

    _userSpecificShuttlePrchHstrList
        .firstWhere((element) => element.key == key)
        .received = true;
    _shuttlePrchHstrList = _userSpecificShuttlePrchHstrList;
    notifyListenersWith(isFetching: false);
  }

  Future<void> updateAppr(String key) async {
    Map<String, dynamic> map = {
      "key": key,
    };

    await HttpClient.doPost(Constants.shuttlecockURL, 'updateAppr',
        params: map);

    _totalUserShuttlePrchHstrList
        .firstWhere((element) => element.key == key)
        .approved = true;
    _shuttlePrchHstrList = _totalUserShuttlePrchHstrList;
    notifyListenersWith(isFetching: false);
  }

  Future<void> deleteHstr(String key) async {
    Map<String, dynamic> map = {
      "key": key,
    };
    await HttpClient.doPost(Constants.shuttlecockURL, 'deleteHstr',
        params: map);

    _userSpecificShuttlePrchHstrList
        .removeWhere((element) => element.key == key);
    _shuttlePrchHstrList = _userSpecificShuttlePrchHstrList;
    notifyListenersWith(isFetching: false);
  }

  Future<void> addNewPrchHstr(ShuttlePrchHstr newHstr) async {
    notifyListenersWith(isFetching: true);

    Map<String, dynamic> response = await HttpClient.doPost(
            Constants.shuttlecockURL, 'addNewPrchHstr',
            body: jsonEncode(newHstr.toMap()))
        .catchError((e) {
      notifyListenersWith(isFetching: false);
      throw ('Not enough shuttlecocks');
    }, test: (e) => e is HttpException);

    Map<String, dynamic> transactionDataMap = response['data'];
    newHstr.shuttleList = transactionDataMap['shuttleList'].cast<String>();
    newHstr.price = (transactionDataMap['price'] as int);

    _userSpecificShuttlePrchHstrList.add(newHstr);
    _shuttlePrchHstrList = _userSpecificShuttlePrchHstrList;

    notifyListenersWith(isFetching: false);
  }

  Future<void> updateTabChanged(ShuttleMenuCurrentTab tab) async {
    notifyListenersWith(isFetching: true);
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
    notifyListenersWith(isFetching: false);
  }
}
