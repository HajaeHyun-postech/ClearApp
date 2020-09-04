import 'package:clearApp/store/base_store.dart';
import 'package:mobx/mobx.dart';

part 'game_store.g.dart';

class GameStore = _GameStore with _$GameStore;

abstract class _GameStore extends BaseStore with Store {
  // other stores:--------------------------------------------------------------

  // disposers:-----------------------------------------------------------------
  List<ReactionDisposer> disposers = [];

  // constructor:---------------------------------------------------------------

  // store variables:-----------------------------------------------------------

  // actions:-------------------------------------------------------------------

  // dispose:-------------------------------------------------------------------
  @action
  dispose() {
    super.dispose();
    for (final d in disposers) {
      d();
    }
  }

  // functions:-----------------------------------------------------------------
}
