import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

class MyStorage {
  static final MyStorage _instance = MyStorage._internal();
  factory MyStorage() => _instance;

  MyStorage._internal();

  static MyStorage get instance => _instance;

  ///Local storage box
  static GetStorage? _box;
  final storage = const FlutterSecureStorage();

  ///Init local storage
  Future<void> init() async {
    try {
      await GetStorage.init();
      _box = GetStorage();
    } catch (_) {}
  }

  ///Get data from local storage
  ///Get data using [key]. If [key] is null, return null
  dynamic getData(String key) {
    if (_box == null || key.isEmpty) return null;

    return _box?.read(key);
  }

  ///Save data to local storage
  ///Save [value] using [key]. If [value] is null, delete [key]
  Future<void> saveData(String key, dynamic value) async {
    assert(_box != null, 'Storage box is null');
    assert(key.isNotEmpty, 'Key is empty');
    if (value == null) {
      await _box?.remove(key);

      return;
    }
    await _box?.write(key, value);
  }

  ///Clear all local data
  Future<void> clearAllData() async {
    return _box!.erase();
  }

  Future<String?> getSecureData(String key) async {
    return await storage.read(key: key);
  }

  Future<void> saveSecureData(String key, String value) async {
    return await storage.write(key: key, value: value);
  }

  Future<void> deleteSecureData(String key) async {
    return await storage.delete(key: key);
  }

  Future<void> clearSecureData() async {
    return await storage.deleteAll();
  }
}
