import 'package:assignment/utils/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:assignment/services/authentication_service.dart';

class LoginController extends GetxController {
  final phoneController = "".obs;
  final isLoading = false.obs;

  final AuthenticationService _authService = Get.find<AuthenticationService>();

  bool _isValidPhone(String phone) {
    final RegExp phoneRegExp = RegExp(r'^[6-9]\d{9}$');
    return phoneRegExp.hasMatch(phone);
  }

  Future<void> sendOtp() async {
    String phoneNumber = phoneController.value.trim();

    if (phoneNumber.isEmpty) {
      Snackbar.warning("Invalid Phone", "Please enter your phone number");
      return;
    }
    if (!_isValidPhone(phoneNumber)) {
      Snackbar.warning("Invalid Phone", "Please enter a valid 10-digit Indian phone number");
      return;
    }

    try {
      isLoading.value = true;
      String fullPhoneNumber = "+91$phoneNumber";

      await _authService.sendOtp(
        fullPhoneNumber,
        onCodeSent: () {
          isLoading.value = false;
        },
        onVerificationFailed: () {
          isLoading.value = false;
        },
        onVerificationCompleted: () {
          isLoading.value = false;
        },
      );

    } catch (e) {
      isLoading.value = false;
      String errorMessage = "An error occurred";
      if (e is FirebaseAuthException) {
        errorMessage = Snackbar.getFirebaseErrorMessage(e.code);
      } else {
        errorMessage = e.toString();
      }
      Snackbar.error("Error", errorMessage);
    }
  }

}
