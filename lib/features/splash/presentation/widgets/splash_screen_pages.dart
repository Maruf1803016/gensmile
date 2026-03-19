import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onboarding/common/widgets/buttons.dart';
import 'package:onboarding/core/constant/app_colors.dart';
import 'package:onboarding/core/states/navigator_state.dart';
import 'package:onboarding/features/splash/data/models/splash.dart';
import 'package:onboarding/features/splash/states/splash_states.dart';
import 'package:onboarding/features/auth/presentation/pages/sign_in_screen.dart';

class SplashScreenPages extends ConsumerWidget {
  const SplashScreenPages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashController = ref.watch(splashControllerState);
    final splashData       = ref.watch(splashDataState);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView.builder(
          controller: splashController,
          itemCount: splashData.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return SplashPage(
              splash: splashData[index],
              index: index,
              total: splashData.length,
            );
          },
        ),
      ),
    );
  }
}

class SplashPage extends ConsumerWidget {
  const SplashPage({
    super.key,
    required this.splash,
    required this.index,
    required this.total,
  });

  final Splash splash;
  final int index;
  final int total;

  // Fallback icons per page when images are not available
  static const _icons = [
    Icons.medical_services_outlined,
    Icons.auto_awesome_outlined,
    Icons.business_outlined,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashController = ref.watch(splashControllerState);

    void goToSignIn() {
      ref.read(navigatorState.notifier).pushReplacementAll(const SignInScreen());
    }

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Illustration placeholder / real image ──
              _SplashIllustration(
                imagePath: splash.image,
                fallbackIcon: _icons[index % _icons.length],
              ),

              Gap(40.h),

              // Dot indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  total,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: i == index ? 20.w : 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: i == index
                          ? AppColors.primary
                          : AppColors.inputBorder,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),

              Gap(24.h),

              Text(
                splash.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black0A,
                ),
              ),
              Gap(12.h),
              Text(
                splash.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  color: AppColors.grayColor,
                ),
              ),
              Gap(40.h),
              PrimaryButton(
                text: index == total - 1 ? 'Get Started' : 'Next',
                onPressed: () {
                  if (index < total - 1) {
                    splashController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    goToSignIn();
                  }
                },
              ),
            ],
          ),
        ),

        // Skip button
        Positioned(
          top: 8.h,
          right: 8.w,
          child: TextButton(
            onPressed: goToSignIn,
            child: Text(
              'Skip',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Shows the real image if available, gracefully falls back to an icon illustration
class _SplashIllustration extends StatelessWidget {
  const _SplashIllustration({
    required this.imagePath,
    required this.fallbackIcon,
  });

  final String imagePath;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      height: 200.w,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
          fallbackIcon,
          size: 80.sp,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
