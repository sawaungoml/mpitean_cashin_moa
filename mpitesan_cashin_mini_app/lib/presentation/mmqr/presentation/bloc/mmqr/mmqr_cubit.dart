import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mpitesan_cashin_mini_app/model/user_model.dart';
import 'package:mpitesan_cashin_mini_app/presentation/mmqr/services/mmqr_services.dart';

part 'mmqr_state.dart';

class MmqrCubit extends Cubit<MmqrState> {
  final MMQRServices mmqrServices;
  MmqrCubit(this.mmqrServices) : super(MmqrInitial());

  String mmqrText = '';

  generateMMQRText({double amount = 0, required UserInfoResponse userInfo}) {
    mmqrText = mmqrServices.generateMMQRText(
      amount: amount,
      tag26Map: {
        '00': 'com.mmqrpay.www',
        '01': userInfo.merchantId != null && userInfo.merchantId!.length > 0 ? 
              userInfo.merchantId!.substring(0, userInfo.merchantId!.length < 15 ? userInfo.merchantId!.length : 15) : 
              '000000000000000',
        '02': '70000056', //static value
      },
      tag62Map: {
        '02': userInfo.msisdn ?? '9772661150',
      },
      tag64Map: {
        '00': 'MY',
        '01': userInfo.merchantLabelMmr ?? userInfo.merchantName ?? 'Merchant',
        '02': userInfo.city ?? 'Yangon'
      },
      merchantName: userInfo.merchantName ?? 'Merchant',
      city: userInfo.city ?? 'Yangon',
      postalCode: userInfo.postalCode ?? '100001',
      merchantCode: userInfo.mcc ?? '5499',
    );

    emit(MmqrDataState(mmqrText: mmqrText));
  }
}
