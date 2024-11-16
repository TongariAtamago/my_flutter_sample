import 'package:flutter/material.dart';
import 'dart:math';

class MazeBuilder extends StatefulWidget {
  final List<List<int>> maze;
  final Function(List<List<int>>) onMazeUpdated;

  const MazeBuilder(
      {super.key, required this.maze, required this.onMazeUpdated});

  @override
  State<MazeBuilder> createState() => _MazeBuilderState();
}

class _MazeBuilderState extends State<MazeBuilder> {
  late List<List<int>> maze;
  int rows = 5;
  int cols = 5;
  final random = Random();

  @override
  void initState() {
    super.initState();
    maze = List<List<int>>.generate(
        widget.maze.length, (i) => List<int>.from(widget.maze[i]));

    rows = maze.length;
    cols = maze[0].length;
  }

  void _updateMazeSize(int newRows, int newCols) {
    setState(() {
      rows = newRows;
      cols = newCols;
      maze = List<List<int>>.generate(
          rows, (i) => List<int>.generate(cols, (j) => 0));
    });
  }

  void _placeRandomObstacles() {
    setState(() {
      _updateMazeSize(random.nextInt(8) + 3, random.nextInt(8) + 3);
      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          if (i == 0 && j == 0) {
            continue;
          } else if (i == rows - 1 && j == cols - 1) {
            continue;
          }
          maze[i][j] = random.nextDouble() > 0.7 ? 1 : 0;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maze Builder"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < rows; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int j = 0; j < cols; j++)
                          GestureDetector(
                            onTap: () {
                              if (i == 0 && j == 0 ||
                                  i == rows - 1 && j == cols - 1) {
                                return;
                              }
                              setState(() {
                                maze[i][j] = maze[i][j] == 0 ? 1 : 0;
                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              margin: const EdgeInsets.all(2),
                              color: (i == 0 && j == 0)
                                  ? Colors.blue
                                  : (i == rows - 1 && j == cols - 1)
                                      ? Colors.red
                                      : maze[i][j] == 0
                                          ? Colors.grey[300]
                                          : Colors.black,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Rows"),
                    Expanded(
                      child: Slider(
                        value: rows.toDouble(),
                        min: 3,
                        max: 10,
                        divisions: 7,
                        onChanged: (value) {
                          _updateMazeSize(value.toInt(), cols);
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Columns"),
                    Expanded(
                      child: Slider(
                        value: cols.toDouble(),
                        min: 3,
                        max: 10,
                        divisions: 7,
                        onChanged: (value) {
                          _updateMazeSize(rows, value.toInt());
                        },
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onMazeUpdated(maze);
                  },
                  child: const Text("Save Maze"),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _placeRandomObstacles, child: const Icon(Icons.casino)),
    );
  }
}
