import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:mpitesan_cashin_mini_app/model/user_model.dart';
import 'package:mpitesan_cashin_mini_app/presentation/mmqr/services/mmqr_services.dart';

part 'mmqr_state.dart';

class MmqrCubit extends Cubit<MmqrState> {
  final MMQRServices mmqrServices;
  MmqrCubit(this.mmqrServices) : super(MmqrInitial());

  String mmqrText = '';

  generateMMQRText({double amount = 0, required UserInfoResponse userInfo}) {
    //debugPrint("userInfo -> ${jsonEncode(userInfo)}");

    debugPrint("amount -> $amount");
    debugPrint("merchantId -> ${userInfo.merchantId}");
    debugPrint("tag26Map -> ${jsonEncode({
        '00': 'com.mmqrpay.www',
        '01': userInfo.merchantId?.substring(0, 15),
        '02': '70000056', //static value
      })}");

       debugPrint("tag62Map -> ${jsonEncode({
        '02': userInfo.msisdn,
      })}");

      debugPrint("tag64Map -> ${jsonEncode({'00': 'MY',
        '01': userInfo.merchantLabelMmr,
        '02': userInfo.city})}");

      debugPrint("MerchantName ->  ${userInfo.merchantName!}");
      debugPrint("city -> ${userInfo.city}");
      debugPrint("postalCode: ${userInfo.postalCode!}");
      debugPrint("merchantCode: ${userInfo.mcc!}");

    mmqrText = mmqrServices.generateMMQRText(
      amount: amount,
      tag26Map: {
        '00': 'com.mmqrpay.www',
        '01': userInfo.merchantId?.substring(0, 15),
        '02': '70000056', //static value
      },
      tag62Map: {
        '02': userInfo.msisdn,
      },
      tag64Map: {
        '00': 'MY',
        '01': userInfo.merchantLabelMmr,
        '02': userInfo.city
      },
      merchantName: userInfo.merchantName!,
      city: userInfo.city!,
      postalCode: userInfo.postalCode!,
      merchantCode: userInfo.mcc!,
    );

    debugPrint("mmqrText -> $mmqrText");

    
    //String sample = "00020101021126380014com.mmqrpay.www0115${userInfo.merchantId?.substring(0, 15)}0201700000560303${amount.toStringAsFixed(2).replaceAll('.', '')}5802MY590${userInfo.merchantLabelMmr}6007${userInfo.city}6100${userInfo.postalCode}6207${userInfo.mcc}6304${userInfo.merchantName}6500${userInfo.city}70000056";
    emit(MmqrDataState(mmqrText: mmqrText));
  }
}
