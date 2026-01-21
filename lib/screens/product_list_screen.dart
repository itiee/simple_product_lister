
import 'package:flutter/material.dart';
import 'package:simple_product_lister/models/product_model.dart';
import 'package:simple_product_lister/screens/product_detail_screen.dart';
import 'package:simple_product_lister/services/api_service.dart';
import 'package:simple_product_lister/wigets/product_card.dart';
class ProductListScreen extends StatefulWidget { 
    const ProductListScreen({super.key});

    @override
    State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
    late Future<List<ProductModel>> _productsFuture;
    final ApiService _apiService = ApiService();

    @override
    void initState() {
        super.initState();
        _productsFuture = _apiService.fetchProducts();
        print('Fetching products: $_productsFuture');
    }


    @override
    Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
            title: const Text('Product List'),
        ),
        body: Center(
            child: FutureBuilder<List<ProductModel>>(
            future: _productsFuture,
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                final products = snapshot.data!;
                return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(product: product, onTap: () {
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
                );
                } else {
                return const Text('No products found.');
                }
            },
        ),
        ));
    }
}