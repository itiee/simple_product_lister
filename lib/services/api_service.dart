import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:simple_product_lister/core/api_constants.dart';
import 'package:simple_product_lister/core/errors/exceptions.dart';
import 'package:simple_product_lister/models/product_model.dart';

class ApiService {
  final http.Client _httpClient;
  ApiService({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await _httpClient
          .get(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}',
            ),
          )
          .timeout(const Duration(seconds: 10));

      print ('Response Status: ${response.body}');
      return _handleProductsResponse(response);
    } on SocketException {
      throw NetworkException();
    } on http.ClientException {
      throw ApiException('cannot connect to the server.');
    } catch (e) {
      throw ApiException('Unexpected error: ${e.toString()}');
    }
  }
}

List<ProductModel> _handleProductsResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      final Map<String, dynamic> data = json.decode(response.body);
      print('Parsed Data: $data');
      return ProductResponse.fromJson(data).products;

    case 404:
      throw ApiException('Resource not found (404).');

    case 500:
      throw ServerException();

    default:
      throw ApiException(
        'Failed to load products. Status code: ${response.statusCode}',
      );
  }
}
