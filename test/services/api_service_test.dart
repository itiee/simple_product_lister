import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:simple_product_lister/core/api_constants.dart';
import 'package:simple_product_lister/core/errors/exceptions.dart';
import 'package:simple_product_lister/models/product_model.dart';
import 'package:simple_product_lister/services/api_service.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ApiService', () {
    late MockClient mockHttpClient;
    late ApiService apiService;

    setUp(() {
      mockHttpClient = MockClient();
      apiService = ApiService(httpClient: mockHttpClient);
    });

    group('fetchProducts', () {
      test('should return list of products on successful response', () async {
        final responseBody = '''{
          "products": [
            {
              "id": 1,
              "title": "Product 1",
              "description": "Description 1",
              "price": 100.0,
              "thumbnail": "https://example.com/1.jpg",
              "category": "Electronics",
              "rating": 4.5
            },
            {
              "id": 2,
              "title": "Product 2",
              "description": "Description 2",
              "price": 50.0,
              "thumbnail": "https://example.com/2.jpg",
              "category": "Books",
              "rating": 4.0
            }
          ],
          "total": 2
        }''';

        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(responseBody, 200),
        );

        final products = await apiService.fetchProducts();

        expect(products, isA<List<ProductModel>>());
        expect(products.length, 2);
        expect(products[0].id, 1);
        expect(products[0].title, 'Product 1');
        expect(products[1].id, 2);
        expect(products[1].title, 'Product 2');
      });

      test('should return empty list when products array is empty', () async {
        final responseBody = '''{
          "products": [],
          "total": 0
        }''';

        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(responseBody, 200),
        );

        final products = await apiService.fetchProducts();

        expect(products, isA<List<ProductModel>>());
        expect(products.length, 0);
      });

      test('should call correct API endpoint', () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response('{"products": [], "total": 0}', 200),
        );

        await apiService.fetchProducts();

        final expectedUrl = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}',
        );
        verify(mockHttpClient.get(expectedUrl)).called(1);
      });

      test('should throw ApiException on 404 response', () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response('Not Found', 404),
        );

        expect(
          () => apiService.fetchProducts(),
          throwsA(isA<ApiException>()
              .having((e) => e.message, 'message', contains('404'))),
        );
      });

      test('should throw ServerException on 500 response', () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response('Internal Server Error', 500),
        );

        expect(
          () => apiService.fetchProducts(),
          throwsA(isA<ServerException>()),
        );
      });

      test('should throw ApiException on other status codes', () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response('Bad Request', 400),
        );

        expect(
          () => apiService.fetchProducts(),
          throwsA(isA<ApiException>()
              .having((e) => e.message, 'message', contains('400'))),
        );
      });

      test('should throw NetworkException on SocketException', () async {
        when(mockHttpClient.get(any)).thenThrow(SocketException('Network error'));

        expect(
          () => apiService.fetchProducts(),
          throwsA(isA<NetworkException>()),
        );
      });

      test('should throw ApiException on ClientException', () async {
        when(mockHttpClient.get(any))
            .thenThrow(http.ClientException('Client error'));

        expect(
          () => apiService.fetchProducts(),
          throwsA(isA<ApiException>()
              .having((e) => e.message, 'message', contains('cannot connect'))),
        );
      });

      test('should throw ApiException on unexpected error', () async {
        when(mockHttpClient.get(any)).thenThrow(Exception('Unexpected error'));

        expect(
          () => apiService.fetchProducts(),
          throwsA(isA<ApiException>()
              .having((e) => e.message, 'message', contains('Unexpected error'))),
        );
      });

      test('should handle timeout', () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async {
            await Future.delayed(const Duration(seconds: 11));
            return http.Response('{"products": [], "total": 0}', 200);
          },
        );

        expect(
          () => apiService.fetchProducts(),
          throwsA(isA<ApiException>()),
        );
      });
    });

    group('ApiService initialization', () {
      test('should create ApiService with default http.Client', () {
        final service = ApiService();

        expect(service, isNotNull);
      });

      test('should create ApiService with custom http.Client', () {
        final service = ApiService(httpClient: mockHttpClient);

        expect(service, isNotNull);
      });

      test('should use provided http.Client', () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response('{"products": [], "total": 0}', 200),
        );

        final service = ApiService(httpClient: mockHttpClient);
        await service.fetchProducts();

        verify(mockHttpClient.get(any)).called(1);
      });
    });

    group('Response parsing', () {
      test('should correctly parse product fields', () async {
        final responseBody = '''{
          "products": [
            {
              "id": 1,
              "title": "Laptop",
              "description": "High-performance laptop",
              "price": 1299.99,
              "thumbnail": "https://example.com/laptop.jpg",
              "category": "Electronics",
              "rating": 4.8
            }
          ],
          "total": 1
        }''';

        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(responseBody, 200),
        );

        final products = await apiService.fetchProducts();

        expect(products.first.id, 1);
        expect(products.first.title, 'Laptop');
        expect(products.first.description, 'High-performance laptop');
        expect(products.first.price, 1299.99);
        expect(products.first.thumbnail, 'https://example.com/laptop.jpg');
        expect(products.first.category, 'Electronics');
        expect(products.first.rating, 4.8);
      });

      test('should apply default values for missing optional fields', () async {
        final responseBody = '''{
          "products": [
            {
              "id": 1,
              "title": null,
              "description": null,
              "price": 100.0,
              "thumbnail": null,
              "category": null,
              "rating": 4.0
            }
          ],
          "total": 1
        }''';

        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(responseBody, 200),
        );

        final products = await apiService.fetchProducts();

        expect(products.first.title, 'No Title');
        expect(products.first.description, '');
        expect(products.first.thumbnail, '');
        expect(products.first.category, 'General');
      });

      test('should handle large product lists', () async {
        final products = List.generate(
          100,
          (i) => '''{
            "id": $i,
            "title": "Product $i",
            "description": "Description $i",
            "price": ${100.0 + i},
            "thumbnail": "https://example.com/$i.jpg",
            "category": "Category $i",
            "rating": ${4.0 + (i % 5) * 0.1}
          }''',
        ).join(',');

        final responseBody = '''{
          "products": [$products],
          "total": 100
        }''';

        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(responseBody, 200),
        );

        final result = await apiService.fetchProducts();

        expect(result.length, 100);
        expect(result.first.id, 0);
        expect(result.last.id, 99);
      });
    });

    group('Error handling', () {
      test('should maintain error message for ApiException', () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response('Forbidden', 403),
        );

        try {
          await apiService.fetchProducts();
        } catch (e) {
          expect(e, isA<ApiException>());
          expect((e as ApiException).message, contains('403'));
        }
      });

      test('should wrap SocketException as NetworkException', () async {
        when(mockHttpClient.get(any))
            .thenThrow(SocketException('Connection refused'));

        try {
          await apiService.fetchProducts();
        } catch (e) {
          expect(e, isA<NetworkException>());
        }
      });

      test('should distinguish between different exception types', () async {
        // Test NetworkException
        when(mockHttpClient.get(any)).thenThrow(SocketException(''));
        expect(
          () => apiService.fetchProducts(),
          throwsA(isA<NetworkException>()),
        );

        // Test ServerException
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response('', 500),
        );
        expect(
          () => apiService.fetchProducts(),
          throwsA(isA<ServerException>()),
        );
      });
    });
  });
}
