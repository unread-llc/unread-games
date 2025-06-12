import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../logic/grid_controller.dart';

class GridScreen extends StatelessWidget {
  const GridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller.
    final GridController controller = Get.put(GridController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Level: ${controller.state.currentLevel.name}')),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              final level = controller.state.currentLevel;
              final size = level.size;

              return GridView.builder(
                itemCount: size * size,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: size,
                ),
                itemBuilder: (context, index) {
                  final x = index % size;
                  final y = index ~/ size;
                  final key = '$x,$y';

                  final numberedCell = level.cells.firstWhereOrNull(
                    (cell) => cell.x == x && cell.y == y,
                  );

                  return Obx(() {
                    // --- THIS IS THE FIX ---
                    // We now access the 'path' list from inside the 'state' object.
                    final isVisited = controller.state.path.contains(key);

                    return GestureDetector(
                      onTap: () => controller.onCellTap(x, y),
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isVisited ? Colors.green.shade400 : Colors.grey[300],
                          border: Border.all(color: Colors.black54),
                        ),
                        child: Center(
                          child: numberedCell != null
                              ? Text(
                                  '${numberedCell.number}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    );
                  });
                },
              );
            }),
            Obx(() {
              if (controller.state.levelCompleted.value) {
                return Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Level Complete!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => controller.goToNextLevel(),
                          child: const Text('Next Level'),
                        )
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}