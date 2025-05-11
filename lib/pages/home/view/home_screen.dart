import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../logic/home_controller.dart';
import '../state/home_state.dart'; // Import HomeState

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Wordle Game'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: controller.resetGame,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Display guesses
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.state.guesses.length,
                    itemBuilder: (context, index) {
                      final guessAttempt = controller.state.guesses[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: guessAttempt.map<Widget>((letterMap) {
                          final char = letterMap['char'] as String;
                          final status = letterMap['status'] as LetterStatus;
                          return Container(
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: controller.getLetterColor(status),
                              border: Border.all(color: Colors.black54),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                char,
                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                // Display current guess
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(controller.state.targetWord.value.length, (index) {
                      final char = index < controller.state.currentGuess.value.length ? controller.state.currentGuess.value[index] : '';
                      return Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            char,
                            style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }),
                  );
                }),
                const SizedBox(height: 20),
                // Keyboard
                _buildKeyboard(controller),
                const SizedBox(height: 10),
                // Submit and Delete buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.backspace_outlined),
                      onPressed: controller.removeLetter,
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      onPressed: controller.submitGuess,
                      label: const Text('Submit'),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                    ),
                  ],
                ),
                if (controller.state.isGameOver.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: [
                        Text(
                          controller.state.hasWon.value ? 'You Won!' : 'Game Over!',
                          style:
                              TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: controller.state.hasWon.value ? Colors.green : Colors.red),
                        ),
                        if (!controller.state.hasWon.value)
                          Text(
                            'The word was: ${controller.state.targetWord.value}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ElevatedButton(onPressed: controller.resetGame, child: const Text('Play Again'))
                      ],
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeyboard(HomeController controller) {
    const List<String> row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
    const List<String> row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
    const List<String> row3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

    return Obx(() => Column(
          // Wrap with Obx to rebuild keyboard on status change
          children: [
            _buildKeyboardRow(row1, controller),
            _buildKeyboardRow(row2, controller),
            _buildKeyboardRow(row3, controller),
          ],
        ));
  }

  Widget _buildKeyboardRow(List<String> letters, HomeController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map((letter) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.getKeyboardKeyColor(letter),
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () => controller.addLetter(letter),
              child: Text(letter, style: const TextStyle(color: Colors.white)),
            ),
          ),
        );
      }).toList(),
    );
  }
}
