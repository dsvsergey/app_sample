import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../repositories/product_repository.dart';

final productFilterStateProvider =
    StateNotifierProvider<ProductFilterNotifier, ProductFilterState>((ref) {
  return ProductFilterNotifier();
});

class ProductFilterState {
  final String selectedCategory;
  final bool showOnlyInStock;
  final String sortBy;

  ProductFilterState({
    this.selectedCategory = 'all',
    this.showOnlyInStock = false,
    this.sortBy = 'name',
  });

  ProductFilterState copyWith({
    String? selectedCategory,
    bool? showOnlyInStock,
    String? sortBy,
  }) {
    return ProductFilterState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      showOnlyInStock: showOnlyInStock ?? this.showOnlyInStock,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class ProductFilterNotifier extends StateNotifier<ProductFilterState> {
  ProductFilterNotifier() : super(ProductFilterState());

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void toggleShowOnlyInStock() {
    state = state.copyWith(showOnlyInStock: !state.showOnlyInStock);
  }

  void setSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }
}

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final filterState = ref.watch(productFilterStateProvider);
    final productsAsyncValue = ref.watch(filteredProductsProvider(
      filterState.selectedCategory,
      filterState.showOnlyInStock,
      filterState.sortBy,
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productListTitle),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilters(context, ref, l10n, filterState),
          Expanded(
            child: productsAsyncValue.when(
              data: (products) => _buildProductList(products, l10n),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(child: Text('${l10n.error}: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context, WidgetRef ref,
      AppLocalizations l10n, ProductFilterState filterState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.category,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildCategoryChip(ref, l10n.all, 'all', l10n, filterState),
              _buildCategoryChip(ref, l10n.fruits, 'Фрукти', l10n, filterState),
              _buildCategoryChip(
                  ref, l10n.vegetables, 'Овочі', l10n, filterState),
              _buildCategoryChip(ref, l10n.drinks, 'Напої', l10n, filterState),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSortDropdown(ref, l10n, filterState),
              ),
              const SizedBox(width: 16),
              FilterChip(
                label: Text(l10n.onlyInStock),
                selected: filterState.showOnlyInStock,
                onSelected: (_) {
                  ref
                      .read(productFilterStateProvider.notifier)
                      .toggleShowOnlyInStock();
                },
                avatar: Icon(
                  filterState.showOnlyInStock
                      ? Icons.check
                      : Icons.shopping_basket,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<Product> products, AppLocalizations l10n) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                product.name[0],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('${l10n.category}: ${product.category}'),
                const SizedBox(height: 4),
                Text(
                  '${l10n.price}: ${product.price.toStringAsFixed(2)} грн',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      product.inStock ? Icons.check_circle : Icons.cancel,
                      color: product.inStock ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.inStock ? l10n.inStock : l10n.outOfStock,
                      style: TextStyle(
                        color: product.inStock ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                        '${l10n.rating}: ${product.rating.toStringAsFixed(1)}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(WidgetRef ref, String label, String category,
      AppLocalizations l10n, ProductFilterState filterState) {
    return FilterChip(
      label: Text(label),
      selected: filterState.selectedCategory == category,
      onSelected: (selected) {
        ref
            .read(productFilterStateProvider.notifier)
            .setCategory(selected ? category : 'all');
      },
      avatar: Icon(
        filterState.selectedCategory == category ? Icons.check : null,
        size: 18,
      ),
    );
  }

  Widget _buildSortDropdown(
      WidgetRef ref, AppLocalizations l10n, ProductFilterState filterState) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: l10n.sortBy,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      value: filterState.sortBy,
      items: [
        DropdownMenuItem(value: 'name', child: Text(l10n.name)),
        DropdownMenuItem(
            value: 'priceLowToHigh', child: Text(l10n.priceLowToHigh)),
        DropdownMenuItem(
            value: 'priceHighToLow', child: Text(l10n.priceHighToLow)),
        DropdownMenuItem(
            value: 'ratingLowToHigh', child: Text(l10n.ratingLowToHigh)),
        DropdownMenuItem(
            value: 'ratingHighToLow', child: Text(l10n.ratingHighToLow)),
      ],
      onChanged: (value) {
        if (value != null) {
          ref.read(productFilterStateProvider.notifier).setSortBy(value);
        }
      },
    );
  }
}
