import 'package:get_storage/get_storage.dart';
import 'package:assignment/modules/authentication/models/user_model.dart';
import 'package:assignment/modules/home/models/product_model.dart';

class StorageService {
  final GetStorage _box = GetStorage();

  static const String userKey = "user";

  static const String productsKey = "products";

  Future<void> saveUser(UserModel user) async {
    await _box.write(userKey, user.toMap());
  }

  UserModel? getUser() {
    final data = _box.read(userKey);
    if (data != null) {
      return UserModel.fromMap(Map<String, dynamic>.from(data));
    }
    return null;
  }

  bool hasUser() => _box.hasData(userKey);

  Future<void> clearUser() async {
    await _box.remove(userKey);
  }

  Future<void> saveProducts(List<Product> products) async {
    final List<Map<String, dynamic>> productsList =
    products.map((e) => e.toJson()).toList();
    await _box.write(productsKey, productsList);
  }

  List<Product> getProducts() {
    final data = _box.read(productsKey);
    if (data != null) {
      return (data as List)
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  bool hasProducts() => _box.hasData(productsKey);

  Future<void> clearProducts() async {
    await _box.remove(productsKey);
  }
}
