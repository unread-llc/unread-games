import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../state/home_state.dart';

class HomeController extends GetxController {
  final HomeState state = HomeState();
  final int maxGuesses = 6; // Max number of guesses allowed

  void addLetter(String letter) {
    if (state.isGameOver.value) return;
    if (state.currentGuess.value.length < state.targetWord.value.length) {
      state.currentGuess.value += letter;
    }
  }

  void removeLetter() {
    if (state.isGameOver.value) return;
    if (state.currentGuess.value.isNotEmpty) {
      state.currentGuess.value = state.currentGuess.value.substring(0, state.currentGuess.value.length - 1);
    }
  }

  void submitGuess() {
    if (state.isGameOver.value) return;

    final currentGuessValue = state.currentGuess.value;
    final targetWordValue = state.targetWord.value;

    if (currentGuessValue.length != targetWordValue.length) {
      Get.snackbar('Invalid Guess', 'Word must be ${targetWordValue.length} letters long.',
          snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(10));
      return;
    }

    final List<Map<String, dynamic>> guessDetails = [];
    final List<String> targetChars = targetWordValue.split('');
    final List<String> guessChars = currentGuessValue.split('');
    final List<LetterStatus> statuses = List.filled(targetWordValue.length, LetterStatus.absent);
    final Map<String, int> targetLetterCounts = {};

    for (String char in targetChars) {
      targetLetterCounts[char] = (targetLetterCounts[char] ?? 0) + 1;
    }

    // First pass: check for correct letters
    for (int i = 0; i < targetWordValue.length; i++) {
      if (guessChars[i] == targetChars[i]) {
        statuses[i] = LetterStatus.correct;
        targetLetterCounts[guessChars[i]] = (targetLetterCounts[guessChars[i]] ?? 0) - 1;
        // Update keyboard
        state.keyboardLetterStatus[guessChars[i]] = LetterStatus.correct;
      }
    }

    // Second pass: check for present letters
    for (int i = 0; i < targetWordValue.length; i++) {
      if (statuses[i] != LetterStatus.correct) {
        if (targetChars.contains(guessChars[i]) && (targetLetterCounts[guessChars[i]] ?? 0) > 0) {
          statuses[i] = LetterStatus.present;
          targetLetterCounts[guessChars[i]] = (targetLetterCounts[guessChars[i]] ?? 0) - 1;
          // Update keyboard (present is lower priority than correct)
          if (state.keyboardLetterStatus[guessChars[i]] != LetterStatus.correct) {
            state.keyboardLetterStatus[guessChars[i]] = LetterStatus.present;
          }
        } else {
          // Update keyboard (absent is lowest priority)
          if (state.keyboardLetterStatus[guessChars[i]] == LetterStatus.initial) {
            state.keyboardLetterStatus[guessChars[i]] = LetterStatus.absent;
          }
        }
      }
    }

    for (int i = 0; i < targetWordValue.length; i++) {
      guessDetails.add({'char': guessChars[i], 'status': statuses[i]});
    }

    state.guesses.add(guessDetails);

    if (currentGuessValue == targetWordValue) {
      state.isGameOver.value = true;
      state.hasWon.value = true;
      Get.snackbar('Congratulations!', 'You guessed the word!', snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(10));
    } else if (state.guesses.length >= maxGuesses) {
      state.isGameOver.value = true;
      Get.snackbar('Game Over', 'The word was: $targetWordValue', snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(10));
    }

    state.currentGuess.value = '';
    update(); // Force UI update for GetBuilder
  }

  Color getLetterColor(LetterStatus status) {
    switch (status) {
      case LetterStatus.correct:
        return Colors.green;
      case LetterStatus.present:
        return Colors.orange;
      case LetterStatus.absent:
        return Colors.grey.shade700;
      default:
        return Colors.grey.shade400;
    }
  }

  Color getKeyboardKeyColor(String letter) {
    final status = state.keyboardLetterStatus[letter] ?? LetterStatus.initial;
    switch (status) {
      case LetterStatus.correct:
        return Colors.green;
      case LetterStatus.present:
        return Colors.orange;
      case LetterStatus.absent:
        return Colors.grey.shade700;
      default: // LetterStatus.initial
        return Colors.blueGrey;
    }
  }

  void resetGame() {
    state.guesses.clear();
    state.currentGuess.value = '';
    state.isGameOver.value = false;
    state.hasWon.value = false;
    // Reset keyboard status
    for (var letter in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')) {
      state.keyboardLetterStatus[letter] = LetterStatus.initial;
    }
    // Optionally, generate a new target word here
    // state.targetWord.value = "NEWWORD";
    update();
  }
}
