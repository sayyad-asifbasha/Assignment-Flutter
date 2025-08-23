import 'package:get/get.dart';
import 'package:assignment/modules/authentication/controllers/login_controller.dart';
import 'package:assignment/modules/authentication/controllers/otp_controller.dart';
import 'package:assignment/services/authentication_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthenticationService>(() => AuthenticationService());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<OtpController>(() => OtpController());
  }
}
