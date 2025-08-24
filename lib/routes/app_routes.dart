part of 'app_pages.dart';

abstract class Routes {
  Routes._(); // private constructor

  static const LOGIN = _Paths.LOGIN;
  static const OTP=_Paths.OTP;
  static const HOME = _Paths.HOME;
  static const SPLASH=_Paths.SPLASH;
  static const DETAILED=_Paths.DETAILED;
  static const ADD=_Paths.ADD;

}

abstract class _Paths {
  _Paths._();

  static const SPLASH='/';
  static const LOGIN = '/login';
  static const OTP='/OTP';
  static const HOME = '/home';
  static const DETAILED = '/detailed';
  static const ADD = '/add';

}
