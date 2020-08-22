import 'package:mobx/mobx.dart';

part 'error_store.g.dart';

class ErrorStore = _ErrorStore with _$ErrorStore;

abstract class _ErrorStore with Store {
  // disposers
  List<ReactionDisposer> _disposers;

  // constructor:---------------------------------------------------------------
  _ErrorStore() {
    _disposers = [
      reaction((_) => error, reset, delay: 100),
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  String errorMessage = '';

  @observable
  bool error = false;

  // actions:-------------------------------------------------------------------
  @action
  void setErrorMessage(String message) {
    this.errorMessage = message;
  }

  @action
  void reset(bool value) {
    errorMessage = '';
    error = false;
  }

  // dispose:-------------------------------------------------------------------
  @action
  dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
