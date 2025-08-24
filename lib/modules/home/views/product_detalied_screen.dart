import 'package:assignment/modules/home/controllers/product_detailed_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsScreen extends StatelessWidget {
  final dynamic id;
  const ProductDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductDetailedController controller = Get.find<ProductDetailedController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isLoading.value
              ? "Loading..."
              : controller.productModel.value.name.isEmpty
              ? "Product Details"
              : controller.productModel.value.name,
        )),
        elevation: 0,
        actions: [
          Obx(() => IconButton(
            icon: Icon(controller.isEditing.value ? Icons.cancel : Icons.edit),
            onPressed: controller.toggleEdit,
            tooltip: controller.isEditing.value ? "Cancel Editing" : "Edit",
          )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.productModel.value.id.isEmpty) {
          // Initial loading (only when no data yet)
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.isError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 60),
                const SizedBox(height: 10),
                const Text("Failed to load product details",
                    style: TextStyle(fontSize: 18, color: Colors.red)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => controller.fetchProductById(controller.originalId),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        final product = controller.productModel.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF124C2F), Color(0xFFC7DED3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.shopping_bag, size: 60, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // Editable Product Name
              Center(
                child: Obx(() => controller.isEditing.value
                    ? SizedBox(
                  width: 250,
                  child: TextField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                )
                    : Text(
                  product.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
              ),
              const SizedBox(height: 10),

              // Product ID (read-only)
              Center(
                child: Text(
                  "Product ID: ${controller.originalId}",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
              ),
              const SizedBox(height: 20),

              const Divider(thickness: 1),
              const SizedBox(height: 10),

              Text(
                "Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 10),

              if (product.data == null || product.data!.isEmpty)
                const Text("No additional information available.",
                    style: TextStyle(fontSize: 16, color: Colors.grey))
              else
                ...controller.keyControllers.entries.map((entry) {
                  final oldKey = entry.key;
                  final keyController = entry.value;
                  final valueController = controller.valueControllers[oldKey]!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Editable Key field
                        Expanded(
                          flex: 2,
                          child: Obx(() => controller.isEditing.value
                              ? TextField(
                            controller: keyController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            ),
                          )
                              : Text(
                            keyController.text,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Editable Value field
                        Expanded(
                          flex: 3,
                          child: Obx(() => controller.isEditing.value
                              ? TextField(
                            controller: valueController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            ),
                          )
                              : Text(
                            valueController.text,
                            style: const TextStyle(fontSize: 16),
                          ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),


              const SizedBox(height: 20),

              // New Item Input Row (only in edit mode)
              Obx(() =>
              controller.isEditing.value ? _newKeyValueInputRow(controller) : const SizedBox()),

              const SizedBox(height: 30),

              // Update Button (only in edit mode)
              Obx(() => controller.isEditing.value
                  ? SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.handleUpdate,
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const Text("Update"),
                ),
              )
                  : const SizedBox()),
            ],
          ),
        );
      }),
    );
  }

  Widget _newKeyValueInputRow(ProductDetailedController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Add New Detail",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: controller.newKeyController,
                decoration: const InputDecoration(
                  labelText: "Key",
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: TextField(
                controller: controller.newValueController,
                decoration: const InputDecoration(
                  labelText: "Value",
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: controller.addNewItem,
              child: const Text("Add"),
            ),
          ],
        ),
      ],
    );
  }
}
