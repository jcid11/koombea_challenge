import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koombea_test/bloc/functionality/home_bloc.dart';
import 'package:koombea_test/bloc/user/user_bloc.dart';
import 'package:koombea_test/service/home_service.dart';
import 'package:koombea_test/ui/home_page.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (_)=>HomeBloc(homeService: HomeService())),
    BlocProvider(create: (_)=>UserBloc(homeService: HomeService())),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}


