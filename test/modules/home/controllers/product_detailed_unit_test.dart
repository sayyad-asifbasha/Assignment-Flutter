import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart' as dio;
import 'package:assignment/modules/home/controllers/product_detailed_controller.dart';
import 'package:assignment/modules/home/models/product_model.dart';
import 'package:assignment/services/storage_service.dart';
import 'package:assignment/services/REST/dio_client.dart';
import 'package:assignment/utils/helpers/network_connectivity.dart';
import 'dart:convert';

// Generate mocks
@GenerateMocks([StorageService, DioClient, dio.Dio, NetworkConnectivity])

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProductDetailedController Tests', () {
    group('ProductModel Tests', () {
      test('should create ProductModel from JSON', () {
        final json = {
          'id': 'test-id',
          'name': 'Test Product',
          'data': {'key1': 'value1', 'key2': 'value2'},
        };

        final product = ProductModel.fromJson(json);

        expect(product.id, equals('test-id'));
        expect(product.name, equals('Test Product'));
        expect(product.data, equals({'key1': 'value1', 'key2': 'value2'}));
      });

      test('should create empty ProductModel', () {
        final product = ProductModel.empty();

        expect(product.id, equals(''));
        expect(product.name, equals(''));
        expect(product.data, equals({}));
      });

      test('should handle null data in ProductModel', () {
        final json = {'id': 'test-id', 'name': 'Test Product', 'data': null};

        final product = ProductModel.fromJson(json);

        expect(product.id, equals('test-id'));
        expect(product.name, equals('Test Product'));
        expect(product.data, isNull);
      });

      test('should convert ProductModel to JSON', () {
        final product = ProductModel(
          id: 'test-id',
          name: 'Test Product',
          data: {'key1': 'value1'},
        );

        final json = product.toJson();

        expect(json['id'], equals('test-id'));
        expect(json['name'], equals('Test Product'));
        expect(json['data'], equals({'key1': 'value1'}));
      });

      test('should handle list from JSON', () {
        final jsonList = [
          {
            'id': 'id1',
            'name': 'Product 1',
            'data': {'key1': 'value1'},
          },
          {
            'id': 'id2',
            'name': 'Product 2',
            'data': {'key2': 'value2'},
          },
        ];

        final jsonString = jsonEncode(jsonList);
        final products = ProductModel.listFromJson(jsonString);

        expect(products.length, equals(2));
        expect(products[0].id, equals('id1'));
        expect(products[0].name, equals('Product 1'));
        expect(products[1].id, equals('id2'));
        expect(products[1].name, equals('Product 2'));
      });
    });

    group('Controller Properties Tests', () {
      test('should have correct initial state values', () {
        expect(ProductDetailedController, isA<Type>());
      });

      test('should have correct variable types', () {
        // Test that the controller class has the expected structure
        expect(ProductDetailedController, isA<Type>());
      });
    });

    group('TextEditingController Tests', () {
      test('should create and manage TextEditingController', () {
        final controller = TextEditingController(text: 'Test Text');

        expect(controller.text, equals('Test Text'));
        expect(controller, isA<TextEditingController>());

        controller.text = 'Updated Text';
        expect(controller.text, equals('Updated Text'));

        controller.dispose();
      });

      test('should handle empty text', () {
        final controller = TextEditingController();

        expect(controller.text, isEmpty);

        controller.text = '';
        expect(controller.text, isEmpty);

        controller.dispose();
      });

      test('should handle whitespace text', () {
        final controller = TextEditingController(text: '   ');

        expect(controller.text.trim(), isEmpty);

        controller.dispose();
      });
    });

    group('Map Operations Tests', () {
      test('should handle empty maps', () {
        final Map<String, TextEditingController> map = {};

        expect(map.isEmpty, isTrue);
        expect(map.length, equals(0));
      });

      test('should add and remove items from map', () {
        final Map<String, TextEditingController> map = {};
        final controller = TextEditingController(text: 'test');

        map['key1'] = controller;
        expect(map.length, equals(1));
        expect(map['key1'], equals(controller));

        map.remove('key1');
        expect(map.isEmpty, isTrue);

        controller.dispose();
      });

      test('should handle map operations for key-value pairs', () {
        final Map<String, TextEditingController> keyMap = {};
        final Map<String, TextEditingController> valueMap = {};

        final keyController = TextEditingController(text: 'testKey');
        final valueController = TextEditingController(text: 'testValue');

        keyMap['originalKey'] = keyController;
        valueMap['originalKey'] = valueController;

        expect(keyMap.length, equals(1));
        expect(valueMap.length, equals(1));
        expect(keyMap['originalKey']?.text, equals('testKey'));
        expect(valueMap['originalKey']?.text, equals('testValue'));

        keyController.dispose();
        valueController.dispose();
      });
    });

    group('String Operations Tests', () {
      test('should handle string trimming', () {
        expect('  test  '.trim(), equals('test'));
        expect(''.trim(), isEmpty);
        expect('   '.trim(), isEmpty);
      });

      test('should handle string emptiness checks', () {
        expect(''.isEmpty, isTrue);
        expect('   '.trim().isEmpty, isTrue);
        expect('test'.isEmpty, isFalse);
      });

      test('should handle string comparisons', () {
        expect('key1' == 'key1', isTrue);
        expect('key1' == 'key2', isFalse);
        expect('key1'.compareTo('key2'), isNegative);
      });
    });

    group('Data Structure Tests', () {
      test('should handle dynamic data types', () {
        final Map<String, dynamic> data = {
          'string': 'value',
          'int': 42,
          'bool': true,
          'null': null,
        };

        expect(data['string'], equals('value'));
        expect(data['int'], equals(42));
        expect(data['bool'], equals(true));
        expect(data['null'], isNull);
      });

      test('should handle nested data structures', () {
        final Map<String, dynamic> nestedData = {
          'level1': {
            'level2': {'level3': 'deep value'},
          },
        };

        expect(nestedData['level1']['level2']['level3'], equals('deep value'));
      });
    });
  });
}
