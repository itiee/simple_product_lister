import 'package:flutter_test/flutter_test.dart';
import 'package:simple_product_lister/models/product_model.dart';

void main() {
  late ProductModel product;
  group('ProductModel', () {
    group('Constructor', () {
      test('should create ProductModel with all required fields', () {
        product = ProductModel(
          id: 1,
          title: 'Essence Mascara Lash Princess',
          description: 'description ',
          price: 99.99,
          thumbnail: 'https://example.com/',
          category: 'beauty',
          rating: 4.5,
        );

        expect(product.id, 1);
        expect(product.title, 'Essence Mascara Lash Princess');
        expect(product.description, 'description ');
        expect(product.price, 99.99);
        expect(product.thumbnail, 'https://example.com/');
        expect(product.category, 'beauty');
        expect(product.rating, 4.5);
      });
    });

    group('fromJson', () {
      test('should create ProductModel from valid JSON', () {
        final json = {
          "id": 3,
          "title": "Powder Canister",
          "description": "Description for Powder Canister",
          "category": "beauty",
          "price": 14.99,
          'thumbnail': 'https://example.com/',
          'rating': 4.8,
        };

        product = ProductModel.fromJson(json);

        expect(product.id, 3);
        expect(product.title, 'Powder Canister');
        expect(product.description, 'Description for Powder Canister');
        expect(product.price, 14.99);
        expect(product.thumbnail, 'https://example.com/');
        expect(product.category, 'beauty');
        expect(product.rating, 4.8);
      });

      test('should use default title when title is null', () {
        final json = {
          'id': 1,
          'title': null,
          'description': 'Test Description',
          'price': 50.0,
          'thumbnail': 'https://example.com/image.jpg',
          'category': 'furniture',
          'rating': 4.0,
        };

        product = ProductModel.fromJson(json);

        expect(product.title, 'No Title');
      });

      test('should use empty string as default description when null', () {
        final json = {
          'id': 1,
          'title': 'Test Product',
          'description': null,
          'price': 50.0,
          'thumbnail': 'https://example.com/image.jpg',
          'category': 'furniture',
          'rating': 4.0,
        };

        product = ProductModel.fromJson(json);

        expect(product.description, '');
      });

      test('should use empty string as default thumbnail when null', () {
        final json = {
          'id': 1,
          'title': 'Test Product',
          'description': 'Test Description',
          'price': 50.0,
          'thumbnail': null,
          'category': 'furniture',
          'rating': 4.0,
        };

        product = ProductModel.fromJson(json);

        expect(product.thumbnail, '');
      });

      test('should use General as default category when null', () {
        final json = {
          'id': 1,
          'title': 'Test Product',
          'description': 'Test Description',
          'price': 50.0,
          'thumbnail': 'https://example.com/image.jpg',
          'category': null,
          'rating': 4.0,
        };

        product = ProductModel.fromJson(json);

        expect(product.category, 'General');
      });

      test('should convert numeric price to double', () {
        final json = {
          'id': 1,
          'title': 'Test Product',
          'description': 'Test Description',
          'price': 50,
          'thumbnail': 'https://example.com/image.jpg',
          'category': 'Books',
          'rating': 4,
        };

        product = ProductModel.fromJson(json);

        expect(product.price, 50.0);
        expect(product.rating, 4.0);
      });
    });

    group('toJson', () {
      test('should convert ProductModel to JSON correctly', () {
        product = ProductModel(
          id: 1,
          title: 'Test Product',
          description: 'Test Description',
          price: 99.99,
          thumbnail: 'https://example.com/image.jpg',
          category: 'Electronics',
          rating: 4.5,
        );

        final json = product.toJson();

        expect(json['id'], 1);
        expect(json['title'], 'Test Product');
        expect(json['description'], 'Test Description');
        expect(json['price'], 99.99);
        expect(json['thumbnail'], 'https://example.com/image.jpg');
        expect(json['category'], 'Electronics');
        expect(json['rating'], 4.5);
      });

      test('should contain all required keys', () {
        product = ProductModel(
          id: 1,
          title: 'Test Product',
          description: 'Test Description',
          price: 99.99,
          thumbnail: 'https://example.com/image.jpg',
          category: 'Electronics',
          rating: 4.5,
        );

        final json = product.toJson();

        expect(
          json.keys,
          containsAll([
            'id',
            'title',
            'description',
            'price',
            'thumbnail',
            'category',
            'rating',
          ]),
        );
      });
    });

    group('JSON Round-trip', () {
      test('should preserve data through fromJson and toJson', () {
        final originalJson = {
          'id': 1,
          'title': 'Laptop',
          'description': 'High-performance laptop',
          'price': 1299.99,
          'thumbnail': 'https://example.com/laptop.jpg',
          'category': 'Electronics',
          'rating': 4.8,
        };

        product = ProductModel.fromJson(originalJson);
        final resultJson = product.toJson();

        expect(resultJson, originalJson);
      });

      test('should handle defaults in round-trip conversion', () {
        final jsonWithDefaults = {
          'id': 1,
          'title': null,
          'description': null,
          'price': 50.0,
          'thumbnail': null,
          'category': null,
          'rating': 4.0,
        };

        product = ProductModel.fromJson(jsonWithDefaults);
        final resultJson = product.toJson();

        expect(resultJson['title'], 'No Title');
        expect(resultJson['description'], '');
        expect(resultJson['thumbnail'], '');
        expect(resultJson['category'], 'General');
      });
    });
  });

  group('ProductResponse', () {
    group('fromJson', () {
      test('should create ProductResponse from valid JSON', () {
        final json = {
          'products': [
            {
              'id': 1,
              'title': 'Product 1',
              'description': 'Description 1',
              'price': 100.0,
              'thumbnail': 'https://example.com/1.jpg',
              'category': 'Electronics',
              'rating': 4.5,
            },
            {
              'id': 2,
              'title': 'Product 2',
              'description': 'Description 2',
              'price': 50.0,
              'thumbnail': 'https://example.com/2.jpg',
              'category': 'Books',
              'rating': 4.0,
            },
          ],
          'total': 2,
        };

        final response = ProductResponse.fromJson(json);

        expect(response.products.length, 2);
        expect(response.total, 2);
        expect(response.products[0].title, 'Product 1');
        expect(response.products[1].title, 'Product 2');
      });

      test('should parse empty product list', () {
        final json = {'products': [], 'total': 0};

        final response = ProductResponse.fromJson(json);

        expect(response.products.length, 0);
        expect(response.total, 0);
      });

      test('should parse multiple products correctly', () {
        final json = {
          'products': List.generate(
            5,
            (index) => {
              'id': index + 1,
              'title': 'Product ${index + 1}',
              'description': 'Description ${index + 1}',
              'price': (index + 1) * 100.0,
              'thumbnail': 'https://example.com/${index + 1}.jpg',
              'category': 'Category ${index + 1}',
              'rating': 4.0 + (index * 0.1),
            },
          ),
          'total': 5,
        };

        final response = ProductResponse.fromJson(json);

        expect(response.products.length, 5);
        expect(response.total, 5);
        expect(response.products[0].id, 1);
        expect(response.products[4].id, 5);
        expect(response.products[4].price, 500.0);
      });

      test('should apply ProductModel defaults in ProductResponse', () {
        final json = {
          'products': [
            {
              'id': 1,
              'title': null,
              'description': null,
              'price': 100.0,
              'thumbnail': null,
              'category': null,
              'rating': 4.5,
            },
          ],
          'total': 1,
        };

        final response = ProductResponse.fromJson(json);
        product = response.products[0];

        expect(product.title, 'No Title');
        expect(product.description, '');
        expect(product.thumbnail, '');
        expect(product.category, 'General');
      });
    });
  });
}
