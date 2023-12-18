import 'package:koombea_test/utils/ws_response.dart';
import 'package:test/test.dart';

void main() {
  group('WsResponse', () {
    test('Create a successful response', () {
      var response = WsResponse(
        message: 'Request successful',
        data: {'key': 'value'},
        success: true,
        statusCode: 200,
      );

      expect(response.message, 'Request successful');
      expect(response.data, {'key': 'value'});
      expect(response.success, true);
      expect(response.statusCode, 200);
    });

    test('Create a failed response', () {
      var response = WsResponse(
        message: 'Error occurred',
        data: null,
        success: false,
        statusCode: 404,
      );

      expect(response.message, 'Error occurred');
      expect(response.data, isNull);
      expect(response.success, false);
      expect(response.statusCode, 404);
    });
  });
}
