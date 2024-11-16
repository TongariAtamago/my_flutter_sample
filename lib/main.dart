import 'package:flutter/material.dart';
import 'screens/main_page.dart';

void main() {
  runApp(const MazeApp());
}

class MazeApp extends StatelessWidget {
  const MazeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maze',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}
