import 'package:get/get.dart';

class HomeState {
  final RxList<String> guesses = <String>[].obs;
  final RxString currentGuess = ''.obs;
  final RxString targetWord = 'FLUTTER'.obs; // Example target word
  final RxBool isGameOver = false.obs;
}
