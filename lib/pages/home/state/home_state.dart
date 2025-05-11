import 'package:get/get.dart';

enum LetterStatus { initial, correct, present, absent }

class HomeState {
  final RxList<List<Map<String, dynamic>>> guesses = <List<Map<String, dynamic>>>[].obs;
  final RxString currentGuess = ''.obs;
  final RxString targetWord = 'FLUTTER'.obs; // Example target word
  final RxBool isGameOver = false.obs;
  final RxBool hasWon = false.obs;
  final RxMap<String, LetterStatus> keyboardLetterStatus = <String, LetterStatus>{}.obs;

  HomeState() {
    // Initialize keyboard status
    for (var letter in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')) {
      keyboardLetterStatus[letter] = LetterStatus.initial;
    }
  }
}
