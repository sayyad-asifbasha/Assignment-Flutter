import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:assignment/modules/authentication/controllers/otp_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OtpController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.06, // responsive padding
              vertical: Get.height * 0.12,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.05),

                Text(
                  "Verify Your Identity",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Get.height * 0.015),

                Text(
                  "Enter the 6-digit code we sent to your phone number.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Get.height * 0.05),

                /// OTP Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: Get.width * 0.14,
                      child: TextField(
                        controller: controller.controllers[index],
                        focusNode: controller.focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: Theme.of(context).textTheme.titleMedium,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: Colors.grey.shade200,
                        ),
                        onChanged: (value) =>
                            controller.onInputChange(value, index),
                      ),
                    );
                  }),
                ),

                SizedBox(height: Get.height * 0.07),

                Obx(
                  () => ElevatedButton(
                    onPressed: () async {
                      controller.isLoading.value
                          ? null
                          : controller.submitOtp();
                    },
                    child: SizedBox(
                      height: Get.height * 0.04,
                      width: Get.width * 0.3,
                      child: Center(
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 40,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text("Verify"),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Get.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
