import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'assistant_audio_service.dart';
import 'di.config.dart';
import 'domain_text_normalizer.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  // SharedPreferences async — لازم يتسجل قبل getIt.init()
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  getIt.init();

  if (!getIt.isRegistered<AssistantAudioService>()) {
    getIt.registerLazySingleton<AssistantAudioService>(
      () => AssistantAudioServiceImpl(prefs),
    );
  }
  if (!getIt.isRegistered<DomainTextNormalizer>()) {
    getIt.registerLazySingleton<DomainTextNormalizer>(
      () => DomainTextNormalizer(),
    );
  }
}
