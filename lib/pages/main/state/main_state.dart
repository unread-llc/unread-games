import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MainState {
  final RxInt currentPage = 1.obs;
  final PageController pageController = PageController(initialPage: 1);
}
