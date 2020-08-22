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
  List<ReactionDisposer> disposers = [];

  // constructor:---------------------------------------------------------------
  _ShuttleFormStore() {
    getRemaining();
  }

  // store variables:-----------------------------------------------------------
  @observable
  bool loading = false;

  @observable
  bool success = false;

  @observable
  bool failed = false;

  @observable
  bool invalidAmount = false;

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

    HttpClient.send(
            method: "GET", address: "/api/clear/shuttle", params: params)
        .then((response) {
          remaining = response['remaining'];
        })
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
    HttpClient.send(method: "POST", address: "/api/clear/shuttle", body: body)
        .then((response) {
          updateOnSuccess("Order Successful");
        })
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
  }

  @action
  void decrementAmount() {
    if (amount - 1 < 1) {
      invalidAmount = true;
    } else {
      invalidAmount = false;
      amount -= 1;
    }
  }

  // dispose:-------------------------------------------------------------------
  @action
  dispose() {
    usageString = '';
    amount = 1;
    for (final d in disposers) {
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
