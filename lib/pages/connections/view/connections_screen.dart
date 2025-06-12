import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../logic/connections_controller.dart';

class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConnectionsController());
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: controller.loadFromJson('assets/data/connections_level1.json'),
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text(
              "Үгийн сүлбээ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            elevation: 3,
            centerTitle: true,
          ),
          body: Column(
            children: [
              // Прогрессын самбар
              Obx(() => Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.indigo.withOpacity(0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Олдсон: ${controller.foundGroups.length}/4",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo,
                          ),
                        ),
                        Text(
                          "Оноо: ${controller.score.value}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  )),
              // Олдсон группын харагдац
              Obx(() => controller.foundGroups.isNotEmpty
                  ? Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.foundGroups.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Chip(
                              label: Text(
                                controller.foundGroups[index].join(", "),
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.greenAccent.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox.shrink()),
              // Тоглоомын самбар
              Expanded(
                child: Obx(() => GridView.count(
                      crossAxisCount: screenWidth > 600 ? 6 : 4,
                      padding: const EdgeInsets.all(16),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.2,
                      children: controller.words.map((item) {
                        return GestureDetector(
                          onTap: item.isDisabled.value
                              ? null
                              : () => controller.toggleWord(item),
                          child: Obx(() => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                transform: Matrix4.identity()
                                  ..scale(item.isSelected.value ? 1.05 : 1.0),
                                decoration: BoxDecoration(
                                  color: item.isDisabled.value
                                      ? Colors.grey[400]
                                      : item.isSelected.value
                                          ? Colors.indigoAccent
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  item.word,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: item.isSelected.value
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        );
                      }).toList(),
                    )),
              ),
              // Шалгах товч
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: ElevatedButton(
                  onPressed: controller.currentSelection.length < 4
                      ? null
                      : () {
                          final correct = controller.checkSelection();
                          Get.dialog(
                            Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedScale(
                                      scale: correct ? 1.2 : 1.0,
                                      duration: const Duration(milliseconds: 300),
                                      child: Icon(
                                        correct ? Icons.check_circle : Icons.close,
                                        size: 60,
                                        color: correct ? Colors.green : Colors.red,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      correct
                                          ? controller.foundGroups.length == 4
                                              ? "🎉 Баяр хүргэе! Бүх группийг оллоо!"
                                              : "✅ Зөв!"
                                          : "❌ Дахин оролд!",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (correct &&
                                            controller.foundGroups.length == 4) {
                                          controller.resetGame();
                                        } else {
                                          controller.resetSelection();
                                        }
                                        Get.back();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.indigo,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        controller.foundGroups.length == 4
                                            ? "Дахин эхлэх"
                                            : "OK",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            transitionDuration: const Duration(milliseconds: 300),
                            transitionCurve: Curves.easeInOut,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text("Шалгах"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
