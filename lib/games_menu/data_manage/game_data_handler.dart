import 'dart:convert';

import 'package:clearApp/util/popup_widgets/popup_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:clearApp/util/api_service.dart';

import '../../util/constants.dart' as Constants;
import './game_data.dart';
import './events.dart';

class GameDataHandler {
  List<GameData> gameDataList = new List<GameData>();

  //Callbacks
  Function(List<GameData>) dataUpdateCallback;

  //etc
  BuildContext context;

  GameDataHandler(BuildContext _context) {
    context = _context;
  }

  void registerDataUpdateCallback(Function(List<GameData>) callback) =>
      dataUpdateCallback = callback;

  void eventHandle(
    EVENT eventType, {
    GameData newGame,
  }) {
    switch (eventType) {
      case EVENT.MakeGameEvent:
        Logger().i('Make Game Event occured');
        makeGame(newGame).then((list) => dataUpdateCallback(list));
        break;
      case EVENT.ChangeAttendableEvent:
        break;
      case EVENT.ChangeAttendStateEvent:
        break;
      case EVENT.DeleteGameEvent:
        break;
      case EVENT.RefreshEvent:
        Logger().i('refresh Event occured');
        getGames().then((list) => dataUpdateCallback(list));
        break;
      default:
        Logger().e('ERROR: unknown event: $eventType');
        throw ('unknown event');
    }
  }

  Future<List<GameData>> makeGame(GameData newGame) async {
    gameDataList.add(newGame);
    try {
      APIService.doPost(Constants.gamesListURL, 'makeGame',
              body: jsonEncode(newGame.toMap()))
          .then((value) => Logger().i('makeGame succeed. $value'));
    } catch (error) {
      PopupGenerator.errorPopupWidget(
          context,
          'ERROR!',
          'Please retry : $error',
          () => Navigator.pushNamed(context, '/homescreen')).show();
    }

    return gameDataList;
  }

  Future<List<GameData>> getGames() async {
    Map<String, dynamic> response;
    try {
      response =
          await APIService.doGet(Constants.gamesListURL, 'getGames', new Map());
    } catch (error) {
      PopupGenerator.errorPopupWidget(
          context,
          'ERROR!',
          'Please check internet connection : $error',
          () => Navigator.pushNamed(context, '/homescreen')).show();
    }

    gameDataList = new List<GameData>();

    List<dynamic> jsonList = response['data'];
    jsonList.forEach((element) {
      Map<String, dynamic> _map = element;
      gameDataList.add(GameData.fromMap(_map));
    });

    return gameDataList;
  }
}
