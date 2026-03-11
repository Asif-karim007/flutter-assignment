import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import '../routes/app_routes.dart';
import '../widgets/error_state_widget.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with AutomaticKeepAliveClientMixin<ProductsPage> {
  final ProductController _controller = Get.find<ProductController>();
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 120) {
      _controller.fetchMoreProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.errorMessage.value.isNotEmpty) {
          return ErrorStateWidget(
            message: _controller.errorMessage.value,
            onRetry: _controller.fetchInitialProducts,
          );
        }

        if (_controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('No products found.'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _controller.fetchInitialProducts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final itemCount =
            _controller.products.length + (_controller.isPaginationLoading.value ? 1 : 0);

        return RefreshIndicator(
          onRefresh: _controller.fetchInitialProducts,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index >= _controller.products.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final ProductModel product = _controller.products[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: product),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            product.thumbnail,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const SizedBox(
                              width: 64,
                              height: 64,
                              child: Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '\$${product.price}',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final paginationError = _controller.paginationError.value;
        if (paginationError.isEmpty) return const SizedBox.shrink();

        return SafeArea(
          child: Container(
            color: Theme.of(context).colorScheme.errorContainer,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    paginationError,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: _controller.fetchMoreProducts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
