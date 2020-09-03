import 'package:mobx/mobx.dart';

import '../../util/convert_util.dart';
import '../../vo/shuttle_order_history/shuttle_order_history.dart';
import '../base_store.dart';

part 'shuttle_store.g.dart';

enum TAB { Total, Not_Rcved, Admin }

class ShuttleStore = _ShuttleStore with _$ShuttleStore;

abstract class _ShuttleStore extends BaseStore with Store {
  // other stores:--------------------------------------------------------------

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

    httpClient
        .send(
            method: "GET", address: "/v1/shuttle/orders/$range", params: params)
        .then((response) {
          histories = ConvertUtil.jsonArrayToObjectList(
              response, (json) => ShuttleOrderHistory.fromJson(json));
        })
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future receiveShuttle(List<int> id) async {
    Map<String, dynamic> body = {'id': id};

    httpClient
        .send(
            method: "PATCH", address: "/v1/shuttle/orders/receive", body: body)
        .then((response) {
      updateOnSuccess("Received");
    }).catchError((e) => updateOnError(e.cause));
  }

  @action
  Future confirmDeposit(List<int> id) async {
    Map<String, dynamic> body = {'id': id};

    httpClient
        .send(
            method: "PATCH", address: "/v1/shuttle/orders/confirm", body: body)
        .then((response) {
      updateOnSuccess("Confirmed");
    }).catchError((e) => updateOnError(e.cause));
  }

  @action
  Future deleteOrder(List<int> id) async {
    Map<String, dynamic> body = {'id': id};

    httpClient
        .send(method: "PUT", address: "/v1/shuttle/orders", body: body)
        .then((response) {
      updateOnSuccess("Deleted");
    }).catchError((e) => updateOnError(e.cause));
  }

  // dispose:-------------------------------------------------------------------
  @action
  dispose() {
    super.dispose();
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
}
