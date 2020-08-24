// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'racket_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RacketStore on _RacketStore, Store {
  Computed<bool> _$canCheckOutComputed;

  @override
  bool get canCheckOut =>
      (_$canCheckOutComputed ??= Computed<bool>(() => super.canCheckOut,
              name: '_RacketStore.canCheckOut'))
          .value;

  final _$racketsAtom = Atom(name: '_RacketStore.rackets');

  @override
  List<Racket> get rackets {
    _$racketsAtom.reportRead();
    return super.rackets;
  }

  @override
  set rackets(List<Racket> value) {
    _$racketsAtom.reportWrite(value, super.rackets, () {
      super.rackets = value;
    });
  }

  final _$historiesAtom = Atom(name: '_RacketStore.histories');

  @override
  List<RacketCheckOutHistory> get histories {
    _$historiesAtom.reportRead();
    return super.histories;
  }

  @override
  set histories(List<RacketCheckOutHistory> value) {
    _$historiesAtom.reportWrite(value, super.histories, () {
      super.histories = value;
    });
  }

  final _$currentMenuAtom = Atom(name: '_RacketStore.currentMenu');

  @override
  RacketMenuEnum get currentMenu {
    _$currentMenuAtom.reportRead();
    return super.currentMenu;
  }

  @override
  set currentMenu(RacketMenuEnum value) {
    _$currentMenuAtom.reportWrite(value, super.currentMenu, () {
      super.currentMenu = value;
    });
  }

  final _$loadingAtom = Atom(name: '_RacketStore.loading');

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

  final _$userUsingRacketIdAtom = Atom(name: '_RacketStore.userUsingRacketId');

  @override
  int get userUsingRacketId {
    _$userUsingRacketIdAtom.reportRead();
    return super.userUsingRacketId;
  }

  @override
  set userUsingRacketId(int value) {
    _$userUsingRacketIdAtom.reportWrite(value, super.userUsingRacketId, () {
      super.userUsingRacketId = value;
    });
  }

  final _$getRacketsAsyncAction = AsyncAction('_RacketStore.getRackets');

  @override
  Future<dynamic> getRackets() {
    return _$getRacketsAsyncAction.run(() => super.getRackets());
  }

  final _$getUserCheckOutHistoriesAsyncAction =
      AsyncAction('_RacketStore.getUserCheckOutHistories');

  @override
  Future<dynamic> getUserCheckOutHistories() {
    return _$getUserCheckOutHistoriesAsyncAction
        .run(() => super.getUserCheckOutHistories());
  }

  final _$getWholeCheckOutHistoriesAsyncAction =
      AsyncAction('_RacketStore.getWholeCheckOutHistories');

  @override
  Future<dynamic> getWholeCheckOutHistories() {
    return _$getWholeCheckOutHistoriesAsyncAction
        .run(() => super.getWholeCheckOutHistories());
  }

  final _$_RacketStoreActionController = ActionController(name: '_RacketStore');

  @override
  bool verifyDuplicateRent() {
    final _$actionInfo = _$_RacketStoreActionController.startAction(
        name: '_RacketStore.verifyDuplicateRent');
    try {
      return super.verifyDuplicateRent();
    } finally {
      _$_RacketStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void tabChanged(RacketMenuEnum currentMenu) {
    final _$actionInfo = _$_RacketStoreActionController.startAction(
        name: '_RacketStore.tabChanged');
    try {
      return super.tabChanged(currentMenu);
    } finally {
      _$_RacketStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void refreshOnTabChange() {
    final _$actionInfo = _$_RacketStoreActionController.startAction(
        name: '_RacketStore.refreshOnTabChange');
    try {
      return super.refreshOnTabChange();
    } finally {
      _$_RacketStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic dispose() {
    final _$actionInfo = _$_RacketStoreActionController.startAction(
        name: '_RacketStore.dispose');
    try {
      return super.dispose();
    } finally {
      _$_RacketStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
rackets: ${rackets},
histories: ${histories},
currentMenu: ${currentMenu},
loading: ${loading},
userUsingRacketId: ${userUsingRacketId},
canCheckOut: ${canCheckOut}
    ''';
  }
}
