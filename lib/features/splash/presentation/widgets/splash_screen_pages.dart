import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gen_smile/common/widgets/buttons.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';
import 'package:gen_smile/core/constant/app_spacing.dart';
import 'package:gen_smile/core/states/navigator_state.dart';
import 'package:gen_smile/features/splash/data/models/splash.dart';
import 'package:gen_smile/features/splash/states/splash_states.dart';
import 'package:gen_smile/features/auth/presentation/pages/sign_in_screen.dart';

class SplashScreenPages extends ConsumerWidget {
  const SplashScreenPages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashController = ref.watch(splashControllerState);
    final splashData = ref.watch(splashDataState);

    return Scaffold(
      backgroundColor: AppColors.white,
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

  static const _icons = [
    Icons.medical_services_outlined,
    Icons.auto_awesome_outlined,
    Icons.business_outlined,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashController = ref.watch(splashControllerState);

    void goToSignIn() {
      ref
          .read(navigatorState.notifier)
          .pushReplacementAll(const SignInScreen());
    }

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s6, // 24
            vertical: AppSpacing.s6, // 24
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration
              _SplashIllustration(
                imagePath: splash.image,
                fallbackIcon: _icons[index % _icons.length],
              ),

              Gap(AppSpacing.s10), // 40
              // Dot indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  total,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(
                      horizontal: AppSpacing.s1,
                    ), // 4
                    width: i == index ? 20.w : 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: i == index
                          ? AppColors.primary
                          : AppColors.borderDefault,
                      borderRadius: BorderRadius.circular(AppRadius.r1), // 4
                    ),
                  ),
                ),
              ),

              Gap(AppSpacing.s6), // 24
              // Title — was AppColors.black0A → now AppColors.textPrimary
              Text(
                splash.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.h5Bold(color: AppColors.textPrimary),
              ),

              Gap(AppSpacing.s3), // 12
              // Description — was AppColors.grayColor → now AppColors.textSubTitle
              Text(
                splash.description,
                textAlign: TextAlign.center,
                style: AppTextStyles.lgRegular(color: AppColors.textSubTitle),
              ),

              Gap(AppSpacing.s10), // 40

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
              style: AppTextStyles.mdMedium(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

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
        errorBuilder: (_, __, ___) =>
            Icon(fallbackIcon, size: 80.sp, color: AppColors.primary),
      ),
    );
  }
}
