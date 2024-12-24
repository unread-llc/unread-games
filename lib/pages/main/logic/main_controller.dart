import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../state/main_state.dart';

class MainController extends GetxController with WidgetsBindingObserver {
  final MainState state = MainState();

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  void onPageChanged(int index) {
    state.currentPage.value = index;
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
