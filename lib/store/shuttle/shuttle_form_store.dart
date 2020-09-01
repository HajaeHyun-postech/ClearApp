import 'package:mobx/mobx.dart';

import '../../util/http_client.dart';
import '../base_store.dart';

part 'shuttle_form_store.g.dart';

class ShuttleFormStore = _ShuttleFormStore with _$ShuttleFormStore;

abstract class _ShuttleFormStore extends BaseStore with Store {
  // other stores:--------------------------------------------------------------

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
  bool invalidAmount = false;

  @observable
  int remaining = 0;

  @observable
  int amount = 1;

  @observable
  String usageString = '';

  @observable
  int price = 15000;

  @observable
  int amountAdd = 30;

  // actions:-------------------------------------------------------------------
  @action
  Future getRemaining() async {
    if (loading) return;
    loading = true;

    HttpClient.send(method: "GET", address: "/v1/shuttle/shuttles")
        .then((response) {
          remaining = response['remaining'];
        })
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future buyShuttle() async {
    if (usageString == '') {
      updateOnError("Usage가 없습니다");
      return;
    }
    if (loading) return;
    loading = true;

    Map<String, dynamic> body = {'amount': amount, 'usage': usageString};
    HttpClient.send(method: "POST", address: "/v1/shuttle/orders", body: body)
        .then((response) {
          updateOnSuccess("Ordered Successfully");
        })
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future addShuttle() async {
    if (loading) return;
    loading = true;

    Map<String, dynamic> params = {'type': 'add'};
    Map<String, dynamic> body = {'amount': amountAdd, 'price': price};
    HttpClient.send(
            method: "POST",
            address: "/api/clear/shuttle",
            params: params,
            body: body)
        .then((response) {
          updateOnSuccess("Added Successfully");
        })
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
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
    super.dispose();
    for (final d in disposers) {
      d();
    }
  }

  // functions:-----------------------------------------------------------------
}
