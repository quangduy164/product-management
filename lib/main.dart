import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/data/blocs/product_bloc.dart';
import 'package:product_management/data/events/product_event.dart';
import 'package:product_management/data/repository/api_repository.dart';
import 'package:product_management/ui/home/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final apiRepository = ApiRepository();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => ProductBloc(apiRepository: apiRepository)..add(FetchProduct()),
        child: const HomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}