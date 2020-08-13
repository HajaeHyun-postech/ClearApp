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
}