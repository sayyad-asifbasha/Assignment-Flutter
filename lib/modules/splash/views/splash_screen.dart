import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment/utils/responsive.dart';
import 'package:assignment/modules/splash/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // initialize controller
    Get.put(SplashController());

    return Scaffold(
      body: SafeArea(
        child: maxWidthConstrained(
          maxWidth: 600,
          child: Padding(
            padding: EdgeInsets.all(responsivePadding(context)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FlutterLogo(size: 100),
                  const SizedBox(height: 20),
                  Text(
                    "My App",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
