import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment/services/authentication_service.dart';
import 'package:assignment/utils/widgets/snackbar.dart';

class OtpController extends GetxController {
  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes =
  List.generate(6, (_) => FocusNode());

  final isLoading = false.obs;
  final AuthenticationService authenticationService =
  Get.find<AuthenticationService>();

  String get otp => controllers.map((c) => c.text).join();

  void onInputChange(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> submitOtp() async {
    if (otp.length != 6) {
      Snackbar.warning("Invalid OTP", "Please enter all 6 digits");
      return;
    }

    try {
      isLoading.value = true;
      final user = await authenticationService.verifyOtp(otp);
      if (user != null) {
        Snackbar.success("Success", "OTP Verified Successfully");
        Get.offAllNamed("/home");
      } else {
        Snackbar.error("Error", "OTP verification failed");
      }
    } catch (e) {
      String errorMessage = "An error occurred";
      if (e is FirebaseAuthException) {
        errorMessage = Snackbar.getFirebaseErrorMessage(e.code);
      } else if (e.toString().contains("invalid-verification-code")) {
        errorMessage = Snackbar.getFirebaseErrorMessage("invalid-verification-code");
      } else {
        errorMessage = e.toString();
      }
      Snackbar.error("Error", errorMessage);
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onClose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}
