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
        break;
      default:
        Logger().e('ERROR: unknown event: $eventType');
        throw ('unknown event');
    }
  }

  Future<List<GameData>> makeGame(GameData newGame) async {
    gameDataList.add(newGame);

    try {
      APIService.doGet(Constants.gamesListURL, 'makeGame', newGame.toMap());
    } catch (error) {
      PopupGenerator.errorPopupWidget(
          context,
          'ERROR!',
          'Please retry : $error',
          () => Navigator.pushNamed(context, '/homescreen')).show();
    }

    return gameDataList;
  }
}
