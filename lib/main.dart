import 'package:assignment/utils/helpers/network_connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:assignment/config/theme/app_theme.dart';
import 'package:assignment/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  runApp(const MyApp());
  NetworkConnectivity.initConnectivityListener();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final width = mediaQuery.size.width;
        // Reduce text scale on web with stepped breakpoints to avoid oversized typography.
        double scale = 1.0;
        if (kIsWeb) {
          if (width >= 1920) {
            scale = 0.75;
          } else if (width >= 1600) {
            scale = 0.80;
          } else if (width >= 1200) {
            scale = 0.85;
          } else if (width >= 1024) {
            scale = 0.90;
          }
        }
        final textScaler = TextScaler.linear(scale);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: textScaler),
          child: GetMaterialApp(
            title: 'Assignment',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
          ),
        );
      },
    );
  }
}
