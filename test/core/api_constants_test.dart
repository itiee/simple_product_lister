import 'package:flutter_test/flutter_test.dart';
import 'package:simple_product_lister/core/api_constants.dart';

void main() {
  group('ApiConstants', () {
    test('should have correct baseUrl', () {
      expect(ApiConstants.baseUrl, 'https://dummyjson.com');
    });

    test('should have correct productsEndpoint', () {
      expect(ApiConstants.productsEndpoint, '/products');
    });

    test('should construct full API URL correctly', () {
      final fullUrl = '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}';
      expect(fullUrl, 'https://dummyjson.com/products');
    });

    test('constants should be immutable strings', () {
      expect(ApiConstants.baseUrl, isA<String>());
      expect(ApiConstants.productsEndpoint, isA<String>());
    });

    test('constants should not contain sensitive data', () {
      expect(ApiConstants.baseUrl.contains('password'), false);
      expect(ApiConstants.baseUrl.contains('token'), false);
      expect(ApiConstants.baseUrl.contains('key'), false);
    });

    test('multiple calls should return same value', () {
      final url1 = ApiConstants.baseUrl;
      final url2 = ApiConstants.baseUrl;
      final endpoint1 = ApiConstants.productsEndpoint;
      final endpoint2 = ApiConstants.productsEndpoint;

      expect(url1, url2);
      expect(endpoint1, endpoint2);
    });
  });
}
