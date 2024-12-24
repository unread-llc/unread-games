import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pages/main/view/main_screen.dart';
import '../logic/core_service.dart';
// import '../suite/core_screen_type.dart';

class CoreScreen extends StatefulWidget {
  const CoreScreen({super.key});

  @override
  State<CoreScreen> createState() => _CoreScreenState();
}

class _CoreScreenState extends State<CoreScreen> with WidgetsBindingObserver {
  final CoreService _coreService = Get.find<CoreService>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    super.didChangeAppLifecycleState(appState);

    if (appState == AppLifecycleState.resumed) {
      _coreService.fetchUserData();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MainScreen();
    // return ObxValue(
    //   (screen) {
    //     switch (screen.value) {
    //       case CoreScreenType.main:
    //         return const MainScreen();
    //       case CoreScreenType.splash:
    //         return const Scaffold(
    //           body: Center(
    //             child: CircularProgressIndicator(),
    //           ),
    //         );
    //       // TODO: Handle this case.
    //       case CoreScreenType.onboarding:
    //         return const Scaffold(
    //           body: Center(
    //             child: CircularProgressIndicator(),
    //           ),
    //         );
    //       // TODO: Handle this case.
    //       case CoreScreenType.auth:
    //         return const Scaffold(
    //           body: Center(
    //             child: CircularProgressIndicator(),
    //           ),
    //         );
    //       // TODO: Handle this case.
    //     }
    //   },
    //   _coreService.currentScreen,
    // );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
