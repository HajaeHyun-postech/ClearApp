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

  final _$getRemainingAsyncAction =
      AsyncAction('_ShuttleFormStore.getRemaining');

  @override
  Future<dynamic> getRemaining() {
    return _$getRemainingAsyncAction.run(() => super.getRemaining());
  }

  final _$_ShuttleFormStoreActionController =
      ActionController(name: '_ShuttleFormStore');

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
remaining: ${remaining}
    ''';
  }
}
