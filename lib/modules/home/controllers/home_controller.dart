import 'package:assignment/modules/home/models/product_model.dart';
import 'package:assignment/services/REST/api_url.dart';
import 'package:assignment/services/REST/dio_client.dart';
import 'package:assignment/utils/helpers/exception_handler.dart';
import 'package:assignment/utils/helpers/network_connectivity.dart';
import 'package:assignment/utils/widgets/snackbar.dart';
import 'package:assignment/services/storage_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with ExceptionHandler {
  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxBool isLoading = false.obs;

  final StorageService storageService = StorageService();

  @override
  void onReady() {
    super.onReady();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;

    if (await NetworkConnectivity.isNetworkAvailable()) {
      try {
//         final response = await DioClient().get(url: ApiUrl.allObjects());
//         if (response == null) {
//           isLoading.value = false;
//           return;
//         }
//         final List<dynamic> items =
//         response is List ? response : response["results"] ?? [];
//         final List<ProductModel> serverProducts =
//         items.map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e))).toList();
//
//         final cachedProducts = storageService.getProducts();
//
// // Merge: keep cached products that are not already in server
//         final Set<String> serverIds = serverProducts.map((p) => p.id).toSet();
//         final mergedProducts = [
//           ...serverProducts,
//           ...cachedProducts.where((p) => !serverIds.contains(p.id)),
//         ];
//
//         final Map<String, String> idMap = storageService.getProductIdMap();
//
//         // Build a map of original products by their ID
//         final Map<String, ProductModel> originalProductsMap = {
//           for (var p in mergedProducts) p.id: p,
//         };
//
//         // List of all updated product IDs to fetch
//         final updatedIds = idMap.values.toSet();
//
//         // Fetch updated products data from backend for all updated IDs
//         final List<ProductModel> updatedProducts = [];
//
//         for (final updatedId in updatedIds) {
//           if (updatedId != null) {
//             final updatedResponse = await DioClient().get(url: ApiUrl.singleObject(updatedId));
//             if (updatedResponse != null) {
//               updatedProducts.add(ProductModel.fromJson(updatedResponse));
//             }
//           }
//         }
//
//         // Map updated products by their ID
//         final Map<String, ProductModel> updatedProductsMap = {
//           for (var p in updatedProducts) p.id: p,
//         };
//
//         // Now create final display list
//         List<ProductModel> displayProducts = [];
//
//         for (final originalProduct in mergedProducts) {
//           final latestId = idMap[originalProduct.id];
//           if (latestId != null &&
//               latestId != originalProduct.id &&
//               updatedProductsMap.containsKey(latestId)) {
//             final latestProduct = updatedProductsMap[latestId]!;
//             displayProducts.add(ProductModel(
//               id: originalProduct.id,
//               name: latestProduct.name,
//               data: latestProduct.data,
//             ));
//           } else {
//             displayProducts.add(originalProduct);
//           }
//         }
//
//         await storageService.saveProducts([...mergedProducts, ...updatedProducts]);
//
//         allProducts.assignAll(displayProducts);
        final cachedProducts = storageService.getProducts();
        allProducts.assignAll(cachedProducts);
      } catch (error) {
        handleError(error);
      }
    } else {
      if (storageService.hasProducts()) {
        final products = storageService.getProducts();
        final Map<String, String> idMap = storageService.getProductIdMap();
        final productMap = {for (var p in products) p.id: p};
        List<ProductModel> displayProducts = products.map((original) {
          final mappedId = idMap[original.id];
          if (mappedId != null && mappedId != original.id && productMap.containsKey(mappedId)) {
            final latest = productMap[mappedId]!;
            return ProductModel(
              id: original.id,
              name: latest.name,
              data: latest.data,
            );
          }
          return original;
        }).toList();

        allProducts.assignAll(displayProducts);
        Snackbar.warning("Offline", "Loaded cached data");
      } else {
        Snackbar.error("Error", "No Network & No Cached Data");
      }
      NetworkConnectivity.connectionChangeCount = 1;
    }

    isLoading.value = false;
  }

}
