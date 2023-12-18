import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koombea_test/bloc/user/user_bloc.dart';
import 'package:koombea_test/bloc/user/user_event.dart';
import 'package:koombea_test/bloc/user/user_state.dart';
import 'package:koombea_test/models/user_model.dart';
import 'package:koombea_test/service/home_service.dart';
import 'package:koombea_test/utils/ws_response.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeInterface extends Mock implements HomeService {}

void main() {
  group('UserBloc', () {
    late MockHomeInterface mockHomeService;

    setUp(() {
      mockHomeService = MockHomeInterface();
    });

    // Test when GetUserListEvent is added, it emits UserListLoading and UserListSuccess
    blocTest<UserBloc, UserState>(
      'emits [UserListLoading, UserListSuccess] when GetUserListEvent is added',
      build: () {
        when(() => mockHomeService.getAllUser()).thenAnswer(
              (_) async => WsResponse(success: true, data: [
            UserModel(
                firstName: 'john',
                lastName: 'john',
                image: 'john',
                userName: 'john')
          ]),
        );
        return UserBloc(homeService: mockHomeService);
      },
      act: (bloc) => bloc.add(GetUserListEvent()),
      expect: () => [
        UserListLoading(),
        UserListSuccess([UserModel(
            firstName: 'john',
            lastName: 'john',
            image: 'john',
            userName: 'john')]),
      ],
    );

    // Test when an error occurs, it emits UserListLoading and UserListFailed
    blocTest<UserBloc, UserState>(
      'emits [UserListLoading, UserListFailed] when an error occurs',
      build: () {
        when(() => mockHomeService.getAllUser()).thenThrow(Exception('Error'));
        return UserBloc(homeService: mockHomeService);
      },
      act: (bloc) => bloc.add(GetUserListEvent()),
      expect: () => [
        UserListLoading(),
        UserListFailed(),
      ],
    );
  });
}
