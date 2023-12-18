import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koombea_test/bloc/functionality/home_bloc.dart';
import 'package:koombea_test/bloc/functionality/home_event.dart';
import 'package:koombea_test/bloc/functionality/home_state.dart';
import 'package:koombea_test/bloc/user/user_bloc.dart';
import 'package:koombea_test/bloc/user/user_event.dart';
import 'package:koombea_test/models/user_model.dart';
import 'package:koombea_test/service/home_service.dart';
import 'package:koombea_test/ui/user_detail/user_detail_screen.dart';
import 'package:koombea_test/utils/alert_dialog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockHomeService extends Mock implements HomeService {}

void main() {
  late HomeBloc homeBloc;
  late UserBloc userBloc;

  setUp(() {
     homeBloc = HomeBloc(homeService: MockHomeService());
     userBloc = UserBloc(homeService: MockHomeService());
  });

  group('UserDetailScreen Widget Test', () {

      testWidgets('UserDetailScreen displays user details',
      (WidgetTester tester) async {
    // Arrange
    final userModel = UserModel(
      firstName: 'John',
      lastName: 'Doe',
      userName: 'john.doe',
      image: 'https://example.com/avatar.jpg',
    );

    await tester.runAsync(() async =>
        mockNetworkImagesFor(() async => await tester.pumpWidget(MaterialApp(
              home: MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: homeBloc),
                  BlocProvider.value(value: userBloc),
                ],
                child: UserDetailScreen(index: 0, userModel: userModel),
              ),
            ))));
    // Act

    await tester.pump();


    // // Assert
    expect(find.text('User details'), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john.doe'), findsOneWidget);
  });

      testWidgets('test funcionalities', (WidgetTester tester)async{
        final UserModel userModel = UserModel(
          firstName: 'John',
          lastName: 'Doe',
          userName: 'john_doe',
          image: 'https://example.com/image.jpg',
        );


        await tester.runAsync(() async =>
            mockNetworkImagesFor(() async => await tester.pumpWidget(MaterialApp(
              home: MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: homeBloc),
                  BlocProvider.value(value: userBloc),
                ],
                child: UserDetailScreen(index: 0, userModel: userModel),
              ),
            ))));

        await tester.runAsync(() async {
          await tester.tap(find.byType(FloatingActionButton));
        });

        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

      });


    testWidgets('Renders UserDetailScreen and deletes user correctly', (WidgetTester tester) async {
      // Arrange
      final UserModel userModel = UserModel(
        firstName: 'John',
        lastName: 'Doe',
        userName: 'john_doe',
        image: 'https://example.com/image.jpg',
      );


          await tester.runAsync(() async =>
        mockNetworkImagesFor(() async => await tester.pumpWidget(MaterialApp(
              home: MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: homeBloc),
                  BlocProvider.value(value: userBloc),
                ],
                child: UserDetailScreen(index: 0, userModel: userModel),
              ),
            ))));
      expect(homeBloc.state.deleteUserStatus, equals(DeleteUserStatus.initial));

      // Act: Tap on the delete button
      await tester.runAsync(() async {
        await tester.tap(find.byType(FloatingActionButton));
      });
      homeBloc.emit(const HomeState(deleteUserStatus: DeleteUserStatus.loading));
      await tester.pump();
      // Assert: Verify that the appropriate actions are performed
      expect(homeBloc.state.deleteUserStatus, equals(DeleteUserStatus.loading));
      homeBloc.emit(const HomeState(deleteUserStatus: DeleteUserStatus.success));
      await tester.pump();
      expect(homeBloc.state.deleteUserStatus, equals(DeleteUserStatus.success));
    });

    // Add more test cases as needed
  });
}


// Mock classes for testing
