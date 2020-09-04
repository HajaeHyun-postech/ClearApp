import 'package:clearApp/store/base_client_store.dart';
import 'package:clearApp/util/convert_util.dart';
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

abstract class _RacketStore extends BaseClientStore with Store {
  // other stores:--------------------------------------------------------------

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

  @observable
  bool isBorrowLimit = false;

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
      getHistories(range: "all");
    } else {
      getHistories();
    }
  }

  @action
  Future getRackets() async {
    if (loading) return;
    loading = true;

    httpClient
        .send(method: "GET", address: "/v1/racket/rackets")
        .then((response) {
          rackets = ConvertUtil.jsonArrayToObjectList(
              response['rackets'], (json) => Racket.fromJson(json));
          isBorrowLimit = response['isBorrowLimit'];
        })
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future getHistories(
      {bool returned, bool overdue, String range = "me"}) async {
    if (loading) return;
    loading = true;

    Map<String, dynamic> params = {};
    if (returned != null) {
      params.putIfAbsent('returned', () => returned);
    }
    if (overdue != null) {
      params.putIfAbsent('overdue', () => overdue);
    }

    httpClient
        .send(
            method: "GET",
            address: "/v1/racket/histories/$range",
            params: params)
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
    super.dispose();
    for (final d in disposers) {
      d();
    }
  }

  // functions:-----------------------------------------------------------------
}
