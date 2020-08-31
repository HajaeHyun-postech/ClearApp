import 'package:clearApp/exception/unexpected_conflict_exception.dart';
import 'package:clearApp/store/error/error_store.dart';
import 'package:clearApp/store/success/success_store.dart';
import 'package:clearApp/util/convert_util.dart';
import 'package:clearApp/util/http_client.dart';
import 'package:clearApp/vo/shuttle_order_history/shuttle_order_history.dart';
import 'package:mobx/mobx.dart';

part 'shuttle_store.g.dart';

enum TAB { Total, Not_Rcved, Admin }

class ShuttleStore = _ShuttleStore with _$ShuttleStore;

abstract class _ShuttleStore with Store {
  // other stores:--------------------------------------------------------------
  final ErrorStore errorStore = ErrorStore();
  final SuccessStore successStore = SuccessStore();

  // disposers:-----------------------------------------------------------------
  List<ReactionDisposer> disposers = [];

  // constructor:---------------------------------------------------------------
  _ShuttleStore() {
    refreshOnTabChange();
  }

  // store variables:-----------------------------------------------------------
  @observable
  List<ShuttleOrderHistory> histories = new List<ShuttleOrderHistory>();

  @observable
  bool loading = false;

  @observable
  TAB currentTab = TAB.Total;

  @computed
  int get unconfirmedPrice => calUnconfirmedPrice(histories);

  // actions:-------------------------------------------------------------------
  @action
  void tabChanged(TAB currentTab) {
    this.currentTab = currentTab;
  }

  @action
  void refreshOnTabChange() {
    if (currentTab == TAB.Admin) {
      getHistories(range: "all");
    } else if (currentTab == TAB.Not_Rcved) {
      getHistories(received: false);
    } else {
      getHistories();
    }
  }

  @action
  Future getHistories(
      {bool received, bool confirmed, String range = "me"}) async {
    if (loading) return;
    loading = true;

    Map<String, dynamic> params = {};
    if (received != null) {
      params.putIfAbsent('received', () => received);
    }
    if (confirmed != null) {
      params.putIfAbsent('confirmed', () => confirmed);
    }

    List<String> pathParams = [range];
    HttpClient.send(
            method: "GET",
            address: "/v1/shuttle/orders",
            params: params,
            pathParams: pathParams)
        .then((response) {
          histories = ConvertUtil.jsonArrayToObjectList(
              response, (json) => ShuttleOrderHistory.fromJson(json));
        })
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future receiveShuttle(List<int> idList, bool isReceived) async {
    Map<String, dynamic> body = {'id': idList};

    HttpClient.send(
            method: "PATCH", address: "/v1/shuttle/orders/receive", body: body)
        .then((response) {
      updateOnSuccess("Received");
    }).catchError((e) => updateOnError(e.cause));
  }

  @action
  Future confirmDeposit(List<int> idList, bool isConfirmed) async {
    Map<String, dynamic> body = {'id': idList};

    HttpClient.send(
            method: "PATCH", address: "/v1/shuttle/orders/confirm", body: body)
        .then((response) {
      updateOnSuccess("Confirmed");
    }).catchError((e) => updateOnError(e.cause));
  }

  @action
  Future deleteOrder(
      List<int> idList, bool isReceived, bool isConfirmed) async {
    Map<String, dynamic> params = {'id': idList};

    HttpClient.send(
            method: "PUT", address: "/v1/shuttle/orders", params: params)
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
      element.isConfirmed ? moneyToPay += 0 : moneyToPay += element.price;
    });
    return moneyToPay;
  }

  List<ShuttleOrderHistory> filterNotRecieved(List<ShuttleOrderHistory> list) {
    return list.where((element) => element.isReceived == false).toList();
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
