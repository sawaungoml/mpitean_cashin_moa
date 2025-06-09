import 'package:core/core.dart';
import 'package:mpitesan_cashin_mini_app/cubit/user_info/user_info_cubit.dart';
import 'package:mpitesan_cashin_mini_app/di/mpitesan_cashin_module_initializer.dart';
import 'package:mpitesan_cashin_mini_app/presentation/mmqr/presentation/bloc/mmqr/mmqr_cubit.dart';
import 'package:mpitesan_cashin_mini_app/presentation/mmqr/presentation/screens/my_mmqr.dart';
import 'package:payment_gateway/router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    
    GoRoute(
      path: '/',
      builder: (context, state) {
        return MultiBlocProvider(providers: [
          BlocProvider<UserInfoCubit>(
          create: (context) => getIt<UserInfoCubit>(),
        ),BlocProvider<MmqrCubit>(
          create: (context) => getIt<MmqrCubit>(),
        )], child: const MyMMQrScreen());
      } ,
    ),
  
    ...PaymentGatewayRouter.routes,
  ]);
   