// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'racket_form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RacketFormStore on _RacketFormStore, Store {
  final _$loadingAtom = Atom(name: '_RacketFormStore.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$checkOutRacketAsyncAction =
      AsyncAction('_RacketFormStore.checkOutRacket');

  @override
  Future<dynamic> checkOutRacket(int racketId) {
    return _$checkOutRacketAsyncAction
        .run(() => super.checkOutRacket(racketId));
  }

  final _$checkInRacketAsyncAction =
      AsyncAction('_RacketFormStore.checkInRacket');

  @override
  Future<dynamic> checkInRacket(int id) {
    return _$checkInRacketAsyncAction.run(() => super.checkInRacket(id));
  }

  final _$_RacketFormStoreActionController =
      ActionController(name: '_RacketFormStore');

  @override
  void adaptiveTapEvent(
      bool isUserUsing, bool canCheckOut, int historyId, int racketId) {
    final _$actionInfo = _$_RacketFormStoreActionController.startAction(
        name: '_RacketFormStore.adaptiveTapEvent');
    try {
      return super
          .adaptiveTapEvent(isUserUsing, canCheckOut, historyId, racketId);
    } finally {
      _$_RacketFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic dispose() {
    final _$actionInfo = _$_RacketFormStoreActionController.startAction(
        name: '_RacketFormStore.dispose');
    try {
      return super.dispose();
    } finally {
      _$_RacketFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading}
    ''';
  }
}
