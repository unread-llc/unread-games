import 'package:get/get.dart';

import '../../api/my_rest_client.dart';
import '../../storage/my_storage.dart';
import '../suite/core_routes.dart';
import '../suite/core_screen_type.dart';

class CoreService extends GetxService {
  final Rx<CoreScreenType> currentScreen = CoreScreenType.splash.obs;
  final RxMap<String, dynamic> userData = RxMap({});
  final RxMap<String, dynamic> companyData = RxMap({});
  Worker? screenChangeWorker;
  final RxMap<String, double?> currentPosition = RxMap({});

  Future<void> fetchUserData() async {
    var (isSuccess, data) = await MyRestClient.instance.sendRequest(url: '/user');

    if (isSuccess) {
      dynamic userInfo = data['data']['user'];
      dynamic companyInfo = data['data']['company'];
      userData.value = userInfo;
      companyData.value = companyInfo;
      userData.refresh();
      companyData.refresh();
      MyStorage.instance.saveData('user', userInfo);
      MyStorage.instance.saveData('company', companyInfo);
    }
  }

  @override
  void onReady() {
    screenChangeWorker?.dispose();
    screenChangeWorker = ever(currentScreen, (CoreScreenType screen) async {
      switch (screen) {
        case CoreScreenType.splash:
          _checkToken();
          break;
        case CoreScreenType.onboarding:
        case CoreScreenType.auth:
          break;
        case CoreScreenType.main:
          userData.value = Map<String, dynamic>.from(MyStorage.instance.getData('user') ?? {});
          companyData.value = Map<String, dynamic>.from(MyStorage.instance.getData('company') ?? {});

          break;
      }
    });
    _checkToken();
    super.onReady();
  }

  ///Use this function on the screen to listen to the location changes
  Worker addLocationListener(Function(Map<String, double?>? location) onLocationChanged) {
    return ever(currentPosition, onLocationChanged);
  }

  void _checkToken() async {
    String? token = MyStorage.instance.getData('token');

    await Future.delayed(const Duration(seconds: 2));
    if ((token ?? '').isNotEmpty) {
      changeToMainScreen();
      return;
    }
    changeToAuthScreen();
  }

  /// Change the screen to home screen
  void changeToMainScreen() {
    currentScreen.value = CoreScreenType.main;
  }

  /// Change the screen to auth screen
  void changeToAuthScreen() {
    currentScreen.value = CoreScreenType.auth;
  }

  /// Change the screen to splash screen
  void changeToSplashScreen() {
    currentScreen.value = CoreScreenType.splash;
  }

  void logout() {
    Get.until((route) => Get.currentRoute == CoreRoutes.coreScreen);
    MyStorage.instance.saveData('token', null);
    changeToAuthScreen();
  }

  @override
  void onClose() {
    screenChangeWorker?.dispose();
    super.onClose();
  }
}
