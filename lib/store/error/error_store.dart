import 'package:clearApp/contants/globals.dart';
import 'package:clearApp/service/navigation_service.dart';
import 'package:mobx/mobx.dart';

part 'error_store.g.dart';

class ErrorStore = _ErrorStore with _$ErrorStore;

abstract class _ErrorStore with Store {
  // disposers
  List<ReactionDisposer> _disposers;

  // constructor:---------------------------------------------------------------
  _ErrorStore() {
    _disposers = [
      reaction((_) => error, show),
      reaction((_) => error, reset, delay: 200),
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  String errorMessage = '';

  @observable
  bool error = false;

  // actions:-------------------------------------------------------------------

  @action
  void reset(bool value) {
    if (value) {
      errorMessage = '';
      error = false;
    }
  }

  void show(bool value) {
    if (value) {
      locator<NavigationService>().showErrorToast(errorMessage);
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
