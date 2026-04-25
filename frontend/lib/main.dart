import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:farmcom/core/infrastructure/storage/isar_provider.dart';  // Disabled for AGP 8.x compatibility
import 'package:farmcom/core/routing/router_provider.dart';
import 'package:farmcom/core/theme/app_theme.dart';
import 'package:farmcom/core/constants/app_strings.dart';
import 'package:farmcom/core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Note: Isar initialization temporarily disabled to unblock UI testing
  // Re-enable after resolving AGP 8.x AndroidManifest.xml package attribute issue
  Logger.i('⏳ Isar database initialization deferred');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get router instance
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
