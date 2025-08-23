import 'package:assignment/modules/home/models/product_model.dart';
import 'package:assignment/services/REST/api_url.dart';
import 'package:assignment/services/REST/dio_client.dart';
import 'package:assignment/utils/helpers/exception_handler.dart';
import 'package:assignment/utils/helpers/network_connectivity.dart';
import 'package:assignment/utils/widgets/snackbar.dart';
import 'package:assignment/services/storage_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with ExceptionHandler {
  RxList<Product> allProducts = <Product>[].obs;
  RxBool isLoading = false.obs;

  final StorageService storageService = StorageService();

  @override
  void onReady() {
    super.onReady();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    isError.value = false;

    if (await NetworkConnectivity.isNetworkAvailable()) {
      try {
        final response = await DioClient().get(url: ApiUrl.allObjects());
        if (response == null) {
          isLoading.value = false;
          return;
        }

        final List<dynamic> items =
        response is List ? response : response["results"] ?? [];

        final List<Product> products =
        items.map((e) => Product.fromJson(e)).toList();

        allProducts.assignAll(products);

        await storageService.saveProducts(products);

      } catch (error) {
        handleError(error);
      }
    } else {
      if (storageService.hasProducts()) {
        allProducts.assignAll(storageService.getProducts());
        Snackbar.warning("Offline", "Loaded cached data");
      } else {
        Snackbar.error("Error", "No Network & No Cached Data");
      }

      NetworkConnectivity.connectionChangeCount = 1;
    }

    isLoading.value = false;
  }
}
