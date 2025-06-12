import 'package:get/get.dart';
import '../logic/level_data.dart';

class GridState {
  final currentLevelIndex = 0.obs;
  final levelCompleted = false.obs;
  final path = <String>[].obs;
  final lastTappedCell = Rxn<String>();

  GridLevel get currentLevel => gridLevels[currentLevelIndex.value];

  void goToNextLevel() {
    currentLevelIndex.value = (currentLevelIndex.value + 1) % gridLevels.length;
    resetCurrentLevel();
  }

  void resetCurrentLevel() {
    levelCompleted.value = false;
    path.clear();
    lastTappedCell.value = null;
  }
}