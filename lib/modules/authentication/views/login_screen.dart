import 'package:assignment/modules/authentication/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: Get.width * 0.05,
              right: Get.width * 0.05,
              top: Get.height * 0.15,
              bottom: Get.height * 0.1,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let’s Get You Signed In ",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: Get.height * 0.02),

                Text(
                  "Enter your phone number to receive a one-time verification code. ",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                SizedBox(height: Get.height * 0.1),
                Center(
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(hintText: "Phone Number"),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) =>
                            controller.phoneController.value = value,
                      ),
                      SizedBox(height: Get.height * 0.04),
                      Obx(
                        () => ElevatedButton(
                          onPressed: () async{
                            controller.isLoading.value ? null : controller.sendOtp();
                          },
                          child: SizedBox(
                            height: Get.height*0.04,
                            width: Get.width*0.3,
                            child: Center(
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                height: 40,
                                child: CircularProgressIndicator(color: Colors.white,strokeWidth: 3,),
                              ): const Text("Send OTP"),
                            ),
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
