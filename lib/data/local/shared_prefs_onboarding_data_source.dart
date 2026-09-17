import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_local_data_source.dart';

@LazySingleton(as: OnboardingLocalDataSource)
class SharedPrefsOnboardingDataSource implements OnboardingLocalDataSource {
  final SharedPreferences _prefs;
  SharedPrefsOnboardingDataSource(this._prefs);

  static const _kSeen = 'seen_onboarding';

  @override
  Future<bool> hasSeenOnboarding() async => _prefs.getBool(_kSeen) ?? false;

  @override
  Future<void> markOnboardingAsSeen() async => _prefs.setBool(_kSeen, true);
}
