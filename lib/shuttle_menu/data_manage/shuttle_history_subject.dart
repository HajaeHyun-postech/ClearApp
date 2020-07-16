import 'dart:convert';

import 'package:clearApp/shuttle_menu/data_manage/shuttle_purchace_history.dart';
import 'package:gsheets/gsheets.dart';
import '../../login/login_info.dart';
import '../../login/login_info.dart';
import '../../util/constants.dart' as Constants;

const _spreadsheetId = '1AbK660l9RUdCTJbg-KHZyhwnIM9sOs0gi6B8Ujt2jEU';

//validate (갯수)

class ShuttlePrchHstrSubject {
  List<ShuttlePrchHstr> shuttlePrchHstrList;
  List<ShuttlePrchHstr> totalUserShuttlePrchHstrList;
  Function(List<ShuttlePrchHstr>) notifyHandler;
  Worksheet prchHstrSheet;
  Worksheet shuttlecockMngSheet;

  /**singleton pattern**/
  static ShuttlePrchHstrSubject instance;

  static ShuttlePrchHstrSubject getInstance(
      Function(List<ShuttlePrchHstr> shuttlePrchHstrList) _handler) {
    if (instance == null) {
      instance = ShuttlePrchHstrSubject.initial(_handler);
    }
    instance.notifyHandler = _handler;
    instance.updateTabChanged(Constants.ShuttleMenuCurrentTab.Total);
    return instance;
  }

  ShuttlePrchHstrSubject.initial(
      Function(List<ShuttlePrchHstr> shuttlePrchHstrList) _handler) {
    initialDataPull();
  }

  Future<void> initialDataPull() async {
    final gsheets = GSheets(Constants.CREDENTIAL);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    prchHstrSheet = ss.worksheetByTitle('shuttlecock_purchace_history');
    shuttlecockMngSheet = ss.worksheetByTitle('shuttlecock_manage');

    shuttlePrchHstrList = new List<ShuttlePrchHstr>();

    (await prchHstrSheet.values.map.allRows(fromRow: 2))
        .where((element) => element['studentId'] == LoginInfo().studentId)
        .toList()
        .forEach((element) {
      Map<String, dynamic> mapData = new Map<String, dynamic>();
      element.forEach((key, value) {
        mapData[key] = jsonDecode(value);
      });
      shuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(mapData));
    });
  }

  /**Data pull methods**/
  Future<void> reloadApproved() async {
    shuttlePrchHstrList.forEach((element) {
      prchHstrSheet.values
          .valueByKeys(rowKey: element.key, columnKey: 'approved')
          .then((value) => element.approved = (value == 'true'));
    });
  }

  Future<void> loadUnapprovedHistories() async {
    (await prchHstrSheet.values.map.allRows(fromRow: 2))
        .where((element) => element['approved'] == 'false')
        .toList()
        .forEach((element) =>
            totalUserShuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(element)));
  }

  void addNewPrchHistory(Map<String, dynamic> mapData) async {
    shuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(mapData));
    int lastRow;
    do {
      lastRow = prchHstrSheet.rowCount + 1;
      await prchHstrSheet.values.map.insertRow(lastRow, mapData);
    } while (
        (await prchHstrSheet.values.map.row(lastRow))['key'] != mapData['key']);
  }

  void updateReceived(String _key) {
    prchHstrSheet.values
        .insertValueByKeys('true', rowKey: _key, columnKey: 'received');
    shuttlePrchHstrList.firstWhere((element) => element.key == _key).received =
        false;
  }

  void updateApproved(String _key) {
    prchHstrSheet.values
        .insertValueByKeys('true', rowKey: _key, columnKey: 'approved');
    shuttlePrchHstrList.firstWhere((element) => element.key == _key).approved =
        false;
  }

  //tab update
  void updateTabChanged(Constants.ShuttleMenuCurrentTab tab) {
    print("Debug: update tab changed");
    switch (tab) {
      case Constants.ShuttleMenuCurrentTab.Total:
        print("Debug: Total Tab in");
        reloadApproved();
        notifyHandler(shuttlePrchHstrList);
        break;

      case Constants.ShuttleMenuCurrentTab.Not_Rcved:
        print('Debug: Not Rcved Tab in');
        reloadApproved();
        notifyHandler(shuttlePrchHstrList
            .where((element) => element.received == false)
            .toList());
        break;

      case Constants.ShuttleMenuCurrentTab.Admin:
        print("Debug: Admin Tab in");
        loadUnapprovedHistories()
            .then((value) => notifyHandler(totalUserShuttlePrchHstrList));
    }
  }
}
