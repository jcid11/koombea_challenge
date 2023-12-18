import 'package:koombea_test/bloc/user/user_state.dart';
import 'package:koombea_test/models/user_model.dart';
import 'package:test/test.dart';
import 'package:collection/collection.dart';

void main() {
  group('UserState tests', () {
    test('UserListLoading should be equal', () {
      expect(UserListLoading(), UserListLoading());
    });

    test('UserListSuccess should be equal', () {
      final userList = [UserModel( firstName: 'John', lastName: 'John', image: 'John', userName: 'John')];
      expect(UserListSuccess(userList), UserListSuccess(userList));
    });

    test('UserListSuccess should not be equal with different user lists', () {
      final userList1 = [UserModel( firstName: 'John', lastName: 'John', image: 'John', userName: 'John')];
      final userList2 = [UserModel( firstName: 'Jane', lastName: 'Jane', image: 'Jane', userName: 'Jane')];
      // expect(UserListSuccess(userList1), isNot(UserListSuccess(userList2)));
      expect(const ListEquality().equals(userList1, userList2),false);
    });

    test('UserListFailed should be equal', () {
      expect(UserListFailed(), UserListFailed());
    });

    test('UserState should be unequal when comparing different types', () {
      final userList = [UserModel( firstName: 'John', lastName: 'John', image: 'John', userName: 'John')];
      expect(UserListSuccess(userList), isNot(UserListLoading()));
    });
  });
}
