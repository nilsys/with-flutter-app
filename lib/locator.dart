import 'package:get_it/get_it.dart';
import 'core/services/dynamic_link.service.dart';
import 'core/view_models/main.vm.dart';
import 'core/view_models/story.vm.dart';
import 'core/view_models/user.vm.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<StoryVM>(() => StoryVM());
  locator.registerLazySingleton<UserVM>(() => UserVM());
  locator.registerLazySingleton<DynamicLinkService>(() => DynamicLinkService());
  locator.registerLazySingleton<MainVM>(() => MainVM());
}
