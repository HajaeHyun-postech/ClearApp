import 'package:clearApp/exception/auth_exception.dart';
import 'package:clearApp/store/error/error_store.dart';
import 'package:clearApp/store/success/success_store.dart';
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
  List<ReactionDisposer> _disposers;

  // constructor:---------------------------------------------------------------
  _ShuttleStore();

  // store variables:-----------------------------------------------------------
  @observable
  List<ShuttleOrderHistory> usersHistories;

  @observable
  List<ShuttleOrderHistory> wholeUnconfirmedHistorires;

  @observable
  bool loading;

  @observable
  bool success;

  @computed
  List<ShuttleOrderHistory> get usersNotReceivedHistories =>
      filterNotRecieved(usersHistories);

  @computed
  int get usersUnconfirmedPrice => calUnconfirmedPrice(usersHistories);

  @computed
  int get wholeUnconfirmedPrice =>
      calUnconfirmedPrice(wholeUnconfirmedHistorires);

  // actions:-------------------------------------------------------------------
  @action
  Future getUsersHistories() async {
    if (loading) return;
    loading = true;
    Map<String, dynamic> params = {'type': 'histories'};

    HttpClient.send(
            method: "GET", address: "/api/clear/shuttle", params: params)
        .then((response) {
          print(response);
          updateOnSuccess("Loading Complete");
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
    Map<String, dynamic> params = {'type': 'histories'};

    HttpClient.send(
            method: "GET", address: "/api/clear/shuttle", params: params)
        .then((response) {
          print(response);
          updateOnSuccess("Loading Complete");
        })
        .catchError((e) => updateOnError("Invalid User"),
            test: (e) => e is AuthException)
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future receiveShuttle(int id) async {
    if (loading) return;
    loading = true;
    Map<String, dynamic> params = {'type': 'receive'};
    Map<String, dynamic> body = {'id': id};

    HttpClient.send(
            method: "PATCH",
            address: "/api/clear/shuttle",
            params: params,
            body: body)
        .then((response) {
          print(response);
          updateOnSuccess("Received");
        })
        .catchError((e) => updateOnError("Invalid User"),
            test: (e) => e is AuthException)
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future confirmDeposit(int id) async {
    if (loading) return;
    loading = true;
    Map<String, dynamic> params = {'type': 'confirm'};
    Map<String, dynamic> body = {'id': id};

    HttpClient.send(
            method: "PATCH",
            address: "/api/clear/shuttle",
            params: params,
            body: body)
        .then((response) {
          print(response);
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
