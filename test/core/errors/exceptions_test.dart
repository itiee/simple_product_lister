import 'package:flutter_test/flutter_test.dart';
import 'package:simple_product_lister/core/errors/exceptions.dart';

void main() {
  group('ApiException', () {
    test('should create ApiException with custom message', () {
      const message = 'Custom API error';
      final exception = ApiException(message);

      expect(exception.message, message);
      expect(exception.toString(), message);
    });

    test('should return message in toString()', () {
      const message = 'API Error Test';
      final exception = ApiException(message);

      expect(exception.toString(), message);
    });

    test('should handle empty message', () {
      final exception = ApiException('');

      expect(exception.message, '');
      expect(exception.toString(), '');
    });

    test('should handle long messages', () {
      const message = 'This is a very long error message that contains multiple sentences. '
          'It describes a complex error scenario with detailed information.';
      final exception = ApiException(message);

      expect(exception.message, message);
      expect(exception.toString(), message);
    });

    test('should handle special characters in message', () {
      const message = 'Error: Invalid response! Status 404 - Not found?';
      final exception = ApiException(message);

      expect(exception.message, message);
    });
  });

  group('NetworkException', () {
    test('should create NetworkException with default message', () {
      final exception = NetworkException();

      expect(exception.message, 'Cannot connect to the internet. Please check your connection.');
    });

    test('should return message in toString()', () {
      final exception = NetworkException();

      expect(exception.toString(), 'Cannot connect to the internet. Please check your connection.');
    });

    test('should have consistent message across instances', () {
      final exception1 = NetworkException();
      final exception2 = NetworkException();

      expect(exception1.message, exception2.message);
      expect(exception1.toString(), exception2.toString());
    });
  });

  group('ServerException', () {
    test('should create ServerException with default message', () {
      final exception = ServerException();

      expect(exception.message, 'Server error occurred. Please try again later.');
    });

    test('should return message in toString()', () {
      final exception = ServerException();

      expect(exception.toString(), 'Server error occurred. Please try again later.');
    });
    

    test('should have consistent message across instances', () {
      final exception1 = ServerException();
      final exception2 = ServerException();

      expect(exception1.message, exception2.message);
      expect(exception1.toString(), exception2.toString());
    });
  });

  group('Exception hierarchy', () {
    test('should throw NetworkException as ApiException', () {
      expect(
        () => throw NetworkException(),
        throwsA(isA<ApiException>()),
      );
    });

    test('should throw ServerException as ApiException', () {
      expect(
        () => throw ServerException(),
        throwsA(isA<ApiException>()),
      );
    });

    test('should catch NetworkException as Exception', () {
      expect(
        () => throw NetworkException(),
        throwsA(isA<Exception>()),
      );
    });

    test('should distinguish between different exception types', () {
      final networkException = NetworkException();
      final serverException = ServerException();
      final apiException = ApiException('Generic error');

      expect(networkException is! ServerException, true);
      expect(serverException is! NetworkException, true);
      expect(apiException is! NetworkException, true);
      expect(apiException is! ServerException, true);
    });
  });

  group('Exception handling scenarios', () {
    test('should catch NetworkException in try-catch', () {
      try {
        throw NetworkException();
      } catch (e) {
        expect(e is NetworkException, true);
        expect(e is ApiException, true);
      }
    });

    test('should catch ServerException in try-catch', () {
      try {
        throw ServerException();
      } catch (e) {
        expect(e is ServerException, true);
        expect(e is ApiException, true);
      }
    });

    test('should catch ApiException with custom message', () {
      const customMessage = 'Specific error occurred';
      try {
        throw ApiException(customMessage);
      } catch (e) {
        expect(e is ApiException, true);
        expect((e as ApiException).message, customMessage);
      }
    });
  });
}
