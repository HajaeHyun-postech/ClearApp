import 'package:clearApp/shuttle_menu/data_manage/shuttle_hitsory_api.dart';
import 'package:clearApp/shuttle_menu/data_manage/shuttle_purchace_history.dart';
import 'package:clearApp/util/constants.dart' as Constants;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('shuttle buy menu data transfer test', () async {
    List<ShuttlePrchHstr> testList;
    ShuttlePrchHstrHandler instance = ShuttlePrchHstrHandler((list) {
      testList = list;
    });
    await instance.addNewPrchHistory('RM', 500000, 10);
    await Future.delayed(const Duration(seconds: 1), () {});
  });
}
