import 'package:clearApp/ui/shuttle_menu/data_manage/shuttle_purchace_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import '../../../util/http_client.dart';
import '../../../contants/constants.dart' as Constants;
import 'events.dart';

class FormSubject extends ChangeNotifier {
  bool _isFeching;
  bool _isAddingNewHstr;
  Function _addNewHstrCallback;
  int _remainingShuttles;
  BuildContext _context;

  bool get isFeching => _isFeching;
  bool get isAddingNewHstr => _isAddingNewHstr;
  int get remainingShuttles => _remainingShuttles;

  FormSubject({Function callback, BuildContext context}) {
    _isFeching = true;
    _isAddingNewHstr = false;
    _remainingShuttles = 0;
    _context = context;
    _addNewHstrCallback = callback;

    eventHandle(EVENT.ShuttleAmountRefreshEvent);
  }

  void notifyListenersWith(
      {bool isEditingMode = true,
      bool isFeching = false,
      bool isAddingNewHstr = false}) {
    _isFeching = isFeching;
    _isAddingNewHstr = isAddingNewHstr;
    notifyListeners();
  }

  Future<void> eventHandle(EVENT eventType,
      {ShuttlePrchHstr newHstr, bool isEditingMode}) async {
    try {
      switch (eventType) {
        case EVENT.AddNewEvent:
          Logger().i("Add new event occured");
          await addNewPrchHstr(newHstr);
          break;

        case EVENT.ShuttleAmountRefreshEvent:
          Logger().i('Shuttle amount refresh event occured');
          await getRemainingCount();
          break;

        default:
          Logger().e('ERROR: unknown event: $eventType');
          throw ('unknown event');
      }
    } catch (error) {
      Logger().e('error... $error');
    }
    Logger().i('Event handling finished');
  }

  Future<void> getRemainingCount() async {
    notifyListenersWith(
        isFeching: true, isAddingNewHstr: false, isEditingMode: true);

    Map<String, dynamic> response =
        await HttpClient.send(method: "get", address: "TODO");
    int remainingShuttles = response['data'] as int;
    Logger().i('got count : $remainingShuttles');

    _remainingShuttles = remainingShuttles;

    notifyListenersWith(
        isFeching: false, isAddingNewHstr: false, isEditingMode: true);
  }

  Future<void> addNewPrchHstr(ShuttlePrchHstr newHstr) async {
    notifyListenersWith(
        isFeching: false, isAddingNewHstr: true, isEditingMode: true);

    await _addNewHstrCallback(newHstr);
  }
}
