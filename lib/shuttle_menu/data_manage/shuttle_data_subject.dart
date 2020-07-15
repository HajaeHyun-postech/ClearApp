import 'dart:convert';

import 'package:clearApp/shuttle_menu/data_manage/shuttle_data.dart';
import 'package:gsheets/gsheets.dart';
import '../../login/login_info.dart';
import '../../util/constants.dart' as Constants;

const _spreadsheetId = '1AbK660l9RUdCTJbg-KHZyhwnIM9sOs0gi6B8Ujt2jEU';

class ShuttleDataSubject {
  List<ShuttleData> shuttleDatas;
  Function(List<ShuttleData> _shuttleDatas) updateHandler;
  Worksheet totalSheet;
  Worksheet adminSheet;

  ShuttleDataSubject.initial(
      Function(List<ShuttleData> _shuttleDatas) _handler) {
    initialDataGet()
        .then((_shuttleDatas) => _handler(shuttleDatas = _shuttleDatas));
    updateHandler = _handler;
  }

  Future<List<ShuttleData>> initialDataGet() async {
    List<ShuttleData> _shuttleDatas;
    final gsheets = GSheets(Constants.CREDENTIAL);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    totalSheet = ss.worksheetByTitle('total_sheet');
    adminSheet = ss.worksheetByTitle('admin_sheet');

    final shuttleDataList =
        await totalSheet.values.row(LoginInfo().rowNum, fromColumn: 2);

    shuttleDataList.forEach((element) =>
        _shuttleDatas.add(ShuttleData.fromJson(jsonDecode(element))));

    return _shuttleDatas;
  }

  void insertTotalGSheet(ShuttleData newShuttleData) async {
    int columnToInsert = int.parse(
            await totalSheet.values.value(column: 1, row: LoginInfo().rowNum)) +
        2;

    await totalSheet.values.insertValue(newShuttleData.toJson(),
        column: columnToInsert, row: LoginInfo().rowNum);
  }

  void insertAdminGSheet(ShuttleData newShuttleData) async {
    int rowToInsert =
        int.parse(await adminSheet.values.value(column: 1, row: 1)) + 2;

    await adminSheet.values
        .insertValue(newShuttleData.toJson(), column: 1, row: rowToInsert);
  }

  void updateTotalGSheet(int index) async {
    await totalSheet.values.insertValue(shuttleDatas[index].toJson(),
        column: (index + 2), row: LoginInfo().rowNum);
  }

  //types of event
  //add new
  //received (also update admin)
  //approved
  void updateAddNew(ShuttleData newShuttleData) {
    shuttleDatas.add(newShuttleData);
    insertTotalGSheet(newShuttleData);
    insertAdminGSheet(newShuttleData);
    updateHandler(shuttleDatas);
  }

  //refactor needed
  void updateReceived(int index) {
    shuttleDatas[index].received = true;
    updateTotalGSheet(index);
    updateHandler(shuttleDatas);
  }

  void updateApproved(ShuttleData newShuttleData) {
    shuttleDatas.forEach((element) {
      if (element == newShuttleData) {
        element.approved = true;
        updateHandler(shuttleDatas);
        insertTotalGSheet(element);
        insertAdminGSheet(element);
      }
    });
  }

  //tab update
  void updateTabChanged(Constants.ShuttleMenuCurrentTab tab) {
    switch (tab) {
      case Constants.ShuttleMenuCurrentTab.Total:
        print('debug1');
        break;

      case Constants.ShuttleMenuCurrentTab.Not_Rcved:
        print('debug2');
        break;

      case Constants.ShuttleMenuCurrentTab.Admin:
        print('debug3');
        break;
    }
  }
}
