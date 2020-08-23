import 'package:get_it/get_it.dart';
import 'core/view_models/story_CRUDModel.dart';
import 'core/view_models/user_CRUDModel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<StoryCRUDModel>(() => StoryCRUDModel());
  locator.registerLazySingleton<UserCRUDModel>(() => UserCRUDModel());
}
