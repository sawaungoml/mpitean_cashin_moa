part of 'mmqr_cubit.dart';

@immutable
sealed class MmqrState {}

final class MmqrInitial extends MmqrState {}

final class MmqrDataState extends MmqrState {
  final String mmqrText;
  MmqrDataState({required this.mmqrText});
}
