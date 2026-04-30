import 'package:flutter/material.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/app_typography.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;
  final int notificationCount;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final bool centerTitle;
  final double elevation;
  final IconData menuIcon;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.onNotificationPressed,
    this.notificationCount = 0,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.centerTitle = false,
    this.elevation = 1,
    this.menuIcon = Icons.menu_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.darkSurfaceBright : AppColors.white);

    return AppBar(
      title: Text(
        title,
        style: AppTypography.titleLarge.copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
      backgroundColor: bgColor,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : (onMenuPressed != null
              ? IconButton(
                  icon: Icon(menuIcon),
                  onPressed: onMenuPressed,
                )
              : null),
      actions: [
        if (onNotificationPressed != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  onPressed: onNotificationPressed,
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        notificationCount > 99 ? '99+' : '$notificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ...?actions,
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );
}

// Gradient app bar for special sections
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Gradient gradient;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final List<Widget>? actions;
  final double expandedHeight;
  final Widget? flexibleSpace;

  const GradientAppBar({
    super.key,
    required this.title,
    required this.gradient,
    this.onMenuPressed,
    this.onBackPressed,
    this.showBackButton = false,
    this.actions,
    this.expandedHeight = 200,
    this.flexibleSpace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: AppBar(
        title: Text(
          title,
          style: AppTypography.headlineSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: Colors.white),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              )
            : (onMenuPressed != null
                ? IconButton(
                    icon: const Icon(Icons.menu_rounded, color: Colors.white),
                    onPressed: onMenuPressed,
                  )
                : null),
        actions: [
          ...?actions?.map(
            (action) => Theme(
              data: Theme.of(context).copyWith(
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              child: action,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
