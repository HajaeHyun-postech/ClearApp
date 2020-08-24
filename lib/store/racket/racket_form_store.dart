import 'package:clearApp/store/error/error_store.dart';
import 'package:clearApp/store/success/success_store.dart';
import 'package:clearApp/util/http_client.dart';
import 'package:mobx/mobx.dart';

part 'racket_form_store.g.dart';

class RacketFormStore = _RacketFormStore with _$RacketFormStore;

abstract class _RacketFormStore with Store {
  // other stores:--------------------------------------------------------------
  final ErrorStore errorStore = ErrorStore();
  final SuccessStore successStore = SuccessStore();

  // disposers:-----------------------------------------------------------------
  List<ReactionDisposer> disposers = [];

  // constructor:---------------------------------------------------------------

  // store variables:-----------------------------------------------------------
  @observable
  bool loading = false;

  // actions:-------------------------------------------------------------------
  @action
  void adaptiveTapEvent(bool isUserUsing, bool canCheckOut, int id) {
    if (isUserUsing) {
      checkInRacket(id);
    } else {
      if (canCheckOut) {
        checkOutRacket(id);
      } else {
        updateOnError("1인 1라켓");
      }
    }
  }

  @action
  Future checkOutRacket(int id) async {
    if (loading) return;
    loading = true;

    Map<String, dynamic> body = {'id': id};
    HttpClient.send(method: "POST", address: "/api/clear/racket", body: body)
        .then((response) {
          updateOnSuccess("Check Out Successful");
        })
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future checkInRacket(int id) async {
    if (loading) return;
    loading = true;

    Map<String, dynamic> body = {'id': id};
    HttpClient.send(method: "PATCH", address: "/api/clear/racket", body: body)
        .then((response) {
          updateOnSuccess("Check In Successful");
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
