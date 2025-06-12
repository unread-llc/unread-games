// logic/grid_controller.dart

// ignore_for_file: avoid_print

import 'package:get/get.dart';
import '../state/grid_state.dart';
import '../logic/level_data.dart'; // Import for GridCell

class GridController extends GetxController {
  final state = GridState();
List<String> get _targetKeys =>
    _targetCells.map((cell) => '${cell.x},${cell.y}').toList();

  // A computed property to easily get the sorted list of target cells for the current level
  List<GridCell> get _targetCells => state.currentLevel.cells;

  @override
  void onInit() {
    super.onInit();
    // Sort the cells in each level by their number. This is crucial for our logic.
    for (var level in gridLevels) {
      level.cells.sort((a, b) => a.number.compareTo(b.number));
    }
    state.resetCurrentLevel();
  }

  void onCellTap(int x, int y) {
    if (state.levelCompleted.value) return; // Ignore taps if level is won

    final key = '$x,$y';
    final path = state.path;

    // --- LOGIC FOR THE VERY FIRST TAP ---
    if (path.isEmpty) {
      final firstCell = _targetCells.first;
      // The first tap must be on the cell with number 1
      if (x == firstCell.x && y == firstCell.y) {
        _addCellToPath(key);
      }
      return; // End of turn
    }

    // --- LOGIC FOR SUBSEQUENT TAPS ---
    final lastCellKey = state.lastTappedCell.value!;
    
    // Disallow tapping the same cell twice in a row
    if (key == lastCellKey) return;
    
    // A move is only valid if it's adjacent to the last tapped cell
    final lastCoords = lastCellKey.split(',').map(int.parse).toList();
    final isAdjacent = (x == lastCoords[0] && (y - lastCoords[1]).abs() == 1) ||
                       (y == lastCoords[1] && (x - lastCoords[0]).abs() == 1);

if (!path.contains(key)) {
  final expectedNextIndex = path.length;
  final expectedNextKey = _targetKeys[expectedNextIndex];

  if (key == expectedNextKey) {
    _addCellToPath(key);
    checkWinCondition();
  }
}

  }

  void _addCellToPath(String key) {
    state.path.add(key);
    state.lastTappedCell.value = key;
  }

void checkWinCondition() {
  if (state.path.length != _targetCells.length) return;

  final expectedPath = _targetCells.map((c) => '${c.x},${c.y}').toList();

  // Must match in exact order
  for (int i = 0; i < expectedPath.length; i++) {
    if (state.path[i] != expectedPath[i]) return;
  }

  state.levelCompleted.value = true;
  print("Level Complete!");
}


  // This is called by the "Next Level" button on the win screen.
  // This is a much better user experience than an automatic delay.
  void goToNextLevel() {
    state.goToNextLevel();
  }
}