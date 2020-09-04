import 'package:clearApp/contants/globals.dart';
import 'package:clearApp/service/navigation_service.dart';
import 'package:mobx/mobx.dart';

part 'success_store.g.dart';

class SuccessStore = _SuccessStore with _$SuccessStore;

abstract class _SuccessStore with Store {
  // disposers
  List<ReactionDisposer> _disposers;

  // constructor:---------------------------------------------------------------
  _SuccessStore() {
    _disposers = [
      reaction((_) => success, show),
      reaction((_) => success, reset, delay: 100),
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  String successMessage = '';

  @observable
  bool success = false;

  // actions:-------------------------------------------------------------------
  @action
  void reset(bool value) {
    if (value) {
      successMessage = '';
      success = false;
    }
  }

  // dispose:-------------------------------------------------------------------
  void show(bool value) {
    if (value) {
      locator<NavigationService>().showSuccessToast(successMessage);
    }
  }

  @action
  dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
