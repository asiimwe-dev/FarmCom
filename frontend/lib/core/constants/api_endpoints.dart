/// API Endpoints for FarmLink UG
class ApiEndpoints {
  // Supabase
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // Plant.id (AI Disease Detection)
  static const String plantIdBaseUrl = 'https://api.plant.id/api/v3';
  static const String plantIdApiKey = 'YOUR_PLANT_ID_API_KEY';

  // Flutterwave (Mobile Money)
  static const String flutterwaveBaseUrl = 'https://api.flutterwave.com/v3';
  static const String flutterwavePublicKey = 'YOUR_FLUTTERWAVE_PUBLIC_KEY';
  static const String flutterwaveSecretKey = 'YOUR_FLUTTERWAVE_SECRET_KEY';

  // Supabase Auth
  static const String supabaseAuthUrl = '$supabaseUrl/auth/v1';
  static const String supabaseStorageUrl = '$supabaseUrl/storage/v1';

  // Database Tables
  static const String usersTable = 'users';
  static const String postsTable = 'posts';
  static const String commentsTable = 'comments';
  static const String topicsTable = 'topics';
  static const String cropsTable = 'crops';
  static const String diseasesTable = 'diseases';
  static const String diagnosesTable = 'diagnoses';
  static const String transactionsTable = 'transactions';
  static const String reviewsTable = 'reviews';

  // Storage Buckets
  static const String profileBucket = 'profiles';
  static const String postsBucket = 'posts';
  static const String diagnosticsBucket = 'diagnostics';
}
