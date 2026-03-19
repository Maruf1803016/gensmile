import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onboarding/core/states/navigator_state.dart';
import 'package:onboarding/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:onboarding/features/splash/presentation/widgets/splash_screen_pages.dart';
import 'package:onboarding/features/splash/data/models/splash.dart';
import 'package:onboarding/generated/assets.dart';

// ── Page controller for splash PageView ──────────────────────────────────────
final splashControllerState = Provider<PageController>(
  (ref) => PageController(),
);

// ── Splash pages data ─────────────────────────────────────────────────────────
final splashDataState = Provider<List<Splash>>(
  (ref) => [
    Splash(
      image: Assets.imagesSplash1,
      title: 'Welcome to GenSmile',
      description: 'The ultimate platform for dental clinic management.',
    ),
    Splash(
      image: Assets.imagesSplash2,
      title: 'AI-Powered Simulations',
      description:
          'Visualize your dream smile with cutting-edge AI technology.',
    ),
    Splash(
      image: Assets.imagesSplash3,
      title: 'Manage Your Clinic',
      description:
          'Set up your clinic and manage patient simulations easily.',
    ),
  ],
);

// ── Splash notifier ───────────────────────────────────────────────────────────
final splashState = StateNotifierProvider<SplashNotifier, void>(
  (ref) => SplashNotifier(ref),
);

class SplashNotifier extends StateNotifier<void> {
  final Ref ref;
  SplashNotifier(this.ref) : super(null);

  Future<void> redirectToPage() async {
    await Future.delayed(const Duration(seconds: 2));

    // TODO: check auth token → if logged in go to DashboardScreen
    // final token = await LocalStorageService().getToken();
    // if (token != null) {
    //   ref.read(navigatorState.notifier).pushReplacementAll(const DashboardScreen());
    //   return;
    // }

    // Not logged in → show onboarding splash pages
    ref
        .read(navigatorState.notifier)
        .pushReplacementAll(const SplashScreenPages());
  }
}
