abstract class OnboardingLocalDataSource {
  Future<bool> hasSeenOnboarding();
  Future<void> markOnboardingAsSeen();
}
