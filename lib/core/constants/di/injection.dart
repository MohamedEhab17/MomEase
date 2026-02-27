import 'package:get_it/get_it.dart';
import 'package:new_mama/feature/community/presentation/view_model/community_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Cubits
  sl.registerLazySingleton<CommunityCubit>(
    () => CommunityCubit(),
  );

}