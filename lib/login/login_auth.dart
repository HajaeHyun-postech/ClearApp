import 'package:gsheets/gsheets.dart';
import '../util/constants.dart' as Constants;

const _spreadsheetId = '1N1fHuGuZdoLy10QQiBzDxXDBI67RnDk-N0gOZgIfF5A';

class LoginAuth {
  static Future<bool> loginAuth(String name, String studentId) async {
    final gsheets = GSheets(Constants.CREDENTIAL);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    var sheet = await ss.worksheetByTitle('sheet');
    sheet ??= await ss.addWorksheet('sheet');
  }
}
