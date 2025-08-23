import 'package:get/get.dart';
import 'package:assignment/services/storage_service.dart';

class SplashController extends GetxController {
  final StorageService storage = StorageService();

  @override
  void onReady() {
    super.onReady();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));

    if (storage.hasUser()) {
      Get.offAllNamed("/home");
    } else {
      Get.offAllNamed("/login");
    }
  }
}
