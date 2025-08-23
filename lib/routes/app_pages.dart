import 'package:assignment/modules/home/bindings/home_bindings.dart';
import 'package:assignment/modules/home/views/home_screen.dart';
import 'package:assignment/modules/splash/views/splash_screen.dart';
import 'package:get/get.dart';

import 'package:assignment/modules/authentication/bindings/authentication_binding.dart';
import 'package:assignment/modules/authentication/views/login_screen.dart';
import 'package:assignment/modules/authentication/views/otp_screen.dart';

part 'app_routes.dart'; // <- connect with app_routes.dart

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH; // first screen


  static final routes = [
    GetPage(
        name: _Paths.SPLASH,
        page: ()=> const SplashScreen()
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () =>  HomeScreen(),
      binding:HomeBinding(),
    ),
  ];
}