import 'dart:convert';
import 'dart:io';

import 'package:clearApp/shuttle_menu/data_manage/shuttle_purchace_history.dart';
import 'package:gsheets/gsheets.dart';
import '../../login/login_info.dart';
import '../../util/constants.dart' as Constants;
import 'package:http/http.dart' as http;

const _spreadsheetId = '1AbK660l9RUdCTJbg-KHZyhwnIM9sOs0gi6B8Ujt2jEU';

//validate (갯수)
//Action 종류
//get my history (action: getMyHstr)
//get all unproved history (action: getAllUnapprHstr)
//reload approved (action: getMyHstr (received all, and processing))
//update rec/app (post, action: updateRec/Appr)
//add new Hstr (post, action: addNewPrchHstr)
//getAvailableShuttleList ()
//get action key studentId
//post action key studentId (data)

class ShuttlePrchHstrHandler {
  List<ShuttlePrchHstr> shuttlePrchHstrList;
  List<ShuttlePrchHstr> totalUserShuttlePrchHstrList;
  Function(List<ShuttlePrchHstr>) notifyHandler;
  Worksheet prchHstrSheet;
  Worksheet shuttlecockMngSheet;

  /**singleton pattern**/
  ShuttlePrchHstrHandler(Function(List<ShuttlePrchHstr>) _notifyHandler) {
    notifyHandler = _notifyHandler;
  }

  Future<void> intialize() async {
    await initialDataPull();
    updateTabChanged(Constants.ShuttleMenuCurrentTab.Total);
  }

  Future<void> initialDataPull() async {
    final gsheets = GSheets(Constants.CREDENTIAL);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    prchHstrSheet = ss.worksheetByTitle('shuttlecock_purchace_history');
    shuttlecockMngSheet = ss.worksheetByTitle('shuttlecock_manage');

    shuttlePrchHstrList = new List<ShuttlePrchHstr>();

    (await prchHstrSheet.values.map.allRows(fromRow: 2))
        .where((element) =>
            jsonDecode(element['studentId']) == LoginInfo().studentId)
        .toList()
        .forEach((element) {
      Map<String, String> mapData = new Map<String, String>();
      element.forEach((key, value) {
        mapData[key] = value;
      });
      shuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(mapData));
    });
  }

  /**Data pull methods**/
  Future<void> reloadApproved() async {
    shuttlePrchHstrList.forEach((element) {
      print('in : ${element.amount}');
      prchHstrSheet.values
          .valueByKeys(rowKey: element.key, columnKey: 'approved')
          .then((value) => element.approved = jsonDecode(value));
    });
  }

  Future<void> loadUnapprovedHistories() async {
    (await prchHstrSheet.values.map.allRows(fromRow: 2))
        .where((element) => !jsonDecode(element['approved']))
        .toList()
        .forEach((element) =>
            totalUserShuttlePrchHstrList.add(ShuttlePrchHstr.fromMap(element)));
  }

  Future<void> addNewPrchHistory(String _usage, int _price, int _amount) async {
    //TODO: shuttle List get
    ShuttlePrchHstr newHstr = ShuttlePrchHstr(_usage, _price, _amount);
    newHstr.shuttleList = [1, 2, 3];
    shuttlePrchHstrList = new List<ShuttlePrchHstr>(); //TODO: debug
    shuttlePrchHstrList.add(newHstr);

    //string -> json -> utf8 byte -> base64
    String url = Constants.shuttlePrchHstrSheetURL +
        '?action=addNewPrchHstr' +
        '&studentId=${LoginInfo().studentId}' +
        '&body=${base64Encode(utf8.encode(jsonEncode(newHstr.toMap())))}';

    print('$url');

    var response = await http.get(url);

    print('Debug[Response status: ${response.statusCode}]');
    print('Debug[Response body: ${response.body}]');
  }

  void updateReceived(String _key) {
    prchHstrSheet.values.insertValueByKeys(jsonEncode(true),
        rowKey: _key, columnKey: 'received');
    shuttlePrchHstrList.firstWhere((element) => element.key == _key).received =
        false;
  }

  void updateApproved(String _key) {
    prchHstrSheet.values.insertValueByKeys(jsonEncode(true),
        rowKey: _key, columnKey: 'approved');
    shuttlePrchHstrList.firstWhere((element) => element.key == _key).approved =
        false;
  }

  //tab update
  void updateTabChanged(Constants.ShuttleMenuCurrentTab tab) {
    print("Debug: update tab changed");
    switch (tab) {
      case Constants.ShuttleMenuCurrentTab.Total:
        print("Debug: Total Tab in");
        reloadApproved().then((value) => notifyHandler(shuttlePrchHstrList));
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
