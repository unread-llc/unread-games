import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../logic/home_controller.dart';

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
          ),
          body: Column(
            children: [
              // Display guesses
              Expanded(
                child: ListView.builder(
                  itemCount: controller.state.guesses.length,
                  itemBuilder: (context, index) {
                    final guess = controller.state.guesses[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: guess.split('').map((char) {
                        final isCorrect = char == controller.state.targetWord.value[guess.indexOf(char)];
                        return Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isCorrect ? Colors.green : Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            char,
                            style: const TextStyle(color: Colors.white, fontSize: 18),
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
                  children: controller.state.currentGuess.value.padRight(controller.state.targetWord.value.length).split('').map((char) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        char,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }).toList(),
                );
              }),
              // Keyboard
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((letter) {
                  return ElevatedButton(
                    onPressed: () => controller.addLetter(letter),
                    child: Text(letter),
                  );
                }).toList(),
              ),
              // Submit and Delete buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: controller.submitGuess,
                    child: const Text('Submit'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: controller.removeLetter,
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
