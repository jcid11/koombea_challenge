import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koombea_test/utils/ws_response.dart';
import 'package:mocktail/mocktail.dart';
import 'package:koombea_test/bloc/functionality/home_bloc.dart';
import 'package:koombea_test/bloc/functionality/home_event.dart';
import 'package:koombea_test/bloc/functionality/home_state.dart';
import 'package:koombea_test/service/home_service.dart';

class MockHomeService extends Mock implements HomeService {}

void main() {
  group('HomeBloc', () {
    late HomeBloc homeBloc;
    late MockHomeService mockHomeService;

    setUp(() {
      mockHomeService = MockHomeService();
      homeBloc = HomeBloc(homeService: mockHomeService);
    });

    tearDown(() {
      homeBloc.close();
    });

    test('initial state is HomeState', () {
      expect(homeBloc.state, const HomeState());
    });

    blocTest<HomeBloc, HomeState>(
        '''emits [AddUserStatusLoading,AddUserStatusLoaded] something to take in count is the fact that the deletestatus is also
        implemented in the same flow thats why it needs to be alos be declare here''',
        build: () {
          when(() => mockHomeService.addUser(
                  name: 'john', lastName: 'john', userName: 'john'))
              .thenAnswer((_) async => WsResponse(success: true));
          return HomeBloc(homeService: mockHomeService);
        },
        act: (bloc) => bloc.add(AddUserToListEvent(
            name: 'john', lastName: 'john', userName: 'john')),
        expect: () => [
              const HomeState(
                  addUserStatus: AddUserStatus.loading,
                  deleteUserStatus: DeleteUserStatus.initial),
              const HomeState(
                  addUserStatus: AddUserStatus.loaded,
                  deleteUserStatus: DeleteUserStatus.initial),
            ]);

    blocTest<HomeBloc, HomeState>('fails to add user',
        build: () {
          when(() => mockHomeService.addUser(
                  name: 'john', lastName: 'john', userName: 'john'))
              .thenAnswer((_) async => WsResponse(success: false));
          return HomeBloc(homeService: mockHomeService);
        },
        act: (bloc) => bloc.add(AddUserToListEvent(
            name: 'john', lastName: 'john', userName: 'john')),
        expect: () => [
              const HomeState(
                  addUserStatus: AddUserStatus.loading,
                  deleteUserStatus: DeleteUserStatus.initial),
              const HomeState(
                  addUserStatus: AddUserStatus.failed,
                  deleteUserStatus: DeleteUserStatus.initial),
            ]);

    blocTest<HomeBloc, HomeState>('add user throw exception',
        build: () {
          when(() => mockHomeService.addUser(
              name: 'john',
              lastName: 'john',
              userName: 'john')).thenThrow(Exception('failed'));
          return HomeBloc(homeService: mockHomeService);
        },
        act: (bloc) => bloc.add(AddUserToListEvent(
            name: 'john', lastName: 'john', userName: 'john')),
        expect: () => [
              const HomeState(
                  addUserStatus: AddUserStatus.loading,
                  deleteUserStatus: DeleteUserStatus.initial),
              const HomeState(
                  addUserStatus: AddUserStatus.failed,
                  deleteUserStatus: DeleteUserStatus.initial),
            ]);

    blocTest<HomeBloc, HomeState>('Delete user success',
        build: () {
          when(() => mockHomeService.deleteUser(id: any(named: 'id')))
              .thenAnswer((_) async => WsResponse(success: true));
          return HomeBloc(homeService: mockHomeService);
        },
        act: (bloc) => bloc.add(DeleteUserEvent(userID: 1)),
        expect: () => [
              const HomeState(
                  addUserStatus: AddUserStatus.initial,
                  deleteUserStatus: DeleteUserStatus.loading),
              const HomeState(
                  addUserStatus: AddUserStatus.initial,
                  deleteUserStatus: DeleteUserStatus.success),
            ]);

    blocTest<HomeBloc, HomeState>('Delete user fails',
        build: () {
          when(() => mockHomeService.deleteUser(id: 1))
              .thenAnswer((_) async => WsResponse(success: false));
          return HomeBloc(homeService: mockHomeService);
        },
        act: (bloc) => bloc.add(DeleteUserEvent(userID: 2)),
        expect: () => [
              const HomeState(
                  addUserStatus: AddUserStatus.initial,
                  deleteUserStatus: DeleteUserStatus.loading),
              const HomeState(
                  addUserStatus: AddUserStatus.initial,
                  deleteUserStatus: DeleteUserStatus.failed),
            ]);

    blocTest<HomeBloc, HomeState>('Delete user throw exception',
        build: () {
          when(() => mockHomeService.deleteUser(id: 1))
              .thenThrow(Exception('Delete user failed'));
          return HomeBloc(homeService: mockHomeService);
        },
        act: (bloc) => bloc.add(DeleteUserEvent(userID: 1)),
        expect: () => [
              const HomeState(
                  addUserStatus: AddUserStatus.initial,
                  deleteUserStatus: DeleteUserStatus.loading),
              const HomeState(
                  addUserStatus: AddUserStatus.initial,
                  deleteUserStatus: DeleteUserStatus.failed),
            ]);
  });
}
