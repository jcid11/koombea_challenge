// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koombea_test/bloc/functionality/home_bloc.dart';
import 'package:koombea_test/bloc/user/user_bloc.dart';

import 'package:koombea_test/main.dart';
import 'package:koombea_test/service/home_service.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MultiBlocProvider(providers: [
      BlocProvider(create: (_)=>HomeBloc(homeService: HomeService())),
      BlocProvider(create: (_)=>UserBloc(homeService: HomeService())),
    ], child: const MyApp()));
  });
}
