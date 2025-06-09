import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:core/core.dart';
import 'package:mpitesan_cashin_mini_app/model/user_model.dart';
import 'package:mpitesan_cashin_mini_app/services/auth_api/auth_repo.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final AuthRepo authRepo;
  final FlutterSecureStorage storage;

  UserInfoCubit(this.authRepo, this.storage) : super(UserInfoInitial());

  Future<void> checkUserInfo(String phoneNumber) async {
    debugPrint("getUserInfo");
    try {
      emit(UserInfoLoading());
      debugPrint("Loading");

      String phoneNo = phoneNumber.replaceFirst(RegExp(r'^0'), '');
      
      final request = UserInfoRequest(
        type: 'USERINFOREQ',
        identification: phoneNo,
        level: 'HIGH',
        inputType: 'MSISDN',
        userRole: 'CHANNEL',
      );

       
        final Map<String, dynamic> response = await authRepo.getUserInfo(request);
        //debugPrint(response.toString());
        
          final userInfoResponse = UserInfoResponse.fromXml(response['data']);
          debugPrint("userInfoREsponse $userInfoResponse");
          if (userInfoResponse.isSuccess) {
            debugPrint("userInfoREsponse ${userInfoResponse.isSuccess}");
            if (!userInfoResponse.isApproved) {
              emit(UserWaitApproved());
              return;
            }
            emit(UserInfoSuccess(
                userInfo: userInfoResponse, userMpinFirst: true));

          } else if (userInfoResponse.isUserNotFound) {
            emit(RegisterFirst(phoneNumber: phoneNumber));
          } else {
            emit(UserInfoError(message: userInfoResponse.message));
          }
        
      
    } catch (e) {
      emit(UserInfoError(message: e.toString()));
    }
  }

  Future<void> getUserInfo(String phoneNumber) async {
    debugPrint("getUserInfo");
    try {
      emit(UserInfoLoading());
      debugPrint("Loading");
      String phoneNo = phoneNumber.replaceFirst(RegExp(r'^0'), '');
      final request = UserInfoRequest(
        type: 'USERINFOREQ',
        identification: phoneNo,
        level: 'HIGH',
        inputType: 'MSISDN',
        userRole: 'CHANNEL',
      );

      final Map<String, dynamic> responseRefreshToken = await authRepo.refreshToken();
      if (responseRefreshToken['data'] != null) {
        await storage.write(
            key: 'access_token',
            value: responseRefreshToken['data']['access_token']);

        if (responseRefreshToken['data']['access_token'] != null) {
          final Map<String, dynamic> response = await authRepo.getUserInfo(request);
          final userInfoResponse = UserInfoResponse.fromXml(response['data']);

          if (userInfoResponse.isSuccess) {
            if (!userInfoResponse.isApproved) {
              emit(UserWaitApproved());
              return;
            }
            String? mPin = await storage.read(key: 'mPin');
            emit(UserInfoSuccess(
                userInfo: userInfoResponse, userMpinFirst: true));

            // if (mPin != null) {
            //   final mPinRequest = PinValidationRequest(
            //     type: 'RVMPINREQ',
            //     msisdn: phoneNo,
            //     provider: KConstant.provider,
            //     mpin: mPin,
            //     language1: KConstant.language,
            //     requestingParty: KConstant.requestingParty,
            //   );
            //   final Map<String, dynamic> mPinResponse =
            //       await authRepo.validMPin(mPinRequest);

            //   final validationResponse =
            //       PinValidationResponse.fromXml(mPinResponse['data']);
            //   if (validationResponse.isSuccess) {
            //     emit(UserInfoSuccess(userInfo: userInfoResponse));
            //   } else {
            //     emit(UserInfoSuccess(
            //         userInfo: userInfoResponse, userMpinFirst: true));
            //   }
            // } else {
            //   String? isCreatedPin = await storage.read(key: '${phoneNo}-register');
            //   if (isCreatedPin == 'register') {
            //     emit(CreatePinFirst(phoneNumber: phoneNumber));
            //   } else {
            //     emit(UserInfoSuccess(
            //         userInfo: userInfoResponse, userMpinFirst: true));
            //   }
            // }
          } else if (userInfoResponse.isUserNotFound) {
            emit(RegisterFirst(phoneNumber: phoneNumber));
          } else {
            emit(UserInfoError(message: userInfoResponse.message));
          }
        } else {
          emit(UserInfoError(message: "can not retrieve access token"));
        }
      }
    } catch (e) {
      emit(UserInfoError(message: e.toString()));
    }
  }
}
