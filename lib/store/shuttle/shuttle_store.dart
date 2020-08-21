import 'package:clearApp/exception/auth_exception.dart';
import 'package:clearApp/store/error/error_store.dart';
import 'package:clearApp/store/shuttle/shuttle_form_store.dart';
import 'package:clearApp/store/success/success_store.dart';
import 'package:clearApp/util/convert_util.dart';
import 'package:clearApp/util/http_client.dart';
import 'package:clearApp/vo/shuttle_order_history/shuttle_order_history.dart';
import 'package:mobx/mobx.dart';

part 'shuttle_store.g.dart';

class ShuttleStore = _ShuttleStore with _$ShuttleStore;

abstract class _ShuttleStore with Store {
  // other stores:--------------------------------------------------------------
  final ErrorStore errorStore = ErrorStore();
  final SuccessStore successStore = SuccessStore();
  final ShuttleFormStore shuttleFormStore = ShuttleFormStore();

  // disposers:-----------------------------------------------------------------
  List<ReactionDisposer> _disposers;

  // constructor:---------------------------------------------------------------
  _ShuttleStore() {
    histories = new List<ShuttleOrderHistory>();
    getUsersHistories();
  }

  // store variables:-----------------------------------------------------------
  @observable
  List<ShuttleOrderHistory> histories;

  @observable
  bool loading = false;

  @observable
  bool success = false;

  @observable
  int remaining = 0;

  @computed
  int get unconfirmedPrice => calUnconfirmedPrice(histories);

  // actions:-------------------------------------------------------------------
  @action
  Future getUsersHistories() async {
    if (loading) return;
    loading = true;
    Map<String, dynamic> params = {'type': 'histories', 'range': 'user'};

    await HttpClient.send(
            method: "GET", address: "/api/clear/shuttle", params: params)
        .then((response) {
          histories = ConvertUtil.jsonArrayToObjectList(
              response, (json) => ShuttleOrderHistory.fromJson(json));
        })
        .catchError((e) => updateOnError("Invalid User"),
            test: (e) => e is AuthException)
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future getNotReceivedUsersHistories() async {
    if (loading) return;
    loading = true;
    Map<String, dynamic> params = {'type': 'histories', 'range': 'user'};

    await HttpClient.send(
            method: "GET", address: "/api/clear/shuttle", params: params)
        .then((response) {
          histories = filterNotRecieved(ConvertUtil.jsonArrayToObjectList(
              response, (json) => ShuttleOrderHistory.fromJson(json)));
        })
        .catchError((e) => updateOnError("Invalid User"),
            test: (e) => e is AuthException)
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future getWholeUnconfirmedHistorires() async {
    if (loading) return;
    loading = true;
    Map<String, dynamic> params = {'type': 'histories', 'range': 'whole'};

    await HttpClient.send(
            method: "GET", address: "/api/clear/shuttle", params: params)
        .then((response) {
          histories = ConvertUtil.jsonArrayToObjectList(
              response, (json) => ShuttleOrderHistory.fromJson(json));
        })
        .catchError((e) => updateOnError("Invalid User"),
            test: (e) => e is AuthException)
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future receiveShuttle(List<int> idList) async {
    if (loading) return;
    loading = true;
    Map<String, dynamic> params = {'type': 'receive'};
    Map<String, dynamic> body = {'id': idList};

    await HttpClient.send(
            method: "PATCH",
            address: "/api/clear/shuttle",
            params: params,
            body: body)
        .then((response) {
          updateOnSuccess("Received");
        })
        .catchError((e) => updateOnError("Invalid User"),
            test: (e) => e is AuthException)
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future confirmDeposit(List<int> idList) async {
    if (loading) return;
    loading = true;
    Map<String, dynamic> params = {'type': 'confirm'};
    Map<String, dynamic> body = {'id': idList};

    await HttpClient.send(
            method: "PATCH",
            address: "/api/clear/shuttle",
            params: params,
            body: body)
        .then((response) {
          updateOnSuccess("Confirmed");
        })
        .catchError((e) => updateOnError("Invalid User"),
            test: (e) => e is AuthException)
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  // dispose:-------------------------------------------------------------------
  @action
  dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  // functions:-----------------------------------------------------------------
  int calUnconfirmedPrice(List<ShuttleOrderHistory> list) {
    int moneyToPay = 0;
    list.forEach((element) {
      element.depositConfirmed ? moneyToPay += 0 : moneyToPay += element.price;
    });
    return moneyToPay;
  }

  List<ShuttleOrderHistory> filterNotRecieved(List<ShuttleOrderHistory> list) {
    return list.where((element) => element.received == false).toList();
  }

  void updateOnError(String message) {
    errorStore.errorMessage = message;
    success = false;
  }

  void updateOnSuccess(String message) {
    successStore.successMessage = message;
    success = true;
  }
}
