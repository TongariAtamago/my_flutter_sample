import 'package:flutter/material.dart';
import 'maze_builder.dart';
import 'maze_solver.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // 迷路の状態を一元管理する
  List<List<int>> maze = List.generate(5, (i) => List.generate(5, (j) => 0));

  void _updateMaze(List<List<int>> newMaze) {
    setState(() {
      maze = newMaze;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          MazeSolver(maze: maze, idx: _selectedIndex),
          MazeBuilder(maze: maze, onMazeUpdated: _updateMaze),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'Solve Maze',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Build Maze',
          ),
        ],
      ),
    );
  }
}
