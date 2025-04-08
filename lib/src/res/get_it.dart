import 'package:Skillify/src/cubit/login/login_cubit.dart';
import 'package:Skillify/src/services/network_services.dart';
import 'package:Skillify/src/services/repositoty.dart';
import 'package:get_it/get_it.dart';

final getItInstance = GetIt.I;

Future<void> init() async {
  // Core Services
  getItInstance.registerLazySingleton<NetworkServices>(() => NetworkServices());

  // Repository
  getItInstance.registerLazySingleton<Repository>(
    () => Repository(networkServices: getItInstance()),
  );

  // Cubit
  getItInstance.registerFactory(() => LoginCubit(repository: getItInstance()));
}
