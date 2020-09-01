import 'package:clearApp/store/error/error_store.dart';
import 'package:clearApp/store/success/success_store.dart';

class BaseStore {
  // other stores:--------------------------------------------------------------
  final ErrorStore errorStore = ErrorStore();
  final SuccessStore successStore = SuccessStore();

  // disposers:-----------------------------------------------------------------

  // constructor:---------------------------------------------------------------

  // store variables:-----------------------------------------------------------

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
