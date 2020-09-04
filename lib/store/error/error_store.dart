import 'package:bot_toast/bot_toast.dart';
import 'package:clearApp/contants/globals.dart';
import 'package:clearApp/service/flush_service.dart';
import 'package:mobx/mobx.dart';

part 'error_store.g.dart';

class ErrorStore = _ErrorStore with _$ErrorStore;

abstract class _ErrorStore with Store {
  // disposers
  List<ReactionDisposer> _disposers;

  // constructor:---------------------------------------------------------------
  _ErrorStore() {
    _disposers = [
      reaction((_) => error, showAndReset),
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  String errorMessage = '';

  @observable
  bool error = false;

  // actions:-------------------------------------------------------------------
  @action
  void showAndReset(bool value) {
    if (value) {
      locator<FlushService>().errorToast(errorMessage);
      errorMessage = '';
      error = false;
    }
  }

  // dispose:-------------------------------------------------------------------
  @action
  dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
