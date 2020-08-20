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

  final _$successAtom = Atom(name: '_ShuttleStore.success');

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
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
  Future<dynamic> receiveShuttle(List<int> idList) {
    return _$receiveShuttleAsyncAction.run(() => super.receiveShuttle(idList));
  }

  final _$confirmDepositAsyncAction =
      AsyncAction('_ShuttleStore.confirmDeposit');

  @override
  Future<dynamic> confirmDeposit(List<int> idList) {
    return _$confirmDepositAsyncAction.run(() => super.confirmDeposit(idList));
  }

  final _$_ShuttleStoreActionController =
      ActionController(name: '_ShuttleStore');

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
success: ${success},
unconfirmedPrice: ${unconfirmedPrice}
    ''';
  }
}
