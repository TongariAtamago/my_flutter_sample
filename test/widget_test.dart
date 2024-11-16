// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_sample/screens/maze_solver.dart';

void main() {
  testWidgets('MazeSolver renders and solves the maze',
      (WidgetTester tester) async {
    // テスト用の迷路
    final testMaze = [
      [0, 1, 1, 1, 1],
      [0, 1, 1, 1, 1],
      [0, 1, 1, 1, 1],
      [0, 1, 1, 1, 1],
      [0, 0, 0, 0, 0]
    ];

    // アプリを起動
    await tester.pumpWidget(
      MaterialApp(
        home: MazeSolver(maze: testMaze, idx: 0),
      ),
    );

    // 初期状態のウィジェットを確認
    expect(find.text("Maze Solver"), findsOneWidget);
    expect(find.text("Solving..."), findsOneWidget);

    // 迷路のセル数が正しいか確認 (5x5 = 25)
    expect(find.byType(Container), findsNWidgets(25));

    // アニメーションの進行をシミュレーション
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 解決が完了しているか確認
    expect(find.text("Maze Solved!"), findsOneWidget);
  });

  testWidgets('MazeSolver displays obstacles correctly',
      (WidgetTester tester) async {
    // 障害物付きの迷路
    final testMaze = [
      [0, 1, 0, 0, 0],
      [0, 1, 0, 1, 0],
      [0, 1, 0, 1, 0],
      [0, 0, 0, 1, 0],
      [1, 1, 1, 1, 0]
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: MazeSolver(maze: testMaze, idx: 0),
      ),
    );

    // X (障害物) が正しく表示されているか
    expect(find.text("X"), findsNWidgets(9)); // "1"が9個ある迷路

    // 解決が進行するか確認
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // ゴールに到達したら解決完了を表示
    expect(find.text("Maze Solved!"), findsOneWidget);
  });
}
