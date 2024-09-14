// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productRepositoryHash() => r'1143e6a957468f07814b030b8e53d8ea1ddb037b';

/// See also [productRepository].
@ProviderFor(productRepository)
final productRepositoryProvider =
    AutoDisposeProvider<ProductRepository>.internal(
  productRepository,
  name: r'productRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProductRepositoryRef = AutoDisposeProviderRef<ProductRepository>;
String _$productsHash() => r'fe6f00aec608c7a44b47804c83629cba56e89ffc';

/// See also [products].
@ProviderFor(products)
final productsProvider = AutoDisposeFutureProvider<List<Product>>.internal(
  products,
  name: r'productsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$productsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProductsRef = AutoDisposeFutureProviderRef<List<Product>>;
String _$filteredProductsHash() => r'3bafa06a6070b0c2c6067d64c3b5108055c162dc';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [filteredProducts].
@ProviderFor(filteredProducts)
const filteredProductsProvider = FilteredProductsFamily();

/// See also [filteredProducts].
class FilteredProductsFamily extends Family<AsyncValue<List<Product>>> {
  /// See also [filteredProducts].
  const FilteredProductsFamily();

  /// See also [filteredProducts].
  FilteredProductsProvider call(
    String category,
    bool showOnlyInStock,
    String sortBy,
  ) {
    return FilteredProductsProvider(
      category,
      showOnlyInStock,
      sortBy,
    );
  }

  @override
  FilteredProductsProvider getProviderOverride(
    covariant FilteredProductsProvider provider,
  ) {
    return call(
      provider.category,
      provider.showOnlyInStock,
      provider.sortBy,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredProductsProvider';
}

/// See also [filteredProducts].
class FilteredProductsProvider
    extends AutoDisposeFutureProvider<List<Product>> {
  /// See also [filteredProducts].
  FilteredProductsProvider(
    String category,
    bool showOnlyInStock,
    String sortBy,
  ) : this._internal(
          (ref) => filteredProducts(
            ref as FilteredProductsRef,
            category,
            showOnlyInStock,
            sortBy,
          ),
          from: filteredProductsProvider,
          name: r'filteredProductsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredProductsHash,
          dependencies: FilteredProductsFamily._dependencies,
          allTransitiveDependencies:
              FilteredProductsFamily._allTransitiveDependencies,
          category: category,
          showOnlyInStock: showOnlyInStock,
          sortBy: sortBy,
        );

  FilteredProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
    required this.showOnlyInStock,
    required this.sortBy,
  }) : super.internal();

  final String category;
  final bool showOnlyInStock;
  final String sortBy;

  @override
  Override overrideWith(
    FutureOr<List<Product>> Function(FilteredProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredProductsProvider._internal(
        (ref) => create(ref as FilteredProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
        showOnlyInStock: showOnlyInStock,
        sortBy: sortBy,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Product>> createElement() {
    return _FilteredProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredProductsProvider &&
        other.category == category &&
        other.showOnlyInStock == showOnlyInStock &&
        other.sortBy == sortBy;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, showOnlyInStock.hashCode);
    hash = _SystemHash.combine(hash, sortBy.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FilteredProductsRef on AutoDisposeFutureProviderRef<List<Product>> {
  /// The parameter `category` of this provider.
  String get category;

  /// The parameter `showOnlyInStock` of this provider.
  bool get showOnlyInStock;

  /// The parameter `sortBy` of this provider.
  String get sortBy;
}

class _FilteredProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<Product>>
    with FilteredProductsRef {
  _FilteredProductsProviderElement(super.provider);

  @override
  String get category => (origin as FilteredProductsProvider).category;
  @override
  bool get showOnlyInStock =>
      (origin as FilteredProductsProvider).showOnlyInStock;
  @override
  String get sortBy => (origin as FilteredProductsProvider).sortBy;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
