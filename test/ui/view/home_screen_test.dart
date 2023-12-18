import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koombea_test/bloc/functionality/home_bloc.dart';
import 'package:koombea_test/bloc/functionality/home_event.dart';
import 'package:koombea_test/bloc/functionality/home_state.dart';
import 'package:koombea_test/bloc/user/user_bloc.dart';
import 'package:koombea_test/bloc/user/user_event.dart';
import 'package:koombea_test/bloc/user/user_state.dart';
import 'package:koombea_test/models/user_model.dart';
import 'package:koombea_test/service/home_service.dart';
import 'package:koombea_test/ui/add_user/add_user_screen.dart';
import 'package:koombea_test/ui/user_detail/user_detail_screen.dart';
import 'package:koombea_test/ui/view/home_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {
  MockUserBloc({required HomeService homeService}) : super();
}

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {
  MockHomeBloc({required HomeService homeService}) : super();
}

class MockService extends Mock implements HomeService {}

void main() {
  late UserBloc userBloc;
  late HomeService homeService;

  setUp(() {
    homeService = MockService();

    userBloc = MockUserBloc(homeService: homeService);
  });
  testWidgets('Checking that CircularProgressIndicator functions',
      (WidgetTester tester) async {
    when(() => userBloc.state).thenReturn(UserListLoading());
    await tester.runAsync(() async =>
        mockNetworkImagesFor(() async => await tester.pumpWidget(MaterialApp(
              home: BlocProvider.value(
                  value: userBloc, child: const HomeScreen()),
            ))));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Checking that userlist loads that sents to UserDetailScreen', (WidgetTester tester) async {
    when(() => userBloc.state).thenReturn(UserListSuccess([
      UserModel(
          firstName: 'john', lastName: 'john', image: 'john', userName: 'john')
    ]));
    await tester.runAsync(() async =>
        mockNetworkImagesFor(() async => await tester.pumpWidget(MaterialApp(
              home: BlocProvider.value(
                  value: userBloc, child: const HomeScreen()),
            ))));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(GestureDetector), findsWidgets);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(SizedBox).first, findsOneWidget);

    await tester.runAsync(() async {
      await tester.tap(find.byType(GestureDetector).first, warnIfMissed: false);
    });
    await tester.pumpAndSettle();
    await tester.runAsync(() async =>
        mockNetworkImagesFor(() async => await tester.pumpWidget(MaterialApp(
              home: MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: UserBloc(homeService: homeService)),
                  BlocProvider.value(value: HomeBloc(homeService: homeService)),
                ],
                child: UserDetailScreen(
                    index: 0,
                    userModel: UserModel(
                        firstName: 'john',
                        lastName: 'john',
                        image: 'john',
                        userName: 'john')),
              ),
            ))));
    expect(find.byType(UserDetailScreen), findsOneWidget);
  });

  testWidgets('Checking that userlist loads that sents to AddUserScreen', (WidgetTester tester) async {
    when(() => userBloc.state).thenReturn(UserListSuccess([
      UserModel(
          firstName: 'john', lastName: 'john', image: 'john', userName: 'john')
    ]));
    // when(authBloc.state).thenReturn(AuthenticationAuthenticated());
    await tester.runAsync(() async =>
        mockNetworkImagesFor(() async => await tester.pumpWidget(MaterialApp(
          home: BlocProvider.value(
              value: userBloc, child: const HomeScreen()),
        ))));

    expect(find.byType(FloatingActionButton), findsOneWidget);
    await tester.runAsync(() async {
      await tester.press(find.byType(FloatingActionButton));

    });
    await tester.pumpAndSettle();
    await tester.runAsync(() async =>
        mockNetworkImagesFor(() async => await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: UserBloc(homeService: homeService)),
              BlocProvider.value(value: HomeBloc(homeService: homeService)),
            ],
            child: const AddUserScreen(),
          ),
        ))));
    expect(find.byType(AddUserScreen), findsOneWidget);

  });

  testWidgets('Checking that state also can fail', (WidgetTester tester) async {
    when(() => userBloc.state).thenReturn(UserListFailed());
    await tester.runAsync(() async =>
        mockNetworkImagesFor(() async => await tester.pumpWidget(MaterialApp(
              home: BlocProvider.value(
                  value: userBloc, child: const HomeScreen()),
            ))));
    expect(find.text('Something has fail here'), findsOneWidget);
  });
}
