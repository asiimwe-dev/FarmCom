import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/theme/app_typography.dart';
import 'package:farmcom/core/routing/app_routes.dart';
import 'package:farmcom/features/auth/presentation/providers/auth_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider).user;

    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurfaceBright : Colors.white,
      child: CustomScrollView(
        slivers: [
          // Drawer Header
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: 140,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.primarySoft,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [AppColors.primaryDark.withValues(alpha: 0.6), AppColors.primary.withValues(alpha: 0.4)]
                        : [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.name ?? 'Farmer',
                      style: AppTypography.headlineMedium.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.phone ?? 'Not connected',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Menu Items
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 8),
                _DrawerItem(
                  icon: Icons.notifications_rounded,
                  label: 'Notifications',
                  onTap: () {
                    Navigator.pop(context);
                    context.go(AppRoutes.notifications);
                  },
                  isDark: isDark,
                ),
                _DrawerItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    context.go(AppRoutes.settings);
                  },
                  isDark: isDark,
                ),
                _DrawerItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                    _showHelpBottomSheet(context, isDark);
                  },
                  isDark: isDark,
                ),
                _DrawerItem(
                  icon: Icons.info_outline_rounded,
                  label: 'About FarmCom',
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context, isDark);
                  },
                  isDark: isDark,
                ),
                const Divider(indent: 16, endIndent: 16),
                _DrawerItem(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutConfirmation(context, ref);
                  },
                  isDark: isDark,
                  isDestructive: true,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpBottomSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurfaceBright : Colors.white,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Help & Support',
              style: AppTypography.headlineMedium.copyWith(
                color: isDark ? Colors.white : AppColors.grey900,
              ),
            ),
            const SizedBox(height: 20),
            _HelpItem(
              title: 'How to use Diagnostics',
              description: 'Learn how to identify crop diseases using AI',
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _HelpItem(
              title: 'Join Communities',
              description: 'Find and join crop-specific communities',
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _HelpItem(
              title: 'Offline Mode',
              description: 'Use FarmCom without internet connection',
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _HelpItem(
              title: 'Contact Support',
              description: 'Get help from our support team',
              isDark: isDark,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppColors.darkSurfaceBright : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'About FarmCom',
                style: AppTypography.headlineMedium.copyWith(
                  color: isDark ? Colors.white : AppColors.grey900,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'v1.0.0',
                style: TextStyle(
                  color: isDark ? Colors.white70 : AppColors.grey600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'FarmCom is an offline-first mobile platform bridging the rural agriculture extension gap in East Africa. Farmers get access to AI-powered disease diagnostics, peer communities, and expert consultations.',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : AppColors.grey700,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Made with ❤️ for East African farmers',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout from FarmCom?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final bool isDestructive;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final String title;
  final String description;
  final bool isDark;

  const _HelpItem({
    required this.title,
    required this.description,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.darkSurfaceVariant : AppColors.grey100,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: isDark ? Colors.white : AppColors.grey900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : AppColors.grey600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
