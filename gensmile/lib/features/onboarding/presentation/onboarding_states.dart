import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/states/navigator_state.dart';
import 'pages/create_account_screen.dart';

final onboardingRoleProvider =
    StateNotifierProvider<OnboardingNotifier, String?>((ref) {
      return OnboardingNotifier(ref);
    });

class OnboardingNotifier extends StateNotifier<String?> {
  final Ref ref;
  OnboardingNotifier(this.ref) : super(null);

  void setRole(String role) => state = role;

  void onContinue() {
    if (state == null) return;
    ref.read(navigatorState.notifier).push(const CreateAccountScreen());
  }
}
