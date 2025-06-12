class WordItem {
  final String word;
  bool isSelected;

  WordItem({required this.word, this.isSelected = false});
}

class ConnectionsGameState {
  List<WordItem> words = [];
  List<List<String>> correctGroups = [];
  List<String> currentSelection = [];

  void resetSelection() {
    for (var word in words) {
      word.isSelected = false;
    }
    currentSelection.clear();
  }
}
