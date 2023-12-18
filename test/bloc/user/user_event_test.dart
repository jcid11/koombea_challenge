import 'package:koombea_test/bloc/user/user_event.dart';
import 'package:test/test.dart';

void main() {
  group('UserEvent tests', () {
    test('GetUserListEvent equality', () {
      final event1 = GetUserListEvent();
      final event2 = GetUserListEvent();

      // Test equality using the `==` operator
      expect(event1, equals(event2));

      // Test equality using the `hashCode`
      expect(event1.hashCode, equals(event2.hashCode));

      // Test equality using `Equatable`'s `props`
      expect(event1.props, equals(event2.props));
    });
  });
}
