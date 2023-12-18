import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:koombea_test/models/user_model.dart';
import 'package:koombea_test/service/home_service.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('HomeService Tests', () {
    late HomeService homeService;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      homeService = HomeService(client: mockHttpClient);
    });

    test('getAllUser should return a list of UserModel on success', () async {
      // Arrange
      final responseJson = [
        {
          'firstName': 'John',
          'lastName': 'Doe',
          'pictureURL': 'https://example.com/image.jpg',
          'twitterHandle': '@john_doe'
        },
        // Add more user data as needed
      ];

      when(() => mockHttpClient
              .get(Uri.parse('https://jserver-api.herokuapp.com/users')))
          .thenAnswer((_) async {
        return http.Response(jsonEncode(responseJson), 200);
      });

      // Act
      final result = await homeService.getAllUser();

      // Assert
      expect(result.success, true);
      expect(result.data, isA<List<UserModel>>());
    });

    test('getAllUser fails', () async {
      final responseJson = [
        {
          'firstName': 'John',
          'lastName': 'Doe',
          'pictureURL': 'https://example.com/image.jpg',
          'twitterHandle': '@john_doe'
        },
        // Add more user data as needed
      ];
      when(() => mockHttpClient
          .get(Uri.parse('https://jserver-api.herokuapp.com/users'))).thenAnswer((_) async {
        return http.Response(jsonEncode(responseJson), 400);
      });

      // Act
      final result = await homeService.getAllUser();

      // Assert
      expect(result.success, false);
    });

    // test('getAllUser throws exception', () async {
    //   when(() => mockHttpClient
    //           .get(Uri.parse('https://jserver-api.herokuapp.com/users')))
    //       .thenThrow(Exception('fail to get user'));
    //
    //   // Act
    //   final result = await homeService.getAllUser();
    //
    //   // Assert
    //   expect(()=>result,throwsA(isA<Exception>()));
    // });

    test('addUser should return success true on successful user addition',
        () async {
      // Arrange
      when(() => mockHttpClient.post(
          Uri.parse('https://jserver-api.herokuapp.com/users'),
          body: any(named: 'body'))).thenAnswer((_) async {
        return http.Response('', 201);
      });

      // Act
      final result = await homeService.addUser(
        name: 'John',
        lastName: 'Doe',
        userName: '@john_doe',
      );

      // Assert
      expect(result.success, true);
    });

    test('addUser fails',
            () async {
          // Arrange
          when(() => mockHttpClient.post(
              Uri.parse('https://jserver-api.herokuapp.com/users'),
              body: any(named: 'body'))).thenAnswer((_) async {
            return http.Response('', 400);
          });

          // Act
          final result = await homeService.addUser(
            name: 'John',
            lastName: 'Doe',
            userName: '@john_doe',
          );

          // Assert
          expect(result.success, false);
        });

    test('deleteUser should return success true on successful user deletion',
        () async {
      const int testId = 1;
      // Arrange
      when(() => mockHttpClient.delete(
              Uri.parse('https://jserver-api.herokuapp.com/users/$testId')))
          .thenAnswer((_) async {
        return http.Response('', 200);
      });

      // Act
      final result = await homeService.deleteUser(id: testId);

      // Assert
      expect(result.success, true);
    });

    test('deleteUser fails',
            () async {
          const int testId = 1;
          // Arrange
          when(() => mockHttpClient.delete(
              Uri.parse('https://jserver-api.herokuapp.com/users/$testId')))
              .thenAnswer((_) async {
            return http.Response('', 400);
          });

          // Act
          final result = await homeService.deleteUser(id: testId);

          // Assert
          expect(result.success, false);
        });
  });
}
