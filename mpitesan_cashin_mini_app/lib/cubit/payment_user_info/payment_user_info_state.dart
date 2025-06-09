part of 'payment_user_info_cubit.dart';

@immutable
sealed class PaymentUserInfoState {}

final class PaymentUserInfoInitial extends PaymentUserInfoState {}

final class PaymentUserInfoLoading extends PaymentUserInfoState {}

final class PaymentUserInfoSuccess extends PaymentUserInfoState {
  final UserInfoResponse userInfo;
  final double amount;
  PaymentUserInfoSuccess({required this.userInfo, required this.amount});
}

final class PaymentUserInfoFail extends PaymentUserInfoState {
  final String message;
  PaymentUserInfoFail({required this.message});
}
