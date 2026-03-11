import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments as ProductModel?;

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Product not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.thumbnail,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 220,
                child: Center(child: Icon(Icons.broken_image, size: 32)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            '\$${product.price}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(product.description),
        ],
      ),
    );
  }
}
