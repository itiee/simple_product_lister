import 'package:flutter/material.dart';
import 'package:simple_product_lister/screens/product_detail_screen.dart';
import 'package:simple_product_lister/wigets/error_view.dart';
import 'package:simple_product_lister/wigets/product_card.dart';
import 'package:simple_product_lister/wigets/product_filter_sheet.dart';
import '../../controllers/product_controller.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductController _controller = ProductController();

  @override
  void initState() {
    super.initState();
    _controller.fetchProducts();
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ProductFilterSheet(controller: _controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Lister'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          switch (_controller.status) {
            case ProductStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case ProductStatus.error:
              return ErrorView(
                message: _controller.errorMessage,
                onRetry: _controller.fetchProducts,
              );

            case ProductStatus.loaded:
              return RefreshIndicator(
                onRefresh: _controller.fetchProducts,
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _controller.products.length,
                  itemBuilder: (context, index) {
                    final product = _controller.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(product: product),
                          ),
                        );
                      },
                    );
                  },
                ),
              );

            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
