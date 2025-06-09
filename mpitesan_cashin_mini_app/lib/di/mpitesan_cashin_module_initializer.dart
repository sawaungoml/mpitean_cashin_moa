
import 'package:core/core.dart';
import 'package:mpitesan_cashin_mini_app/di/mpitesan_cashin_module.dart';
import 'package:payment_gateway/payment_gateway_initializer.dart';

/// Singleton GetIt instance shared across the application
final GetIt getIt = GetIt.instance;

/// Initialize all dependencies for the application
/// 
/// This function sets up the ModuleRegistry and initializes all modules
/// with the appropriate environment.
Future<void> initializeModule({String environment = 'production'}) async {
  // Create a module registry with the shared GetIt instance
  final moduleRegistry = ModuleRegistry(getIt, environment: environment);
  
  // Add all module initializers
  moduleRegistry.addModules([
    MpitesanCashInModuleInitializer(),
    PaymentGatewayInitializer(),
  ]);
  
  // Initialize all modules
  moduleRegistry.initializeAll();
}