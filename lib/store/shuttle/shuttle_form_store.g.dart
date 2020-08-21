// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shuttle_form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ShuttleFormStore on _ShuttleFormStore, Store {
  final _$loadingAtom = Atom(name: '_ShuttleFormStore.loading');

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

  final _$successAtom = Atom(name: '_ShuttleFormStore.success');

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

  final _$invalidAmountAtom = Atom(name: '_ShuttleFormStore.invalidAmount');

  @override
  bool get invalidAmount {
    _$invalidAmountAtom.reportRead();
    return super.invalidAmount;
  }

  @override
  set invalidAmount(bool value) {
    _$invalidAmountAtom.reportWrite(value, super.invalidAmount, () {
      super.invalidAmount = value;
    });
  }

  final _$invalidUsageAtom = Atom(name: '_ShuttleFormStore.invalidUsage');

  @override
  bool get invalidUsage {
    _$invalidUsageAtom.reportRead();
    return super.invalidUsage;
  }

  @override
  set invalidUsage(bool value) {
    _$invalidUsageAtom.reportWrite(value, super.invalidUsage, () {
      super.invalidUsage = value;
    });
  }

  final _$remainingAtom = Atom(name: '_ShuttleFormStore.remaining');

  @override
  int get remaining {
    _$remainingAtom.reportRead();
    return super.remaining;
  }

  @override
  set remaining(int value) {
    _$remainingAtom.reportWrite(value, super.remaining, () {
      super.remaining = value;
    });
  }

  final _$amountAtom = Atom(name: '_ShuttleFormStore.amount');

  @override
  int get amount {
    _$amountAtom.reportRead();
    return super.amount;
  }

  @override
  set amount(int value) {
    _$amountAtom.reportWrite(value, super.amount, () {
      super.amount = value;
    });
  }

  final _$usageStringAtom = Atom(name: '_ShuttleFormStore.usageString');

  @override
  String get usageString {
    _$usageStringAtom.reportRead();
    return super.usageString;
  }

  @override
  set usageString(String value) {
    _$usageStringAtom.reportWrite(value, super.usageString, () {
      super.usageString = value;
    });
  }

  final _$getRemainingAsyncAction =
      AsyncAction('_ShuttleFormStore.getRemaining');

  @override
  Future<dynamic> getRemaining() {
    return _$getRemainingAsyncAction.run(() => super.getRemaining());
  }

  final _$addOrderAsyncAction = AsyncAction('_ShuttleFormStore.addOrder');

  @override
  Future<dynamic> addOrder() {
    return _$addOrderAsyncAction.run(() => super.addOrder());
  }

  final _$_ShuttleFormStoreActionController =
      ActionController(name: '_ShuttleFormStore');

  @override
  void setUsageString(String usage) {
    final _$actionInfo = _$_ShuttleFormStoreActionController.startAction(
        name: '_ShuttleFormStore.setUsageString');
    try {
      return super.setUsageString(usage);
    } finally {
      _$_ShuttleFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void incrementAmount() {
    final _$actionInfo = _$_ShuttleFormStoreActionController.startAction(
        name: '_ShuttleFormStore.incrementAmount');
    try {
      return super.incrementAmount();
    } finally {
      _$_ShuttleFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decrementAmount() {
    final _$actionInfo = _$_ShuttleFormStoreActionController.startAction(
        name: '_ShuttleFormStore.decrementAmount');
    try {
      return super.decrementAmount();
    } finally {
      _$_ShuttleFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$_ShuttleFormStoreActionController.startAction(
        name: '_ShuttleFormStore.reset');
    try {
      return super.reset();
    } finally {
      _$_ShuttleFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic dispose() {
    final _$actionInfo = _$_ShuttleFormStoreActionController.startAction(
        name: '_ShuttleFormStore.dispose');
    try {
      return super.dispose();
    } finally {
      _$_ShuttleFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
success: ${success},
invalidAmount: ${invalidAmount},
invalidUsage: ${invalidUsage},
remaining: ${remaining},
amount: ${amount},
usageString: ${usageString}
    ''';
  }
}
