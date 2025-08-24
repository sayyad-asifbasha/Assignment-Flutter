import 'package:assignment/modules/home/models/product_model.dart';
import 'package:assignment/services/REST/api_url.dart';
import 'package:assignment/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment/utils/helpers/exception_handler.dart';
import 'package:assignment/utils/widgets/snackbar.dart';
import 'package:dio/dio.dart';

class AddProductController extends GetxController with ExceptionHandler {
  RxBool isLoading = false.obs;

  final StorageService storageService = StorageService();
  final Map<String, TextEditingController> keyControllers = {};
  final Map<String, TextEditingController> valueControllers = {};
  final TextEditingController newKeyController = TextEditingController();
  final TextEditingController newValueController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  void addNewItem() {
    final newKey = newKeyController.text.trim();
    final newValue = newValueController.text.trim();

    if (newKey.isEmpty || newValue.isEmpty) {
      Get.snackbar("Error", "Both key and value must be entered");
      return;
    }

    if (keyControllers.values.any((c) => c.text == newKey)) {
      Get.snackbar("Error", "Key already exists");
      return;
    }

    keyControllers[newKey] = TextEditingController(text: newKey);
    valueControllers[newKey] = TextEditingController(text: newValue);

    newKeyController.clear();
    newValueController.clear();

    update();
  }

  void removeItem(String key) {
    keyControllers[key]?.dispose();
    valueControllers[key]?.dispose();
    keyControllers.remove(key);
    valueControllers.remove(key);
    update();
  }

  void handleCreateProduct() async {
    final updatedData = <String, dynamic>{};
    final newKeysSet = <String>{};
    bool hasDuplicateKeys = false;

    keyControllers.forEach((key, keyController) {
      final newKey = keyController.text.trim();
      final valueController = valueControllers[key];
      final newValue = valueController?.text.trim() ?? '';

      if (newKeysSet.contains(newKey)) {
        hasDuplicateKeys = true;
        return;
      }
      newKeysSet.add(newKey);

      if (newKey.isNotEmpty) {
        updatedData[newKey] = newValue;
      }
    });

    if (hasDuplicateKeys) {
      Get.snackbar("Error", "Duplicate keys are not allowed");
      return;
    }

    final updatedName = nameController.text.trim();
    if (updatedName.isEmpty) {
      Get.snackbar("Error", "Product name cannot be empty");
      return;
    }

    isLoading.value = true;

    try {
      final response = await Dio().post(
        ApiUrl.addObject(),
        data: {
          "name": updatedName,
          "data": updatedData,
        },
      );

      final newId = response.data["id"];
      final newProduct = ProductModel(
        id: newId,
        name: updatedName,
        data: updatedData,
      );

      final existingProducts = storageService.getProducts();
      final updatedProducts = [...existingProducts, newProduct];
      await storageService.saveProducts(updatedProducts);


      Snackbar.success("Success", "Created product with id $newId");

      // Clear inputs & controllers
      nameController.clear();
      keyControllers.forEach((_, c) => c.dispose());
      valueControllers.forEach((_, c) => c.dispose());
      keyControllers.clear();
      valueControllers.clear();

      update();


    } catch (e, stack) {
      if (e is DioException) {
        handleError(e);
      } else {
        debugPrint("Unexpected error: $e");
        debugPrintStack(stackTrace: stack);
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    newKeyController.dispose();
    newValueController.dispose();
    keyControllers.forEach((_, c) => c.dispose());
    valueControllers.forEach((_, c) => c.dispose());
    super.onClose();
  }
}
