/// App route constants
class AppRoutes {
  // Auth routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String otp = '/otp';

  // Main app routes (shell routes)
  static const String home = '/home';
  static const String community = '/community';
  static const String fieldGuide = '/field-guide';
  static const String diagnostics = '/diagnostics';
  static const String profile = '/profile';

  // Details screens
  static const String postDetail = '/post/:id';
  static const String cropDetail = '/crop/:id';
  static const String diagnosisDetail = '/diagnosis/:id';

  // Payments
  static const String payment = '/payment';
  static const String transactionHistory = '/transactions';

  // Settings
  static const String settings = '/settings';
  static const String about = '/about';
}
