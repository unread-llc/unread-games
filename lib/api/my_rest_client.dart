import 'dart:developer';

import 'package:get/get.dart';

import '../storage/my_storage.dart';
import 'rest_method.dart';

class MyRestClient extends GetConnect {
  static final MyRestClient _instance = MyRestClient._internal();

  factory MyRestClient() => _instance;
  MyRestClient._internal();

  static MyRestClient get instance => _instance;

  void init(String baseUrl) {
    httpClient.baseUrl = baseUrl;
    httpClient.timeout = const Duration(seconds: 20);
    httpClient.maxAuthRetries = 2;
    httpClient.addRequestModifier<dynamic>((request) async {
      String? token = await MyStorage.instance.getData('token');
      if ((token ?? '').isNotEmpty) {
        request.headers['Authorization'] = '$token';
      }

      return request;
    });
    httpClient.addAuthenticator<dynamic>((request) async {
      //TODO refresh token logic will be here
      // final response = sendRequest(url: 'refreshUrlHere');

      String refreshToken = '';
      if (refreshToken.isNotEmpty) {
        request.headers['RefreshTokenParam'] = refreshToken;
      }

      return request;
    });
  }

  Future<(bool, dynamic)> sendRequest({
    required String url,
    RestMethod method = RestMethod.get,
    dynamic body,
    dynamic queryParam,
    dynamic header,
    String contentType = 'application/json',
  }) async {
    Response? response;

    try {
      switch (method) {
        case RestMethod.get:
          response = await get(url, query: queryParam, headers: header, contentType: contentType);
        case RestMethod.post:
          response = await post(url, body, headers: header, query: queryParam, contentType: contentType);
        case RestMethod.put:
          response = await put(url, body, query: queryParam, headers: header, contentType: contentType);
        case RestMethod.delete:
          response = await delete(url, query: queryParam, headers: header, contentType: contentType);
      }
    } catch (e) {
      log('e = $e');
      return (false, null);
    }

    String serverSuccess = '';
    try {
      serverSuccess = '${response.body['success']}';
    } catch (e) {
      log('e = $e');
    }

    bool isServerSuccess = serverSuccess == 'true' || serverSuccess == '1';
    bool isSuccess = isServerSuccess;

    if (isSuccess && url == '/auth/login') {
      MyStorage.instance.saveData('token', response.headers?['authorization']);
    }

    return (isSuccess, response.body);
  }
}
