// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shuttle_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ShuttleStore on _ShuttleStore, Store {
  Computed<int> _$unconfirmedPriceComputed;

  @override
  int get unconfirmedPrice => (_$unconfirmedPriceComputed ??= Computed<int>(
          () => super.unconfirmedPrice,
          name: '_ShuttleStore.unconfirmedPrice'))
      .value;

  final _$historiesAtom = Atom(name: '_ShuttleStore.histories');

  @override
  List<ShuttleOrderHistory> get histories {
    _$historiesAtom.reportRead();
    return super.histories;
  }

  @override
  set histories(List<ShuttleOrderHistory> value) {
    _$historiesAtom.reportWrite(value, super.histories, () {
      super.histories = value;
    });
  }

  final _$loadingAtom = Atom(name: '_ShuttleStore.loading');

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

  final _$currentTabAtom = Atom(name: '_ShuttleStore.currentTab');

  @override
  TAB get currentTab {
    _$currentTabAtom.reportRead();
    return super.currentTab;
  }

  @override
  set currentTab(TAB value) {
    _$currentTabAtom.reportWrite(value, super.currentTab, () {
      super.currentTab = value;
    });
  }

  final _$getUsersHistoriesAsyncAction =
      AsyncAction('_ShuttleStore.getUsersHistories');

  @override
  Future<dynamic> getUsersHistories() {
    return _$getUsersHistoriesAsyncAction.run(() => super.getUsersHistories());
  }

  final _$getNotReceivedUsersHistoriesAsyncAction =
      AsyncAction('_ShuttleStore.getNotReceivedUsersHistories');

  @override
  Future<dynamic> getNotReceivedUsersHistories() {
    return _$getNotReceivedUsersHistoriesAsyncAction
        .run(() => super.getNotReceivedUsersHistories());
  }

  final _$getWholeUnconfirmedHistoriresAsyncAction =
      AsyncAction('_ShuttleStore.getWholeUnconfirmedHistorires');

  @override
  Future<dynamic> getWholeUnconfirmedHistorires() {
    return _$getWholeUnconfirmedHistoriresAsyncAction
        .run(() => super.getWholeUnconfirmedHistorires());
  }

  final _$receiveShuttleAsyncAction =
      AsyncAction('_ShuttleStore.receiveShuttle');

  @override
  Future<dynamic> receiveShuttle(List<int> idList, bool isReceived) {
    return _$receiveShuttleAsyncAction
        .run(() => super.receiveShuttle(idList, isReceived));
  }

  final _$confirmDepositAsyncAction =
      AsyncAction('_ShuttleStore.confirmDeposit');

  @override
  Future<dynamic> confirmDeposit(List<int> idList, bool isConfirmed) {
    return _$confirmDepositAsyncAction
        .run(() => super.confirmDeposit(idList, isConfirmed));
  }

  final _$deleteOrderAsyncAction = AsyncAction('_ShuttleStore.deleteOrder');

  @override
  Future<dynamic> deleteOrder(
      List<int> idList, bool isReceived, bool isConfirmed) {
    return _$deleteOrderAsyncAction
        .run(() => super.deleteOrder(idList, isReceived, isConfirmed));
  }

  final _$_ShuttleStoreActionController =
      ActionController(name: '_ShuttleStore');

  @override
  void tabChanged(TAB currentTab) {
    final _$actionInfo = _$_ShuttleStoreActionController.startAction(
        name: '_ShuttleStore.tabChanged');
    try {
      return super.tabChanged(currentTab);
    } finally {
      _$_ShuttleStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void refreshOnTabChange() {
    final _$actionInfo = _$_ShuttleStoreActionController.startAction(
        name: '_ShuttleStore.refreshOnTabChange');
    try {
      return super.refreshOnTabChange();
    } finally {
      _$_ShuttleStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic dispose() {
    final _$actionInfo = _$_ShuttleStoreActionController.startAction(
        name: '_ShuttleStore.dispose');
    try {
      return super.dispose();
    } finally {
      _$_ShuttleStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
histories: ${histories},
loading: ${loading},
currentTab: ${currentTab},
unconfirmedPrice: ${unconfirmedPrice}
    ''';
  }
}
