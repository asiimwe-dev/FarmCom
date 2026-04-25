import 'package:logger/logger.dart' as log_pkg;

final _logger = log_pkg.Logger();

class Logger {
  static void info(String message) => _logger.i(message);
  static void i(String message) => _logger.i(message);
  static void success(String message) => _logger.i('✅ $message');
  static void warning(String message) => _logger.w(message);
  static void w(String message) => _logger.w(message);
  static void error(String message, [StackTrace? st]) => _logger.e(message, stackTrace: st);
  static void e(String message, [StackTrace? st]) => _logger.e(message, stackTrace: st);
}
