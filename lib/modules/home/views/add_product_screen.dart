import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment/modules/home/controllers/add_product_controller.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({Key? key}) : super(key: key);

  final AddProductController controller = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Product"),
        elevation: 0,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name Input
              Center(
                child: SizedBox(
                  width: 250,
                  child: TextField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      labelText: "Product Name",
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Divider(thickness: 1),
              const SizedBox(height: 10),

              const Text(
                "Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              // List of Key-Value pairs with text fields
              ...controller.keyControllers.entries.map((entry) {
                final key = entry.key;
                final keyController = entry.value;
                final valueController = controller.valueControllers[key]!;

                return KeyedSubtree(
                  key: ValueKey(key),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: keyController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Key",
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: valueController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Value",
                              isDense: true,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => controller.removeItem(key),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),


              const SizedBox(height: 20),

              // New Key-Value input row
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

              const SizedBox(height: 30),

              // Create Product Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.handleCreateProduct,
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text("Create Product"),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
