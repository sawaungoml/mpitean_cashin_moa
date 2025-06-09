part of 'user_info_cubit.dart';

@immutable
sealed class UserInfoState {}

final class UserInfoInitial extends UserInfoState {}

final class UserInfoLoading extends UserInfoState {}

final class UserWaitApproved extends UserInfoState {}

final class UserInfoSuccess extends UserInfoState {
  final UserInfoResponse userInfo;
  final bool userMpinFirst;
  UserInfoSuccess({required this.userInfo, this.userMpinFirst = false});
}

final class RegisterFirst extends UserInfoState {
  final String phoneNumber;
  RegisterFirst({required this.phoneNumber});
}

final class CreatePinFirst extends UserInfoState {
  final String phoneNumber;
  CreatePinFirst({required this.phoneNumber});
}

final class UserInfoError extends UserInfoState {
  final String message;
  UserInfoError({required this.message});
}
