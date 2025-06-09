import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mpitesan_cashin_mini_app/model/user_model.dart';
import 'package:mpitesan_cashin_mini_app/services/api_services.dart';


class AuthApi {
  final ApiServices apiServices;
  final String _baseUrl = "https://testmpitesan.ooredoo.com.mm:8243";
  final String _ddUrl = "https://project-alpha.digitaldevdesign.com";
  final String _ddApiKey = "mer_sk_live_51NxK9pQ2vL8mR3tY7wZ4hJ6bF9cD2e";
  final String _apiKey = "U2ZvekpNdDRuTTFZRTJUY0J4ZFpqUkRZWFI4YTptQ2dNamxadDhvSFpPRGRQYUdXa09qWEgyN01h";
  AuthApi(this.apiServices);

  Future<Map<String, dynamic>> getUserInfo(UserInfoRequest request) async {
    return apiServices.sendXmlRequest(
      request: request,
      requestType: 'User Info'
    );
  }

  // Future<Map<String, dynamic>> registerMerchant(
  //     MerchantRegistrationRequest request) async {
  //   return apiServices.sendXmlRequest(
  //     request: request,
  //     requestType: 'Merchant Registration',
  //   );
  // }

  // Future<Map<String, dynamic>> validMPin(PinValidationRequest request) async {
  //   return apiServices.sendXmlRequest(
  //     request: request,
  //     requestType: 'MPin Validation',
  //   );
  // }

  // Future<Map<String, dynamic>> changeMPin(ChangePinRequest request) async {
  //   return apiServices.sendXmlRequest(
  //     request: request,
  //     requestType: 'Change MPin',
  //   );
  // }

  Future<Map<String, dynamic>> refreshToken() async {
    try {
      debugPrint("calling rereshToken");
      final url = Uri.parse('$_baseUrl/token');

      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Basic $_apiKey',
      };

      // For x-www-form-urlencoded, we need to send the body as a string
      final body = 'grant_type=client_credentials';

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      debugPrint("reponse -> $response");

      return {
        'statusCode': response.statusCode,
        'data': jsonDecode(response.body),
      };
    } catch (e) {
      throw HttpException(
        statusCode: 500,
        message: 'Error occurred while refreshing token: $e',
      );
    }
  }

  Future<Map<String, dynamic>> uploadPhoto(
      {required String phone,
      required File file,
      required String type,
      String? businessName}) async {
    try {
      if (!await file.exists()) {
        throw HttpException(
          statusCode: 400,
          message: 'File does not exist at path: ${file.path}',
        );
      }

      final url = Uri.parse('$_ddUrl/api/merchants/upload');
      print('Uploading photo to URL: $url');

      final request = http.MultipartRequest('POST', url)
        ..fields['phone'] = phone
        ..fields['type'] = type
        ..fields['business_name'] = businessName.toString()
        ..files.add(await http.MultipartFile.fromPath('file', file.path));
      request.headers['X-API-Key'] = _ddApiKey;
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Accept'] = 'application/json';

      print('Sending request with headers: ${request.headers}');
      print('Request fields: ${request.fields}');

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseBody = String.fromCharCodes(responseData);

      print('Response status code: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        return {
          'statusCode': response.statusCode,
          'data': jsonDecode(responseBody),
        };
      } else {
        final errorMessage =
            'Failed to upload photo. Status code: ${response.statusCode}';
        try {
          final errorData = jsonDecode(responseBody);
          throw HttpException(
            statusCode: response.statusCode,
            message: '$errorMessage. Server response: ${errorData.toString()}',
          );
        } catch (e) {
          throw HttpException(
            statusCode: response.statusCode,
            message: '$errorMessage. Raw response: $responseBody',
          );
        }
      }
    } catch (e) {
      print('Error occurred while uploading photo: $e');
      if (e is HttpException) {
        rethrow;
      }
      throw HttpException(
        statusCode: 500,
        message: 'Error occurred while uploading photo: ${e.toString()}',
      );
    }
  }

  // Future<Map<String, dynamic>> getBalanceEnquiry(
  //     BalanceEnquiryRequest request) async {
  //   return apiServices.sendXmlRequest(
  //     request: request,
  //     requestType: 'Balance Enquiry',
  //   );
  // }
}
