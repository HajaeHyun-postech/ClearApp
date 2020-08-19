import 'package:clearApp/ui/racket_menu/racket_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../util/api_service.dart';
import '../../../util/constants.dart' as Constants;
import '../../../util/toast_generator.dart';
import 'events.dart';
import 'racket_current_info.dart';
import 'racket_rent_history.dart';

class RacketHstrSubject extends ChangeNotifier {
  BuildContext _context;
  bool _isFetching;
  RacketCurrentMenu _previousFilter;
  List<RacketCard> _racketList;
  List<RacketCard> _userSpecificRacketStatusList;
  List<RacketCard> _userSpecificRacketRentHstrList; //FIx
  List<RacketCard> _totalUserRacketRentHstrList; //Fix

  bool get isFetching => _isFetching;
  List<RacketCard> get racketList => _racketList;

  RacketHstrSubject(BuildContext context) {
    _context = context;
    _isFetching = false;
    _userSpecificRacketStatusList = new List<RacketCard>();
    _userSpecificRacketRentHstrList = new List<RacketCard>();
    _totalUserRacketRentHstrList = new List<RacketCard>();
    _previousFilter = RacketCurrentMenu.FilterAllRacketStatusEvent;

    eventHandle(EVENT.FilterChangeEvent, filter: _previousFilter);
  }

  void notifyListenersWith({bool isFetching = false}) {
    _isFetching = isFetching;
    notifyListeners();
  }

  Future<void> updateFilterMenu(RacketCurrentMenu menu) async {
    notifyListenersWith(isFetching: true);
    switch (menu) {
      case RacketCurrentMenu.FilterMyHstrEvent:
        Logger().i('Filter changed to My history');
        break;

      case RacketCurrentMenu.FilterMyRacketStatusEvent:
        Logger().i('Filter changed to My racket status');
        _racketList = _userSpecificRacketRentHstrList;
        break;

      case RacketCurrentMenu.FilterAllRacketStatusEvent:
        _racketList = _userSpecificRacketStatusList;
        Logger().i('Filter changed to All racket Status');
        break;

      case RacketCurrentMenu.FilterAllRacketHstrEvent:
        Logger().i('Filter changed to All Racket History');
        _racketList = _totalUserRacketRentHstrList;
        break;
    }
    _previousFilter = menu;
    notifyListenersWith(isFetching: false);
  }

  Future<void> eventHandle(EVENT eventType,
      {RacketCurrentMenu filter, RacketRentHstr newHstr}) async {
    try {
      switch (eventType) {
        case EVENT.RacketRentEvent:
          Logger().i("Racket Rent event occured");
          // await addNewRentHstr(newHstr);

          Toast_generator.successToast(_context, 'Rented');
          break;

        case EVENT.RacketReturnEvent:
          Logger().i("Racket Return event occured");
          //await addNewReturnHstr(newHstr);
          Toast_generator.successToast(_context, 'Returned');
          break;

        case EVENT.FilterChangeEvent:
          Logger().i("Filter Change event occured");
          await updateFilterMenu(filter);
          Toast_generator.successToast(_context, 'Filter Changed');
          break;
        default:
          Logger().e('ERROR : unknown event: $eventType');
          throw ('unknwon event');
      }
    } catch (error) {
      Logger().e('error...$error');
      Toast_generator.errorToast(_context, '$error');
    } finally {
      Logger().i('Event handling finished');
    }
  }
}
