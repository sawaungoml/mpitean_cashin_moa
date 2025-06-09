import 'dart:io';

import 'package:mpitesan_cashin_mini_app/model/user_model.dart';
import 'package:mpitesan_cashin_mini_app/services/auth_api/auth_api.dart';

class AuthRepo {
  final AuthApi authApi;
  AuthRepo(this.authApi);

  Future<Map<String, dynamic>> getUserInfo(UserInfoRequest request) {
    return authApi.getUserInfo(request);
  }

  // Future<Map<String, dynamic>> registerMerchant(
  //     MerchantRegistrationRequest request) {
  //   return authApi.registerMerchant(request);
  // }

  // Future<Map<String, dynamic>> validMPin(PinValidationRequest request) {
  //   return authApi.validMPin(request);
  // }

  // Future<Map<String, dynamic>> changeMPin(ChangePinRequest request) {
  //   return authApi.changeMPin(request);
  // }

  // Future<Map<String, dynamic>> uploadPhoto(
  //     {required String phone,
  //     required File file,
  //     required String type,
  //     String? businessName}) {
  //   return authApi.uploadPhoto(
  //     phone: phone,
  //     file: file,
  //     type: type,
  //     businessName: businessName,
  //   );
  // }

  Future<Map<String, dynamic>> refreshToken() {
    return authApi.refreshToken();
  }
}
