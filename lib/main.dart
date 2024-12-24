import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/logic/core_service.dart';
import 'my_app.dart';
import 'storage/my_storage.dart';

FutureOr<void> main() async {
  await Get.putAsync<CoreService>(() async => CoreService());
  await MyStorage.instance.init();
  runApp(const MyApp());
}
