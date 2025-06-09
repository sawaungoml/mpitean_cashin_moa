import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mpitesan_cashin_mini_app/model/user_model.dart';
import 'package:mpitesan_cashin_mini_app/services/auth_api/auth_repo.dart';


part 'payment_user_info_state.dart';

class PaymentUserInfoCubit extends Cubit<PaymentUserInfoState> {
  final AuthRepo authRepo;
  PaymentUserInfoCubit(this.authRepo) : super(PaymentUserInfoInitial());

  Future<void> getUserInfo(String phoneNumber, double amount) async {
    try {
      emit(PaymentUserInfoLoading());

      String phoneNo = phoneNumber.replaceFirst(RegExp(r'^0'), '');
      final request = UserInfoRequest(
        type: 'USERINFOREQ',
        identification: phoneNo,
        level: 'HIGH',
        inputType: 'MSISDN',
        userRole: 'CHANNEL',
      );

      final Map<String, dynamic> response = await authRepo.getUserInfo(request);
      final userInfoResponse = UserInfoResponse.fromXml(response['data']);

      if (userInfoResponse.isSuccess) {
        emit(
            PaymentUserInfoSuccess(userInfo: userInfoResponse, amount: amount));
      } else {
        emit(PaymentUserInfoFail(message: userInfoResponse.message));
      }
    } catch (e) {
      print(e.toString());
      emit(PaymentUserInfoFail(message: 'Something went wrong'));
    }
  }
}
