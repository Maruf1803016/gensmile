import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../core/constant/app_colors.dart';
import '../../core/states/navigator_state.dart';
import '../../generated/assets.dart';

class AppLayout extends ConsumerWidget {
  const AppLayout({
    super.key,
    this.title = '',
    required this.child,
    this.padding = 16,
    this.headerBackground,
    this.bodyBackground,
    this.showNotification = false,
    this.onBackPressed,
  });

  final Widget child;
  final double padding;
  final String title;
  final Color? headerBackground, bodyBackground;
  final bool showNotification;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: bodyBackground ?? AppColors.background,
      appBar: AppBar(
        backgroundColor: headerBackground ?? AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(title),
        leading: IconButton(
          onPressed:
              onBackPressed ??
              () {
                ref.read(navigatorState.notifier).pop();
              },
          icon: Icon(Icons.chevron_left),
        ),
        actions: [Gap(16.w)],
      ),
      body: Container(
        color: bodyBackground ?? AppColors.background,
        padding: EdgeInsets.all(padding.w),
        child: child,
      ),
    );
  }
}
