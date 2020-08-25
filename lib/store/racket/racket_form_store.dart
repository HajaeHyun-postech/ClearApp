import 'package:clearApp/store/error/error_store.dart';
import 'package:clearApp/store/success/success_store.dart';
import 'package:clearApp/util/http_client.dart';
import 'package:flutter/material.dart';
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
  _RacketFormStore({bool isBorrowLimit, bool isReturn, bool isAvailable}) {
    if (isBorrowLimit) {
      if (isReturn) {
        buttonTapEvent = (id) => returnRacket(id);
        buttonText = "Retun Now";
        buttonColor = Color(0xFFCFCFC4);
      } else {
        buttonTapEvent = (id) => updateOnError("Borrow Limit");
        buttonText = "Borrow Limit (1 per person)";
        buttonColor = Colors.transparent;
      }
    } else {
      if (isAvailable) {
        buttonTapEvent = (id) => borrowRacket(id);
        buttonText = "Borrow";
        buttonColor = Color(0xFFCFCFC4);
      } else {
        buttonTapEvent = (id) => updateOnError("Not Available");
        buttonText = "Not Available";
        buttonColor = Colors.transparent;
      }
    }
  }

  // store variables:-----------------------------------------------------------
  @observable
  bool loading = false;

  // other variables:-----------------------------------------------------------
  Function buttonTapEvent;
  String buttonText;
  Color buttonColor;

  // actions:-------------------------------------------------------------------
  @action
  Future borrowRacket(int racketId) async {
    if (loading) return;
    loading = true;

    Map<String, dynamic> body = {'id': racketId};
    HttpClient.send(method: "POST", address: "/api/clear/racket", body: body)
        .then((response) {
          updateOnSuccess("Borrow Successful");
        })
        .catchError((e) => updateOnError(e.cause))
        .whenComplete(() => loading = false);
  }

  @action
  Future returnRacket(int racketId) async {
    if (loading) return;
    loading = true;

    Map<String, dynamic> body = {'id': racketId};
    HttpClient.send(method: "PATCH", address: "/api/clear/racket", body: body)
        .then((response) {
          updateOnSuccess("Return Successful");
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
