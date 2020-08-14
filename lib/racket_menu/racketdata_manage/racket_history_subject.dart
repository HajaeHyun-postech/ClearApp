import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../login/login_info.dart';
import 'package:logger/logger.dart';
import 'events.dart';
import 'package:clearApp/util/api_service.dart';
import '../../util/constants.dart' as Constants;
import '../../util/toast_generator.dart';
import 'racket_rent_history.dart';
import 'racket_current_info.dart';

class RacketHstrSubject extends ChangeNotifier{
  BuildContext _context;
  bool _isFetching;
  List<RacketCurrentInfo> _racketCurrentInfoList;
  List<RacketRentHstr> _userSpecificRacketRentHstrList;
  List<RacketRentHstr> _totalUserRacketRentHstrList;

  bool get isFetching => _isFetching;
  List<RacketCurrentInfo> get racketCurrentInfoList => _racketCurrentInfoList;

  RacketHstrSubject(BuildContext context){
    _context = context;
    _isFetching = false;
    _racketCurrentInfoList = new List<RacketCurrentInfo>();
    _userSpecificRacketRentHstrList = new List<RacketRentHstr>();
    _totalUserRacketRentHstrList = new List<RacketRentHstr>();

  }

  void notifyListenersWith({bool isFetching = false}){
    _isFetching = isFetching;
    notifyListeners();
  }
  
  Future<void> eventHandle(EVENT eventType,
  {RacketRentHstr newHstr})async {
    try{
      switch(eventType){

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
        
      case EVENT.FilterAllRacketStatusEvent:
        Logger().i("Filter All Racket Status Event occured");
        //await filterAllRacket(newHstr);
        Toast_generator.successToast(_context, 'Filterd');
        break;
        
      case EVENT.FilterMyHstrEvent:
        Logger().i("Filter My history occured");
        //await filterMyHstr(newHstr);
        Toast_generator.successToast(_context, 'Filterd');
        break;
        
      case EVENT.FilterMyRacketStatusEvent:
        Logger().i("Filter My Racket Status Occured");
        //await filterMyStatus(newHstr);
        Toast_generator.successToast(_context, 'Filterd');
        break;
        
      default:
        Logger().e('ERROR : unknown event: $eventType');
        throw('unknwon event');
      }
    }catch(error){
      Logger().e('error...$error');
      Toast_generator.errorToast(_context, '$error');
    } finally{
      Logger().i('Event handling finished');
    }

  }
}