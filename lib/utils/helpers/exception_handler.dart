import 'package:assignment/services/REST/api_exception.dart';
import 'package:assignment/utils/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';


mixin class ExceptionHandler {
  RxBool isError = false.obs;

  /// FOR REST API
  void handleError(error) {
    isError.value = true;

    var errorText = DioExceptions.fromDioError(error).toString();
    showErrorDialog("Oh, no...", errorText);

    Logger().e(errorText);
  }




  showErrorDialog(String title, String message) {
    /// for toast view
    Snackbar.error(title, message);

    /// for dialog view
    // DialogHelper.showErrorDialog(title, message);
  }
}
