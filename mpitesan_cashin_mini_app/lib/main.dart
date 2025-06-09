
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpitesan_cashin_mini_app/cubit/user_info/user_info_cubit.dart';
import 'package:mpitesan_cashin_mini_app/di/mpitesan_cashin_module_initializer.dart';
import 'package:mpitesan_cashin_mini_app/presentation/mmqr/presentation/bloc/mmqr/mmqr_cubit.dart';
import 'package:mpitesan_cashin_mini_app/presentation/mmqr/presentation/screens/my_mmqr.dart';
import 'package:mpitesan_cashin_mini_app/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await initializeModule(environment: "staging");
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserInfoCubit>(
          create: (context) => getIt<UserInfoCubit>(),
        ),
        BlocProvider<MmqrCubit>(
          create: (context) => getIt<MmqrCubit>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'MMQR CashIn',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
      ),
    );
  }
}
