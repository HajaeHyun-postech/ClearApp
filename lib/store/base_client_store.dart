import 'package:clearApp/contants/globals.dart';
import 'package:clearApp/service/http_client_service.dart';
import 'package:clearApp/store/error/error_store.dart';
import 'package:clearApp/store/success/success_store.dart';

class BaseClientStore {
  // other stores:--------------------------------------------------------------
  final ErrorStore _errorStore = ErrorStore();
  final SuccessStore _successStore = SuccessStore();

  // disposers:-----------------------------------------------------------------

  // constructor:---------------------------------------------------------------

  // store variables:-----------------------------------------------------------

  // other variables:-----------------------------------------------------------
  final httpClient = locator<HttpClientService>();
  List<Function> _successCallback = List();
  List<Function> _errorCallback = List();

  // dispose:-------------------------------------------------------------------
  dispose() {
    _errorStore.dispose();
    _successStore.dispose();
  }

  // functions:-----------------------------------------------------------------
  void addSuccessCallback(List<Function> f) {
    _successCallback.addAll(f);
  }

  void addErrorCallback(List<Function> f) {
    _errorCallback.addAll(f);
  }

  void error(String message) {
    _errorStore.errorMessage = message;
    _errorStore.error = true;
    _errorCallback.forEach((f) => f.call());
  }

  void success(String message) {
    _successStore.successMessage = message;
    _successStore.success = true;
    _successCallback.forEach((f) => f.call());
  }
}
