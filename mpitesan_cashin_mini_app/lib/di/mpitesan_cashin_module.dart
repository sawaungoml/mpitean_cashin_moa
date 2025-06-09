import 'package:core/core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mpitesan_cashin_mini_app/cubit/user_info/user_info_cubit.dart';
import 'package:mpitesan_cashin_mini_app/presentation/mmqr/presentation/bloc/mmqr/mmqr_cubit.dart';
import 'package:mpitesan_cashin_mini_app/presentation/mmqr/services/mmqr_services.dart';
import 'package:mpitesan_cashin_mini_app/services/api_services.dart';
import 'package:mpitesan_cashin_mini_app/services/auth_api/auth_api.dart';
import 'package:mpitesan_cashin_mini_app/services/auth_api/auth_repo.dart';

class MpitesanCashInModuleInitializer implements ModuleInitializer {
  @override
  void registerDependencies(GetIt getIt, {String? environment}) {
    // Register services
    getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
    getIt.registerLazySingleton<ApiServices>(() => ApiServices(getIt<FlutterSecureStorage>()));
    getIt.registerLazySingleton<AuthApi>(() => AuthApi(getIt<ApiServices>()));
    getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(getIt<AuthApi>()));
    getIt.registerLazySingleton<MMQRServices>(() => MMQRServices());
    
    // Register cubits
    getIt.registerFactory<UserInfoCubit>(() => UserInfoCubit(
      getIt<AuthRepo>(), 
      getIt<FlutterSecureStorage>()
    ));
    getIt.registerFactory<MmqrCubit>(() => MmqrCubit(getIt<MMQRServices>()));
  }
}