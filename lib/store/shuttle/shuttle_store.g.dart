// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shuttle_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ShuttleStore on _ShuttleStore, Store {
  Computed<List<ShuttleOrderHistory>> _$usersNotReceivedHistoriesComputed;

  @override
  List<ShuttleOrderHistory> get usersNotReceivedHistories =>
      (_$usersNotReceivedHistoriesComputed ??=
              Computed<List<ShuttleOrderHistory>>(
                  () => super.usersNotReceivedHistories,
                  name: '_ShuttleStore.usersNotReceivedHistories'))
          .value;
  Computed<int> _$usersUnconfirmedPriceComputed;

  @override
  int get usersUnconfirmedPrice => (_$usersUnconfirmedPriceComputed ??=
          Computed<int>(() => super.usersUnconfirmedPrice,
              name: '_ShuttleStore.usersUnconfirmedPrice'))
      .value;
  Computed<int> _$wholeUnconfirmedPriceComputed;

  @override
  int get wholeUnconfirmedPrice => (_$wholeUnconfirmedPriceComputed ??=
          Computed<int>(() => super.wholeUnconfirmedPrice,
              name: '_ShuttleStore.wholeUnconfirmedPrice'))
      .value;

  final _$usersHistoriesAtom = Atom(name: '_ShuttleStore.usersHistories');

  @override
  List<ShuttleOrderHistory> get usersHistories {
    _$usersHistoriesAtom.reportRead();
    return super.usersHistories;
  }

  @override
  set usersHistories(List<ShuttleOrderHistory> value) {
    _$usersHistoriesAtom.reportWrite(value, super.usersHistories, () {
      super.usersHistories = value;
    });
  }

  final _$wholeUnconfirmedHistoriresAtom =
      Atom(name: '_ShuttleStore.wholeUnconfirmedHistorires');

  @override
  List<ShuttleOrderHistory> get wholeUnconfirmedHistorires {
    _$wholeUnconfirmedHistoriresAtom.reportRead();
    return super.wholeUnconfirmedHistorires;
  }

  @override
  set wholeUnconfirmedHistorires(List<ShuttleOrderHistory> value) {
    _$wholeUnconfirmedHistoriresAtom
        .reportWrite(value, super.wholeUnconfirmedHistorires, () {
      super.wholeUnconfirmedHistorires = value;
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
  Future<dynamic> receiveShuttle(int id) {
    return _$receiveShuttleAsyncAction.run(() => super.receiveShuttle(id));
  }

  final _$confirmDepositAsyncAction =
      AsyncAction('_ShuttleStore.confirmDeposit');

  @override
  Future<dynamic> confirmDeposit(int id) {
    return _$confirmDepositAsyncAction.run(() => super.confirmDeposit(id));
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
usersHistories: ${usersHistories},
wholeUnconfirmedHistorires: ${wholeUnconfirmedHistorires},
loading: ${loading},
success: ${success},
usersNotReceivedHistories: ${usersNotReceivedHistories},
usersUnconfirmedPrice: ${usersUnconfirmedPrice},
wholeUnconfirmedPrice: ${wholeUnconfirmedPrice}
    ''';
  }
}
