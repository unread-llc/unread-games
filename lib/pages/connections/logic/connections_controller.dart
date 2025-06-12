import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class WordItem {
  final String word;
  RxBool isSelected = false.obs;
  RxBool isDisabled = false.obs;

  WordItem({required this.word});
}

class ConnectionsController extends GetxController {
  RxList<WordItem> words = <WordItem>[].obs;
  RxList<List<String>> correctGroups = <List<String>>[].obs;
  RxList<String> currentSelection = <String>[].obs;
  RxList<List<String>> foundGroups = <List<String>>[].obs;
  RxInt score = 0.obs;

  Future<void> loadFromJson(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final data = jsonDecode(jsonString);

    words.value = (data["words"] as List)
        .map((w) => WordItem(word: w.toString()))
        .toList();

    correctGroups.value = (data["correctGroups"] as List)
        .map<List<String>>((group) => group.cast<String>())
        .toList();
  }

  void toggleWord(WordItem item) {
    if (item.isDisabled.value) return;
    item.isSelected.toggle();
    if (item.isSelected.value) {
      if (currentSelection.length < 4) {
        currentSelection.add(item.word);
      } else {
        item.isSelected.value = false;
      }
    } else {
      currentSelection.remove(item.word);
    }
  }

  bool checkSelection() {
    if (currentSelection.length != 4) return false;
    final selection = currentSelection.toList()..sort();
    for (var group in correctGroups) {
      final sortedGroup = [...group]..sort();
      if (_listEquals(selection, sortedGroup)) {
        foundGroups.add(group);
        score.value += 10; // Оноо нэмэх
        for (var word in words) {
          if (group.contains(word.word)) {
            word.isDisabled.value = true;
            word.isSelected.value = false;
          }
        }
        currentSelection.clear();
        return true;
      }
    }
    score.value -= 2; // Буруу бол оноо хасах
    return false;
  }

  void resetSelection() {
    for (var word in words) {
      if (!word.isDisabled.value) {
        word.isSelected.value = false;
      }
    }
    currentSelection.clear();
  }

  void resetGame() {
    words.clear();
    correctGroups.clear();
    foundGroups.clear();
    currentSelection.clear();
    score.value = 0;
    loadFromJson('assets/data/connections_level1.json');
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
