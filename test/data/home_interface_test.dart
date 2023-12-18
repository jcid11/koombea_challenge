import 'package:koombea_test/data/home_interface.dart';
import 'package:koombea_test/utils/ws_response.dart';
import 'package:test/test.dart';

class MockHomeInterface extends HomeInterface {
  @override
  Future<WsResponse> getAllUser() async {
    // Replace with your mock implementation for getAllUser
    return WsResponse(success: true);
  }

  @override
  Future<WsResponse> addUser({
    required String name,
    required String lastName,
    required String userName,
  }) async {
    // Replace with your mock implementation for addUser
    return WsResponse(success: true);
  }

  @override
  Future<WsResponse> deleteUser({required int id}) async {
    // Replace with your mock implementation for deleteUser
    return WsResponse(success: true);
  }
}

void main() {
  group('HomeInterface Tests', () {
    test('getAllUser should return a WsResponse', () async {
      final homeInterface = MockHomeInterface();
      final result = await homeInterface.getAllUser();
      expect(result, isA<WsResponse>());
    });

    test('addUser should return a WsResponse', () async {
      final homeInterface = MockHomeInterface();
      final result = await homeInterface.addUser(
        name: 'John',
        lastName: 'Doe',
        userName: 'john_doe',
      );
      expect(result, isA<WsResponse>());
    });

    test('deleteUser should return a WsResponse', () async {
      final homeInterface = MockHomeInterface();
      final result = await homeInterface.deleteUser(id: 1);
      expect(result, isA<WsResponse>());
    });
  });
}
