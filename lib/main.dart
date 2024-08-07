import 'package:flutter/material.dart';
import 'package:mobx_mvvm_architecture_weather_app/view/todo_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TodoList App',
      home: TodoExample(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
