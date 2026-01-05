import '../entities/product_model.dart';

abstract class ProductRepository {
  Stream<List<ProductModel>> watchMarketplace();
  Future<void> addProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}
