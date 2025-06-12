// logic/level_data.dart

class GridLevel {
  final String id;
  final String name;
  final int size;
  final List<GridCell> cells;

  GridLevel({required this.id, required this.name, required this.size, required this.cells});
}

class GridCell {
  final int x;
  final int y;
  final int number;

  GridCell({required this.x, required this.y, required this.number});
}

// NOTE: Numbers are now sequential (1, 2, 3...) for the connection logic to work.
List<GridLevel> gridLevels = [
  GridLevel(
    id: 'level_1',
    name: 'Intro',
    size: 5,
    cells: [
      GridCell(x: 0, y: 0, number: 1), 
      GridCell(x: 0, y: 1, number: 2)
    ],
  ),
  GridLevel(
    id: 'level_2',
    name: 'Zigzag',
    size: 5,
    cells: [
      GridCell(x: 0, y: 0, number: 1),
      GridCell(x: 2, y: 2, number: 2),
      GridCell(x: 4, y: 0, number: 3),
    ],
  ),
  GridLevel(
    id: 'level_3',
    name: 'Crossroad',
    size: 5,
    cells: [
      GridCell(x: 2, y: 2, number: 1),
      GridCell(x: 0, y: 4, number: 2),
      GridCell(x: 4, y: 0, number: 3),
    ],
  ),
];