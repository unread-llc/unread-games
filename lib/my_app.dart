import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/suite/core_pages.dart';
import 'core/suite/core_routes.dart';
import 'storage/my_storage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String selectedLanguage = MyStorage.instance.getData('language') ?? 'mn';

    ///App pages
    List<GetPage<dynamic>> myPages = [
      ...CorePages.pages,
    ];

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: GetMaterialApp(
        title: 'Movie app',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        getPages: myPages,
        scrollBehavior: GetPlatform.isIOS ? const CupertinoScrollBehavior() : null,

        ///Localization
        locale: Locale(selectedLanguage),
        fallbackLocale: const Locale('mn'),

        defaultTransition: Transition.native,
        initialRoute: CoreRoutes.coreScreen,
      ),
    );
  }
}
