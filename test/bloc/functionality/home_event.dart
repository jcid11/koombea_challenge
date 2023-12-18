import 'package:koombea_test/bloc/functionality/home_event.dart';
import 'package:test/test.dart';

void main() {
  group('HomeEvent', () {
    test('instances with the same props should be equal', () {
      const event1 = HomeEvent;
      const event2 =HomeEvent;

      expect(event1, equals(event2));
    });

    test('instances with different props should not be equal', () {
      const event1 = HomeEvent;
      final event2 = DeleteUserEvent(userID: 1);

      expect(event1, isNot(equals(event2)));
    });
  });
}
