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
  late HomeBloc homeBloc;
  setUp(() {
    homeService = MockService();
    homeBloc=MockHomeBloc(homeService: homeService);
    userBloc = MockUserBloc(homeService: homeService);
  });

  testWidgets('It loads everything on screen', (WidgetTester tester) async {
    when(() => homeBloc.state).thenReturn(const HomeState());
    // when(authBloc.state).thenReturn(AuthenticationAuthenticated());
    await tester.runAsync(() async =>
        mockNetworkImagesFor(() async => await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: userBloc),
              BlocProvider.value(value: homeBloc),
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
    expect(find.byType(RawMaterialButton), findsOneWidget);
    await tester.runAsync(() async {
      await tester.press(find.byType(RawMaterialButton));
    });
  });




  testWidgets('AddUserScreen UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>(
              create: (context) => HomeBloc(homeService: homeService),
            ),
          ],
          child: const AddUserScreen(),
        ),
      ),
    );

    // Verify that the UI is rendered correctly.
    expect(find.text('Adding user screen'), findsOneWidget);
    expect(find.text('Save user information'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Last name'), findsOneWidget);
    expect(find.text('User Name'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('AddUserScreen Form Validation Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>(
              create: (context) => HomeBloc(homeService: homeService),
            ),
          ],
          child: const AddUserScreen(),
        ),
      ),
    );

    // Enter valid data and check form validity.
    await tester.enterText(find.byType(TextFormField).at(0), 'John');
    await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
    await tester.enterText(find.byType(TextFormField).at(2), 'john_doe');


  });

  testWidgets('AddUserScreen BlocListener Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>(
              create: (context) => HomeBloc(homeService: homeService),
            ),
          ],
          child: const AddUserScreen(),
        ),
      ),
    );

    // Trigger loading state in HomeBloc.
    BlocProvider.of<HomeBloc>(tester.element(find.byType(AddUserScreen))).add(AddUserToListEvent(
      name: 'John',
      lastName: 'Doe',
      userName: 'john_doe',
    ));
    await tester.pumpAndSettle();

    // Verify that loading dialog is shown.
    expect(find.byType(AlertDialog), findsOneWidget);
  });

}
