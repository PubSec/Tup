import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tup/views/home_view.dart';

void main() {
  runApp(const ProviderScope(child:MyApp()));
}

// TODO: Use riverpod to transfer data across the app

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: HomeView(),
    );
  }
}
