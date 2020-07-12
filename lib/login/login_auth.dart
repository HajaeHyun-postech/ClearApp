import 'package:gsheets/gsheets.dart';
import '../util/constants.dart' as Constants;

const _spreadsheetId = '1N1fHuGuZdoLy10QQiBzDxXDBI67RnDk-N0gOZgIfF5A';

class LoginAuth {
  static Future<String> loginAuth(String povisId, String studentId) async {
    final gsheets = GSheets(Constants.CREDENTIAL);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    var sheet = await ss.worksheetByTitle('sheet');
    sheet ??= await ss.addWorksheet('sheet');

    final studentIdList = await sheet.values.column(1);
    final povisIdList = await sheet.values.column(2);
    final nameList = await sheet.values.column(3);
    final adminList = await sheet.values.column(4);
    for (var i = 0; i < studentIdList.length; i++) {
      if (studentIdList[i] == studentId && povisIdList[i] == povisId) {
        return adminList[i] + nameList[i];
      }
    }

    return Future.error("not exist member");
  }
}
