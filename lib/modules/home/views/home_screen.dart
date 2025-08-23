import 'package:assignment/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.isError.value) {
          return RefreshIndicator(
            onRefresh: () async => controller.fetchProducts(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 200),
                Center(child: Text("Error loading products")),
              ],
            ),
          );
        }

        if (controller.allProducts.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async => controller.fetchProducts(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 200),
                Center(child: Text("No products available")),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchProducts(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: controller.allProducts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = controller.allProducts[index];

              return  Card(
                key: ValueKey(product.id),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: Colors.black26,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    // TODO: Navigate to product details
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product icon box
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF124C2F),Color(0xFFC7DED3)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.shopping_bag,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Product details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product name
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Product ID
                              Text(
                                "ID: ${product.id}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 6),

                              Text(
                                _dataSummary(product.data),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                                softWrap: true,

                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  String _dataSummary(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return "No additional info";
    return data.entries.map((e) => "${e.key.capitalizeFirst}: ${e.value}").join("\n");
  }
}
