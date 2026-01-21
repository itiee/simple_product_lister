import 'package:flutter/material.dart';
import 'package:simple_product_lister/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Image.network(product.thumbnail),
        title: Text(
          product.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        onTap: onTap,
      ),
    );
  }
}
