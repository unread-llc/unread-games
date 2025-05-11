import 'package:get/get.dart';
import '../state/home_state.dart';

class HomeController extends GetxController {
  final HomeState state = HomeState();

  void addLetter(String letter) {
    if (state.currentGuess.value.length < state.targetWord.value.length) {
      state.currentGuess.value += letter;
    }
  }

  void removeLetter() {
    if (state.currentGuess.value.isNotEmpty) {
      state.currentGuess.value = state.currentGuess.value.substring(0, state.currentGuess.value.length - 1);
    }
  }

  void submitGuess() {
    if (state.currentGuess.value.length == state.targetWord.value.length) {
      state.guesses.add(state.currentGuess.value);
      if (state.currentGuess.value == state.targetWord.value) {
        state.isGameOver.value = true;
      }
      state.currentGuess.value = '';
    }
  }
}
