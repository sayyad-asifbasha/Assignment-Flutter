import 'package:assignment/modules/home/controllers/add_product_controller.dart';
import 'package:assignment/modules/home/controllers/product_detailed_controller.dart';
import 'package:assignment/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProductDetailedController>(() => ProductDetailedController());
    Get.lazyPut<AddProductController>(()=>AddProductController());
  }
}
