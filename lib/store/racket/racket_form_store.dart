import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../base_store.dart';

part 'racket_form_store.g.dart';

class RacketFormStore = _RacketFormStore with _$RacketFormStore;

abstract class _RacketFormStore extends BaseStore with Store {
  // other stores:--------------------------------------------------------------

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
        buttonColor = Colors.black;
      }
    } else {
      if (isAvailable) {
        buttonTapEvent = (id) => borrowRacket(id);
        buttonText = "Borrow";
        buttonColor = Color(0xFFCFCFC4);
      } else {
        buttonTapEvent = (id) => updateOnError("Not Available");
        buttonText = "Not Available";
        buttonColor = Colors.green;
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
    httpClient
        .send(method: "POST", address: "/v1/racket/histories", body: body)
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

    httpClient
        .send(method: "PATCH", address: "/v1/racket/histories/$racketId")
        .then((response) {
          updateOnSuccess("Return Successful");
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
