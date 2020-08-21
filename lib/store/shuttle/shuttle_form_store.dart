import 'package:clearApp/exception/auth_exception.dart';
import 'package:clearApp/store/error/error_store.dart';
import 'package:clearApp/store/success/success_store.dart';
import 'package:clearApp/util/http_client.dart';
import 'package:mobx/mobx.dart';

part 'shuttle_form_store.g.dart';

class ShuttleFormStore = _ShuttleFormStore with _$ShuttleFormStore;

abstract class _ShuttleFormStore with Store {
  // other stores:--------------------------------------------------------------
  final ErrorStore errorStore = ErrorStore();
  final SuccessStore successStore = SuccessStore();

  // disposers:-----------------------------------------------------------------
  List<ReactionDisposer> _disposers;

  // constructor:---------------------------------------------------------------
  _ShuttleFormStore() {
    _disposers = [
      reaction((_) => invalidAmount, (value) => invalidAmount = false,
          delay: 1000),
      reaction((_) => invalidUsage, (value) => invalidUsage = false,
          delay: 1000),
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  bool loading = false;

  @observable
  bool success = false;

  @observable
  bool invalidAmount = false;

  @observable
  bool invalidUsage = false;

  @observable
  int remaining = 0;

  @observable
  int amount = 1;

  @observable
  String usageString = '';

  // actions:-------------------------------------------------------------------
  @action
  Future getRemaining() async {
    if (loading) return;
    loading = true;
    Map<String, dynamic> params = {'type': 'remaining'};

    await HttpClient.send(
            method: "GET", address: "/api/clear/shuttle", params: params)
        .then((response) {
          remaining = response['remaining'];
        })
        .catchError((e) => updateOnError("Invalid User"),
            test: (e) => e is AuthException)
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future addOrder() async {
    if (usageString == '') {
      updateOnError("Usage가 없습니다");
      return;
    }
    if (loading) return;
    loading = true;

    Map<String, dynamic> body = {'amount': amount, 'usage': usageString};
    await HttpClient.send(
            method: "POST", address: "/api/clear/shuttle", body: body)
        .then((response) {
          updateOnSuccess("Order Successful");
        })
        .catchError((e) => updateOnError("Invalid User"),
            test: (e) => e is AuthException)
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  void setUsageString(String usage) {
    usageString = usage;
  }

  @action
  void incrementAmount() {
    if (amount + 1 > remaining) {
      invalidAmount = true;
    } else {
      invalidAmount = false;
      amount += 1;
    }
    getRemaining();
  }

  @action
  void decrementAmount() {
    if (amount - 1 < 1) {
      invalidAmount = true;
    } else {
      invalidAmount = false;
      amount -= 1;
    }
    getRemaining();
  }

  @action
  void reset() {
    invalidAmount = false;
  }

  // dispose:-------------------------------------------------------------------
  @action
  dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  // functions:-----------------------------------------------------------------
  void updateOnError(String message) {
    errorStore.errorMessage = message;
    success = false;
  }

  void updateOnSuccess(String message) {
    successStore.successMessage = message;
    success = true;
  }
}
