import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductController extends ChangeNotifier {
  final ApiService _apiService;

  ProductController({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = []; 

  ProductStatus _status = ProductStatus.initial;
  String _errorMessage = '';

  String _selectedCategory = 'All';

  List<ProductModel> get products => _filteredProducts;
  ProductStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;

  List<String> get categories => [
    'All',
    ..._allProducts.map((p) => p.category).toSet().toList(),
  ];

  Future<void> fetchProducts() async {
    _status = ProductStatus.loading;
    notifyListeners();
    try {
      _allProducts = await _apiService.fetchProducts();
      _applyFilter();
      _status = ProductStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = ProductStatus.error;
    } finally {
      notifyListeners();
    }
  }

  void setFilters({String? category, double? price}) {
    if (category != null) _selectedCategory = category;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    _filteredProducts = _allProducts.where((product) {
      final matchCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;
      return matchCategory;
    }).toList();
  }
}
