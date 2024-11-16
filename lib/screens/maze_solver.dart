import 'package:flutter/material.dart';
import 'dart:async';

class MazeSolver extends StatefulWidget {
  final List<List<int>> maze;
  final int idx;

  const MazeSolver({super.key, required this.maze, required this.idx});

  @override
  State<MazeSolver> createState() => _MazeSolverState();
}

class _MazeSolverState extends State<MazeSolver> {
  List<Offset> path = [];
  late List<List<bool>> visited;
  bool isSolved = false;
  bool isCanceled = false;

  late Completer<void> completer;

  @override
  void initState() {
    super.initState();
    resetSolver();
  }

  @override
  void didUpdateWidget(covariant MazeSolver oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.maze != widget.maze) {
      resetSolver();
    }
  }

  @override
  void dispose() {
    isCanceled = true;
    completer.complete();
    super.dispose();
  }

  void resetSolver() {
    if (widget.maze.isEmpty) {
      setState(() {
        isSolved = true;
        path.clear();
      });
    }
    setState(() {
      path.clear();
      isSolved = false;
      isCanceled = false;
      visited = List.generate(
        widget.maze.length,
        (i) => List.generate(widget.maze[0].length, (j) => false),
      );
    });
    completer = Completer<void>();
    if (widget.maze.isNotEmpty) {
      solveMaze(0, 0);
    }
  }

  Future<void> solveMaze(int row, int col) async {
    if (isCanceled ||
        !mounted ||
        widget.idx != 0 ||
        !isInBounds(row, col) ||
        visited[row][col] ||
        widget.maze[row][col] == 1 ||
        isSolved) {
      return;
    }

    setState(() {
      visited[row][col] = true;
      path.add(Offset(row.toDouble(), col.toDouble()));
    });

    await Future.delayed(const Duration(milliseconds: 300));

    if (row == widget.maze.length - 1 && col == widget.maze[0].length - 1) {
      if (mounted) {
        setState(() {
          isSolved = true;
        });
      }
      completer.complete();
      return;
    }

    await solveMaze(row + 1, col);
    await solveMaze(row - 1, col);
    await solveMaze(row, col + 1);
    await solveMaze(row, col - 1);

    if (!isSolved && mounted && widget.idx == 0) {
      setState(() {
        path.removeLast();
      });
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  bool isInBounds(int row, int col) {
    return widget.maze.isNotEmpty &&
        row >= 0 &&
        row < widget.maze.length &&
        col >= 0 &&
        col < widget.maze[0].length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maze Solver"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int row = 0; row < widget.maze.length; row++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int col = 0; col < widget.maze[0].length; col++)
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.all(2),
                      color: getColor(row, col),
                      child: Center(
                        child: Text(
                          row == 0 && col == 0
                              ? "S"
                              : row == widget.maze.length - 1 &&
                                      col == widget.maze[0].length - 1
                                  ? "E"
                                  : widget.maze[row][col] == 1
                                      ? "X"
                                      : "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 20),
            isSolved ? const Text("Maze Solved!") : const Text("Solving..."),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isSolved ? resetSolver : null,
        child:
            isSolved ? const Icon(Icons.refresh) : const Icon(Icons.play_arrow),
      ),
    );
  }

  Color getColor(int row, int col) {
    if (row == 0 && col == 0) {
      return Colors.blue;
    } else if (row == widget.maze.length - 1 &&
        col == widget.maze[0].length - 1) {
      return Colors.red;
    } else if (path.contains(Offset(row.toDouble(), col.toDouble()))) {
      return Colors.green;
    } else if (visited[row][col]) {
      return Colors.orange;
    } else if (widget.maze[row][col] == 1) {
      return Colors.black;
    } else {
      return Colors.grey[300]!;
    }
  }
}
