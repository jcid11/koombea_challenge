import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koombea_test/bloc/functionality/home_bloc.dart';
import 'package:koombea_test/bloc/user/user_bloc.dart';
import 'package:koombea_test/service/home_service.dart';
import 'package:koombea_test/ui/view/home_screen.dart';
import 'package:koombea_test/ui/home_page.dart';

void main() {
  group('HomePage Widget Test', () {
    testWidgets('HomePage displays HomeScreen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MultiBlocProvider(providers: [
        BlocProvider(create: (_)=>HomeBloc(homeService: HomeService())),
        BlocProvider(create: (_)=>UserBloc(homeService: HomeService())),
      ], child: const MaterialApp(
        home: HomePage(
        ),
      )));

      // Verify that HomeScreen is present.
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}

