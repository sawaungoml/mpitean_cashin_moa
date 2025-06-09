import 'dart:convert';
import 'dart:developer';

import 'package:core/core.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mpitesan_cashin_mini_app/model/user_model.dart';

class ApiServices {
  final String _baseUrl = "https://testmpitesan.ooredoo.com.mm:8243";
  final String _endPoint = "/imiNonFinancialXMLService/1.0.0";
    final String _proxyUrl = "http://localhost:3000";
  final FlutterSecureStorage storage;
  ApiServices(this.storage);

  Future<Map<String, dynamic>> sendXmlRequest<T>({
    required dynamic request,
    required String requestType,
    String? customEndpoint
  }) async {
    try {
      late String phoneNo;
      if (request is UserInfoRequest) {
        phoneNo = request.identification;
      }
      final url = Uri.parse('$_proxyUrl/mpitesan/userinfo');
      debugPrint("url -> $url");
      debugPrint("request -> $phoneNo");

      final body = {
        "phoneNumber" : phoneNo
      };
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      log('$requestType response status: ${response.statusCode}');
      log('$requestType response body: ${response.body}');
      
      debugPrint("response -> ${response.body}");
      return {
        'statusCode': response.statusCode,
        'data': response.body,
      };
    } catch (e) {
      print(e);
      throw HttpException(
        statusCode: 500,
        message: 'Error occurred during $requestType request: $e',
      );
    }
  }
}

class HttpException implements Exception {
  final int statusCode;
  final String message;

  HttpException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => message;
}
