import 'package:clearApp/exception/unexpected_conflict_exception.dart';
import 'package:clearApp/store/error/error_store.dart';
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

  // disposers:-----------------------------------------------------------------
  List<ReactionDisposer> disposers = [];

  // constructor:---------------------------------------------------------------
  _ShuttleStore() {
    getUsersHistories();
  }

  // store variables:-----------------------------------------------------------
  @observable
  List<ShuttleOrderHistory> histories = new List<ShuttleOrderHistory>();

  @observable
  bool loading = false;

  @computed
  int get unconfirmedPrice => calUnconfirmedPrice(histories);

  // actions:-------------------------------------------------------------------
  @action
  Future getUsersHistories() async {
    if (loading) return;

    loading = true;
    Map<String, dynamic> params = {'type': 'histories', 'range': 'user'};

    HttpClient.send(
            method: "GET", address: "/api/clear/shuttle", params: params)
        .then((response) {
          histories = ConvertUtil.jsonArrayToObjectList(
              response, (json) => ShuttleOrderHistory.fromJson(json));
        })
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future getNotReceivedUsersHistories() async {
    if (loading) return;

    loading = true;
    Map<String, dynamic> params = {'type': 'histories', 'range': 'user'};

    HttpClient.send(
            method: "GET", address: "/api/clear/shuttle", params: params)
        .then((response) {
          histories = filterNotRecieved(ConvertUtil.jsonArrayToObjectList(
              response, (json) => ShuttleOrderHistory.fromJson(json)));
        })
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future getWholeUnconfirmedHistorires() async {
    if (loading) return;

    loading = true;
    Map<String, dynamic> params = {'type': 'histories', 'range': 'whole'};

    HttpClient.send(
            method: "GET", address: "/api/clear/shuttle", params: params)
        .then((response) {
          histories = ConvertUtil.jsonArrayToObjectList(
              response, (json) => ShuttleOrderHistory.fromJson(json));
        })
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future receiveShuttle(List<int> idList, bool received) async {
    if (received) {
      updateOnError("Alreay Received");
      return;
    }

    Map<String, dynamic> params = {'type': 'receive'};
    Map<String, dynamic> body = {'id': idList};

    HttpClient.send(
            method: "PATCH",
            address: "/api/clear/shuttle",
            params: params,
            body: body)
        .then((response) {
      updateOnSuccess("Received");
    }).catchError((e) => updateOnError(e.cause));
  }

  @action
  Future confirmDeposit(List<int> idList, bool confirmed) async {
    if (confirmed) {
      updateOnError("Already Confirmed");
      return;
    }

    Map<String, dynamic> params = {'type': 'confirm'};
    Map<String, dynamic> body = {'id': idList};

    HttpClient.send(
            method: "PATCH",
            address: "/api/clear/shuttle",
            params: params,
            body: body)
        .then((response) {
      updateOnSuccess("Confirmed");
    }).catchError((e) => updateOnError(e.cause));
  }

  @action
  Future deleteOrder(List<int> idList, bool received, bool confirmed) async {
    if (received || confirmed) {
      updateOnError("Delete Failed");
      return;
    }
    Map<String, dynamic> params = {'id': idList};

    HttpClient.send(
            method: "DELETE", address: "/api/clear/shuttle", params: params)
        .then((response) {
          updateOnSuccess("Deleted");
        })
        .catchError((e) => updateOnError("Timeout (5min)"),
            test: (e) => e is UnexpectedConflictException)
        .catchError((e) => updateOnError(e.cause));
  }

  // dispose:-------------------------------------------------------------------
  @action
  dispose() {
    errorStore.dispose();
    successStore.dispose();
    for (final d in disposers) {
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
    errorStore.error = true;
  }

  void updateOnSuccess(String message) {
    successStore.successMessage = message;
    successStore.success = true;
  }
}
