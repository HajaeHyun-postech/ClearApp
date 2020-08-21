import 'package:mobx/mobx.dart';

part 'success_store.g.dart';

class SuccessStore = _SuccessStore with _$SuccessStore;

abstract class _SuccessStore with Store {
  // disposers
  List<ReactionDisposer> _disposers;

  // constructor:---------------------------------------------------------------
  _SuccessStore() {
    _disposers = [
      reaction((_) => successMessage, reset, delay: 200),
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  String successMessage = '';

  // actions:-------------------------------------------------------------------
  @action
  void setSuccessMessage(String message) {
    this.successMessage = message;
  }

  @action
  void reset(String value) {
    successMessage = '';
  }

  // dispose:-------------------------------------------------------------------
  @action
  dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
