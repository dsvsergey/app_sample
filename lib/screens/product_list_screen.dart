import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../data/products_data.dart';
import '../models/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> filteredProducts = [];
  String selectedCategory = 'all';
  bool showOnlyInStock = false;
  String sortBy = 'name';

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(products);
  }

  void applyFilters() {
    setState(() {
      filteredProducts = products.where((product) {
        bool categoryMatch =
            selectedCategory == 'all' || product.category == selectedCategory;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productListTitle),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.1),
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
                    _buildCategoryChip(l10n.all, 'all', l10n),
                    _buildCategoryChip(l10n.fruits, 'Фрукти', l10n),
                    _buildCategoryChip(l10n.vegetables, 'Овочі', l10n),
                    _buildCategoryChip(l10n.drinks, 'Напої', l10n),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildSortDropdown(l10n),
                    ),
                    const SizedBox(width: 16),
                    FilterChip(
                      label: Text(l10n.onlyInStock),
                      selected: showOnlyInStock,
                      onSelected: (value) {
                        setState(() {
                          showOnlyInStock = value;
                          applyFilters();
                        });
                      },
                      avatar: Icon(
                        showOnlyInStock ? Icons.check : Icons.shopping_basket,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        product.name[0],
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
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
                              product.inStock
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color:
                                  product.inStock ? Colors.green : Colors.red,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.inStock ? l10n.inStock : l10n.outOfStock,
                              style: TextStyle(
                                color:
                                    product.inStock ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
      String label, String category, AppLocalizations l10n) {
    return FilterChip(
      label: Text(label),
      selected: selectedCategory == category,
      onSelected: (selected) {
        setState(() {
          selectedCategory = selected ? category : 'all';
          applyFilters();
        });
      },
      avatar: Icon(
        selectedCategory == category ? Icons.check : null,
        size: 18,
      ),
    );
  }

  Widget _buildSortDropdown(AppLocalizations l10n) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: l10n.sortBy,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      value: sortBy,
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
        setState(() {
          sortBy = value!;
          applyFilters();
        });
      },
    );
  }
}
