// lib/features/onboarding/presentation/widgets/role_option_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gen_smile/core/constant/app_colors.dart';
import 'package:gen_smile/core/constant/app_text_styles.dart';

/// Card used on the role-selection screen.
/// Pass a fully built [iconWidget] (with its own background/padding).
class RoleOptionCard extends StatelessWidget {
  const RoleOptionCard({
    super.key,
    required this.iconWidget,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final Widget iconWidget;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderDefault,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // icon (caller provides the full widget with background)
            iconWidget,
            SizedBox(width: 14.w),
            // text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.mdSemibold(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.smRegular(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // checkmark
            if (isSelected)
              Container(
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 14.w),
              ),
          ],
        ),
      ),
    );
  }
}
