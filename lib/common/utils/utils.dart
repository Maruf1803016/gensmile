import 'package:flutter/material.dart';

import '../../core/constant/app_colors.dart';

Color getVariant(String variant) {
  if (variant == 'success') return AppColors.success;
  if (variant == 'danger') return AppColors.danger;
  if (variant == 'primary') return AppColors.primary;
  if (variant == 'secondary') return AppColors.secondary;
  if (variant == 'info') return AppColors.info;
  if (variant == 'purple') return AppColors.purple;
  if (variant == 'blue') return AppColors.blue;
  if (variant == 'light') return Colors.white;
  if (variant == 'dark') return Colors.black;
  return Colors.black;
}
