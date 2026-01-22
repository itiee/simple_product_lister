import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:simple_product_lister/controllers/product_controller.dart';
import 'package:simple_product_lister/models/product_model.dart';
import 'package:simple_product_lister/services/api_service.dart';

import 'product_controller_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  group('ProductController', () {
    late MockApiService mockApiService;
    late ProductController productController;

    setUp(() {
      mockApiService = MockApiService();
      productController = ProductController(apiService: mockApiService);
    });

    test('initial state should be correct', () {
      expect(productController.status, ProductStatus.initial);
      expect(productController.products, []);
      expect(productController.errorMessage, '');
      expect(productController.selectedCategory, 'All');
    });

    test('categories should include All and unique product categories', () async {
      final products = [
        ProductModel(id: 1, title: 'Product 1', category: 'Electronics', price: 100, description: 'test', thumbnail: 'test', rating: 5.0),
        ProductModel(id: 2, title: 'Product 2', category: 'Electronics', price: 200, description: 'test', thumbnail: 'test', rating: 5.0),
        ProductModel(id: 3, title: 'Product 3', category: 'Books', price: 50, description: 'test', thumbnail: 'test', rating: 5.0),
      ];
      when(mockApiService.fetchProducts()).thenAnswer((_) async => products);

      await productController.fetchProducts();

      expect(productController.categories, ['All', 'Electronics', 'Books']);
    });

    group('fetchProducts', () {
      test('should load products successfully', () async {
        final products = [
           ProductModel(
            id: 2,
            title: 'Product 2',
            category: 'Electronics',
            price: 200,
            description: 'test',
            thumbnail: 'test',
            rating: 5.0,
          ),
          ProductModel(
            id: 3,
            title: 'Product 3',
            category: 'Books',
            price: 50,
            description: 'test',
            thumbnail: 'test',
            rating: 5.0,
          ),
        ];
        when(mockApiService.fetchProducts()).thenAnswer((_) async => products);

        await productController.fetchProducts();

        expect(productController.status, ProductStatus.loaded);
        expect(productController.products, products);
        expect(productController.errorMessage, '');
      });

      test('should set error state on failure', () async {
        final exception = Exception('Network error');
        when(mockApiService.fetchProducts()).thenThrow(exception);

        await productController.fetchProducts();

        expect(productController.status, ProductStatus.error);
        expect(productController.errorMessage, contains('Network error'));
        expect(productController.products, []);
      });

      test('should set loading status during fetch', () async {
        when(mockApiService.fetchProducts()).thenAnswer((_) async => []);
        
        final future = productController.fetchProducts();
        expect(productController.status, ProductStatus.loading);
        
        await future;
      });
    });

    group('setFilters', () {
      setUp(() async {
        final products = [
          ProductModel(id: 1, title: 'Laptop', category: 'Electronics', price: 1000, description: 'test', thumbnail: 'test', rating: 5.0),
          ProductModel(id: 2, title: 'Phone', category: 'Electronics', price: 500, description: 'test', thumbnail: 'test', rating: 5.0),
          ProductModel(id: 3, title: 'Flutter Guide', category: 'Books', price: 50, description: 'test', thumbnail: 'test', rating: 5.0),
        ];
        when(mockApiService.fetchProducts()).thenAnswer((_) async => products);
        await productController.fetchProducts();
      });

      test('should filter products by category', () {
        productController.setFilters(category: 'Electronics');

        expect(productController.selectedCategory, 'Electronics');
        expect(productController.products.length, 2);
        expect(productController.products.every((p) => p.category == 'Electronics'), true);
      });

      test('should show all products when category is All', () {
        productController.setFilters(category: 'Electronics');
        productController.setFilters(category: 'All');

        expect(productController.products.length, 3);
      });

      test('should update selected category', () {
        productController.setFilters(category: 'Books');

        expect(productController.selectedCategory, 'Books');
        expect(productController.products.length, 1);
        expect(productController.products.first.category, 'Books');
      });
    });
  });
}
