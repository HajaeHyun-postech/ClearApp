import 'package:clearApp/contants/globals.dart';
import 'package:clearApp/service/http_client.dart';
import 'package:clearApp/store/error/error_store.dart';
import 'package:clearApp/store/success/success_store.dart';

class BaseClientStore {
  // other stores:--------------------------------------------------------------
  final ErrorStore errorStore = ErrorStore();
  final SuccessStore successStore = SuccessStore();

  // disposers:-----------------------------------------------------------------

  // constructor:---------------------------------------------------------------

  // store variables:-----------------------------------------------------------

  // other variables:-----------------------------------------------------------
  final httpClient = locator<HttpClient>();

  // dispose:-------------------------------------------------------------------
  dispose() {
    errorStore.dispose();
    successStore.dispose();
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
