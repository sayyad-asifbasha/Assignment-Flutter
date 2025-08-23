import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Snackbar{
  static void success(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  static void error(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  static void warning(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.orange.withOpacity(0.6),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      icon: const Icon(Icons.warning, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  static String getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-verification-code':
      case 'invalid-code':
      case 'wrong-code':
        return "Invalid OTP. Please enter the correct OTP.";
      case 'session-expired':
        return "OTP expired. Please request a new one.";
      case 'too-many-requests':
        return "Too many attempts. Please try again later.";
      case 'user-disabled':
        return "This user has been disabled.";
      case 'network-request-failed':
        return "Network error. Check your internet connection.";
      default:
        return "An unexpected error occurred. Please try again.";
    }
  }
}
