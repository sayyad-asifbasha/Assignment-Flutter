import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assignment/modules/home/models/product_model.dart';
import 'package:assignment/services/REST/api_url.dart';
import 'dart:convert'; // Added for jsonEncode

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Home API Tests', () {
    group('ProductModel Tests', () {
      test('should create ProductModel from JSON data', () {
        // Arrange
        final jsonData = {
          'id': 'test_id',
          'name': 'Test Product',
          'data': {'test_key': 'test_value'},
        };

        // Act
        final product = ProductModel.fromJson(jsonData);

        // Assert
        expect(product.id, equals('test_id'));
        expect(product.name, equals('Test Product'));
        expect(product.data, equals({'test_key': 'test_value'}));
      });

      test('should convert ProductModel to JSON', () {
        // Arrange
        final product = ProductModel(
          id: 'test_id',
          name: 'Test Product',
          data: {'test_key': 'test_value'},
        );

        // Act
        final json = product.toJson();

        // Assert
        expect(json['id'], equals('test_id'));
        expect(json['name'], equals('Test Product'));
        expect(json['data'], equals({'test_key': 'test_value'}));
      });

      test('should handle empty ProductModel', () {
        // Arrange
        final emptyProduct = ProductModel.empty();

        // Assert
        expect(emptyProduct.id, equals(''));
        expect(emptyProduct.name, equals(''));
        expect(
          emptyProduct.data,
          equals({}),
        ); // empty() returns empty map, not null
      });

      test('should handle null data in ProductModel', () {
        // Arrange
        final productWithNullData = ProductModel(
          id: '1',
          name: 'Product with null data',
          data: null,
        );

        // Assert
        expect(productWithNullData.id, equals('1'));
        expect(productWithNullData.name, equals('Product with null data'));
        expect(productWithNullData.data, isNull);
      });

      test('should handle empty string values', () {
        // Arrange
        final productWithEmptyData = ProductModel(
          id: '',
          name: '',
          data: {'empty_key': ''},
        );

        // Assert
        expect(productWithEmptyData.id, equals(''));
        expect(productWithEmptyData.name, equals(''));
        expect(productWithEmptyData.data!['empty_key'], equals(''));
      });
    });

    group('API URL Tests', () {
      test('should construct correct API URLs', () {
        expect(
          ApiUrl.allObjects(),
          equals('https://api.restful-api.dev/objects'),
        );
        expect(
          ApiUrl.singleObject('123'),
          equals('https://api.restful-api.dev/objects/123'),
        );
        expect(
          ApiUrl.updateObject('123'),
          equals('https://api.restful-api.dev/objects/123'),
        );
        expect(
          ApiUrl.deleteObject('123'),
          equals('https://api.restful-api.dev/objects/123'),
        );
        expect(
          ApiUrl.addObject(),
          equals('https://api.restful-api.dev/objects'),
        );
        expect(
          ApiUrl.partialUpdateObject('123'),
          equals('https://api.restful-api.dev/objects/123'),
        );
      });

      test('should handle list by IDs query parameters', () {
        final ids = ['1', '2', '3'];
        final url = ApiUrl.listByIds(ids);
        expect(
          url,
          equals('https://api.restful-api.dev/objects?id=1&id=2&id=3'),
        );
      });

      test('should handle empty list for IDs', () {
        final ids = <String>[];
        final url = ApiUrl.listByIds(ids);
        expect(url, equals('https://api.restful-api.dev/objects?'));
      });

      test('should handle single ID for list', () {
        final ids = ['1'];
        final url = ApiUrl.listByIds(ids);
        expect(url, equals('https://api.restful-api.dev/objects?id=1'));
      });

      test('should handle special characters in IDs', () {
        final ids = ['test-id', 'test_id', 'test.id'];
        final url = ApiUrl.listByIds(ids);
        expect(
          url,
          equals(
            'https://api.restful-api.dev/objects?id=test-id&id=test_id&id=test.id',
          ),
        );
      });
    });

    group('Data Structure Tests', () {
      test('should handle dynamic data types in ProductModel', () {
        // Arrange
        final complexData = {
          'string': 'test',
          'number': 42,
          'boolean': true,
          'list': [1, 2, 3],
          'nested': {'key': 'value'},
          'null_value': null,
          'double': 3.14,
          'negative': -1,
        };

        // Act
        final product = ProductModel(
          id: '1',
          name: 'Complex Product',
          data: complexData,
        );

        // Assert
        expect(product.data!['string'], equals('test'));
        expect(product.data!['number'], equals(42));
        expect(product.data!['boolean'], equals(true));
        expect(product.data!['list'], equals([1, 2, 3]));
        expect(product.data!['nested'], equals({'key': 'value'}));
        expect(product.data!['null_value'], isNull);
        expect(product.data!['double'], equals(3.14));
        expect(product.data!['negative'], equals(-1));
      });

      test('should handle list from JSON', () {
        // Arrange
        final jsonList = [
          {
            'id': '1',
            'name': 'Product 1',
            'data': {'key1': 'value1'},
          },
          {
            'id': '2',
            'name': 'Product 2',
            'data': {'key2': 'value2'},
          },
        ];
        final jsonString = jsonEncode(jsonList);

        // Act
        final products = ProductModel.listFromJson(jsonString);

        // Assert
        expect(products.length, equals(2));
        expect(products[0].id, equals('1'));
        expect(products[0].name, equals('Product 1'));
        expect(products[0].data, equals({'key1': 'value1'}));
        expect(products[1].id, equals('2'));
        expect(products[1].name, equals('Product 2'));
        expect(products[1].data, equals({'key2': 'value2'}));
      });

      test('should handle empty list from JSON', () {
        // Arrange
        final jsonString = jsonEncode([]);

        // Act
        final products = ProductModel.listFromJson(jsonString);

        // Assert
        expect(products.isEmpty, isTrue);
      });

      test('should handle malformed JSON gracefully', () {
        // Arrange
        final malformedJson = '{"invalid": json}';

        // Act & Assert
        expect(
          () => ProductModel.listFromJson(malformedJson),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('Edge Cases Tests', () {
      test('should handle products with very long names', () {
        // Arrange
        final longName = 'A' * 1000; // 1000 character name
        final product = ProductModel(id: '1', name: longName, data: {});

        // Assert
        expect(product.name.length, equals(1000));
        expect(product.name, equals(longName));
      });

      test('should handle products with special characters in names', () {
        // Arrange
        final specialName =
            'Product with special chars: !@#\$%^&*()_+-=[]{}|;:,.<>?';
        final product = ProductModel(id: '1', name: specialName, data: {});

        // Assert
        expect(product.name, equals(specialName));
      });

      test('should handle products with unicode characters', () {
        // Arrange
        final unicodeName = 'Product with unicode: 🚀🌟🎉';
        final product = ProductModel(id: '1', name: unicodeName, data: {});

        // Assert
        expect(product.name, equals(unicodeName));
      });

      test('should handle products with empty data map', () {
        // Arrange
        final product = ProductModel(
          id: '1',
          name: 'Empty Data Product',
          data: {},
        );

        // Assert
        expect(product.data, equals({}));
        expect(product.data!.isEmpty, isTrue);
      });

      test('should handle products with deeply nested data', () {
        // Arrange
        final nestedData = {
          'level1': {
            'level2': {
              'level3': {
                'level4': {'level5': 'deep_value'},
              },
            },
          },
        };

        final product = ProductModel(
          id: '1',
          name: 'Nested Data Product',
          data: nestedData,
        );

        // Assert
        expect(
          product.data!['level1']['level2']['level3']['level4']['level5'],
          equals('deep_value'),
        );
      });
    });

    group('Validation Tests', () {
      test('should handle ProductModel with null data', () {
        // Arrange
        final product = ProductModel(id: '', name: '', data: null);

        // Assert
        expect(product.id, equals(''));
        expect(product.name, equals(''));
        expect(product.data, isNull);
      });

      test('should handle ProductModel with empty strings', () {
        // Arrange
        final product = ProductModel(id: '', name: '', data: {});

        // Assert
        expect(product.id, equals(''));
        expect(product.name, equals(''));
        expect(product.data, equals({}));
      });

      test('should handle ProductModel with whitespace strings', () {
        // Arrange
        final product = ProductModel(id: '   ', name: '   ', data: {});

        // Assert
        expect(product.id, equals('   '));
        expect(product.name, equals('   '));
        expect(product.data, equals({}));
      });
    });
  });
}
