import 'package:clearApp/store/error/error_store.dart';
import 'package:clearApp/store/success/success_store.dart';
import 'package:clearApp/util/convert_util.dart';
import 'package:clearApp/util/http_client.dart';
import 'package:clearApp/vo/racket/racket.dart';
import 'package:clearApp/vo/racket_check_out_history/racket_check_out_history.dart';
import 'package:mobx/mobx.dart';

part 'racket_store.g.dart';

enum RacketMenuEnum {
  AllRacketStatus,
  MyRacketHstr,
  AllHstr,
}

class RacketStore = _RacketStore with _$RacketStore;

abstract class _RacketStore with Store {
  // other stores:--------------------------------------------------------------
  final ErrorStore errorStore = ErrorStore();
  final SuccessStore successStore = SuccessStore();

  // disposers:-----------------------------------------------------------------
  List<ReactionDisposer> disposers = [];

  // constructor:---------------------------------------------------------------
  _RacketStore() {
    refreshOnTabChange();
  }

  // store variables:-----------------------------------------------------------
  @observable
  List<Racket> rackets = new List<Racket>();

  @observable
  List<RacketCheckOutHistory> histories = new List<RacketCheckOutHistory>();

  @observable
  RacketMenuEnum currentMenu = RacketMenuEnum.AllRacketStatus;

  @observable
  bool loading = false;

  // actions:-------------------------------------------------------------------

  @action
  void tabChanged(RacketMenuEnum currentMenu) {
    this.currentMenu = currentMenu;
  }

  @action
  void refreshOnTabChange() {
    if (currentMenu == RacketMenuEnum.AllRacketStatus) {
      getRackets();
    } else if (currentMenu == RacketMenuEnum.AllHstr) {
      getWholeCheckOutHistories();
    } else {
      getUserCheckOutHistories();
    }
  }

  @action
  Future getRackets() async {
    if (loading) return;

    loading = true;
    Map<String, dynamic> params = {'type': 'list'};

    HttpClient.send(method: "GET", address: "/api/clear/racket", params: params)
        .then((response) {
          rackets = ConvertUtil.jsonArrayToObjectList(
              response, (json) => Racket.fromJson(json));
        })
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future getUserCheckOutHistories() async {
    if (loading) return;

    loading = true;
    Map<String, dynamic> params = {'type': 'histories', 'range': 'user'};

    HttpClient.send(method: "GET", address: "/api/clear/racket", params: params)
        .then((response) {
          histories = ConvertUtil.jsonArrayToObjectList(
              response, (json) => RacketCheckOutHistory.fromJson(json));
        })
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future getWholeCheckOutHistories() async {
    if (loading) return;

    loading = true;
    Map<String, dynamic> params = {'type': 'histories', 'range': 'whole'};

    HttpClient.send(method: "GET", address: "/api/clear/racket", params: params)
        .then((response) {
          histories = ConvertUtil.jsonArrayToObjectList(
              response, (json) => RacketCheckOutHistory.fromJson(json));
        })
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
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
  void updateOnError(String message) {
    errorStore.errorMessage = message;
    errorStore.error = true;
  }

  void updateOnSuccess(String message) {
    successStore.successMessage = message;
    successStore.success = true;
  }
}
