import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/products_data.dart' as product_data;
import '../models/product.dart';

part 'product_repository.g.dart';

class ProductRepository {
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return product_data.products;
  }

  Future<List<Product>> filterProducts({
    required String category,
    required bool showOnlyInStock,
    required String sortBy,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    List<Product> allProducts =
        await getProducts(); // Call getProducts() to get the list
    List<Product> filteredProducts = allProducts.where((product) {
      bool categoryMatch = category == 'all' || product.category == category;
      bool stockMatch = !showOnlyInStock || product.inStock;
      return categoryMatch && stockMatch;
    }).toList();

    switch (sortBy) {
      case 'priceLowToHigh':
        filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'priceHighToLow':
        filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'ratingLowToHigh':
        filteredProducts.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case 'ratingHighToLow':
        filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        filteredProducts.sort((a, b) => a.name.compareTo(b.name));
    }

    return filteredProducts;
  }
}

@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepository();
}

@riverpod
Future<List<Product>> products(ProductsRef ref) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
}

@riverpod
Future<List<Product>> filteredProducts(
  FilteredProductsRef ref,
  String category,
  bool showOnlyInStock,
  String sortBy,
) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.filterProducts(
    category: category,
    showOnlyInStock: showOnlyInStock,
    sortBy: sortBy,
  );
}
