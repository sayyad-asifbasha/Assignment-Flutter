import 'dart:ui';

import 'package:assignment/modules/authentication/models/user_model.dart';
import 'package:assignment/services/storage_service.dart';
import 'package:assignment/utils/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StorageService _storage = StorageService();

  String? _verificationId;

  Future<void> sendOtp(
      String phoneNumber, {
        required VoidCallback onCodeSent,
        required VoidCallback onVerificationFailed,
        required VoidCallback onVerificationCompleted,
      }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await _auth.signInWithCredential(credential);
          Snackbar.success("Auto Verified", "Logged in automatically");
          Get.offAllNamed("/home");
        } catch (e) {
          Snackbar.error("Error", e.toString());
        }
        onVerificationCompleted();
      },

      verificationFailed: (FirebaseAuthException e) {
        Snackbar.error("Error", e.message ?? "OTP verification failed");
        onVerificationFailed();
      },

      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        Snackbar.success("OTP Sent", "Please check your phone for the OTP");
        Get.toNamed("/OTP");
        onCodeSent();
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }


  Future<User?> verifyOtp(String otp) async {
    if (_verificationId == null) throw "No verification ID found. Please request OTP again.";

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      final userModel = UserModel(uid: user.uid, phone: user.phoneNumber);
      await _storage.saveUser(userModel);
    }
    return user;
  }

  UserModel? getLocalUser() => _storage.getUser();
  bool get isLoggedIn => _storage.hasUser();


  Future<void> signOut() async {
    await _auth.signOut();
    await _storage.clearUser();
  }
}
