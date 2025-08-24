import 'package:assignment/modules/home/models/product_model.dart';
import 'package:assignment/services/REST/api_url.dart';
import 'package:assignment/services/REST/dio_client.dart';
import 'package:assignment/utils/helpers/exception_handler.dart';
import 'package:assignment/utils/helpers/network_connectivity.dart';
import 'package:assignment/utils/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment/services/storage_service.dart';

class ProductDetailedController extends GetxController with ExceptionHandler {
  late final String originalId;

  final StorageService storageService = StorageService();

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  var productModel = ProductModel.empty().obs;
  RxBool isEditing = false.obs;

  final Map<String, TextEditingController> keyControllers = {};
  final Map<String, TextEditingController> valueControllers = {};
  final TextEditingController newKeyController = TextEditingController();
  final TextEditingController newValueController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments?['id'] == null) {
      Snackbar.error("Error", "No product ID provided");
      return;
    }
    originalId = Get.arguments['id'];
    fetchProductById(originalId);
    ever(productModel, (_) => _updateControllers());
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

  void _updateControllers() {
    final product = productModel.value;
    nameController.text = product.name;

    keyControllers.forEach((_, c) => c.dispose());
    valueControllers.forEach((_, c) => c.dispose());

    keyControllers.clear();
    valueControllers.clear();

    final data = product.data ?? {};
    data.forEach((key, value) {
      keyControllers[key] = TextEditingController(text: key);
      valueControllers[key] = TextEditingController(text: value.toString());
    });
  }

  void toggleEdit() {
    if (isEditing.value) {
      _updateControllers();
    }
    isEditing.value = !isEditing.value;
  }

  void addNewItem() {
    final newKey = newKeyController.text.trim();
    final newValue = newValueController.text.trim();
    if (newKey.isEmpty || newValue.isEmpty) {
      Get.snackbar("Error", "Both key and value must be entered");
      return;
    }

    // Check if newKey exists either in keys or values (keyControllers keys list)
    if (keyControllers.values.any((c) => c.text == newKey)) {
      Get.snackbar("Error", "Key already exists");
      return;
    }

    // Create new controllers for key and value
    final newKeyControllerInstance = TextEditingController(text: newKey);
    final newValueControllerInstance = TextEditingController(text: newValue);

    keyControllers[newKey] = newKeyControllerInstance;
    valueControllers[newKey] = newValueControllerInstance;

    newKeyController.clear();
    newValueController.clear();

    update();
  }


  void handleUpdate() {
    final updatedData = <String, dynamic>{};
    final newKeysSet = <String>{};
    bool hasDuplicateKeys = false;

    keyControllers.forEach((oldKey, keyController) {
      final newKey = keyController.text.trim();
      final valueController = valueControllers[oldKey];
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

    final latestId = storageService.getLatestProductId(originalId);

    if (latestId != null && latestId != originalId) {
      // There is already an updated version => update the existing product
      updateExistingProduct(latestId, updatedName, updatedData);
    } else {
      // No updated version => create a new product
      createNewProduct(updatedName, updatedData);
    }
    isEditing.value=false;
  }

  Future<void> updateExistingProduct(String id, String name, Map<String, dynamic> data) async {
    try {
      final response = await Dio().put(ApiUrl.updateObject(id),
        data: {
          "name": name,
          "data": data,
        },
      );

      Snackbar.success("Success", "Updated product with id $id");
      fetchProductById(originalId);
      isEditing.value=false;
    } catch (e, stack) {
      if (e is DioException) {
        handleError(e);
      } else {
        debugPrint("Unexpected error: $e");
        debugPrintStack(stackTrace: stack);
      }
    }
  }



  Future<void> fetchProductById(String originalId) async {
    isLoading.value = true;
    isError.value = false;
    final latestId = storageService.getLatestProductId(originalId) ?? originalId;
    if (await NetworkConnectivity.isNetworkAvailable()) {
      try {
        final response = await DioClient().get(url: ApiUrl.singleObject(latestId));
        if (response == null) {
          isLoading.value = false;
          return;
        }
        productModel.value = ProductModel.fromJson(response);
      } catch (error) {
        handleError(error);
        isError.value = true;
      }
    } else {
      Snackbar.error("Error", "No Network & No Cached Data");
      NetworkConnectivity.connectionChangeCount = 1;
      isError.value = true;
    }
    isLoading.value = false;
  }

  /// Create a new product with updated data and update ID mapping
  Future<void> createNewProduct(String name, Map<String, dynamic> data) async {
    try {
      final response = await Dio().post(
        "https://api.restful-api.dev/objects",
        data: {
          "name": name,
          "data": data,
        },
      );
      final newId = response.data["id"];
      await storageService.updateProductIdMap(originalId, newId);

      Snackbar.success("Success", "Created with id $newId");
      fetchProductById(originalId);
    } catch (e, stack) {
      if (e is DioException) {
        handleError(e);
      } else {
        debugPrint("Unexpected error: $e");
        debugPrintStack(stackTrace: stack);
      }
    }
  }
}

