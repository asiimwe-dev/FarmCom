# FarmLink UG Architecture & Development Guide

**Comprehensive Technical Documentation for the FarmLink UG Platform**

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Project Structure](#project-structure)
3. [Feature Documentation](#feature-documentation)
4. [Development Setup](#development-setup)
5. [Design Patterns & Principles](#design-patterns--principles)
6. [Offline-First Sync Engine](#offline-first-sync-engine)
7. [Backend Architecture (Phase 2)](#backend-architecture-phase-2)
8. [Testing Strategy](#testing-strategy)
9. [Deployment & Build](#deployment--build)
10. [Contributing & Code Standards](#contributing--code-standards)

---

## Architecture Overview

### Design Philosophy

FarmLink UG uses **Clean Architecture + Domain-Driven Design (DDD)** with a strict **Feature-First** modular organization. This approach ensures:

- **Zero coupling** between features (each feature is independently deployable)
- **Testability** at every architectural layer (domain, data, presentation)
- **Scalability** for future phases (Phase 2: Marketplace, Phase 3: Lending)
- **Maintainability** through clear separation of concerns
- **Offline-first resilience** with centralized sync engine

### Architectural Layers

```
┌─────────────────────────────────────────────────────────────┐
│ PRESENTATION LAYER                                          │
│ UI Components, Pages, Riverpod Providers, State Management  │
└─────────────────┬───────────────────────────────────────────┘
                  │ depends on
┌─────────────────▼───────────────────────────────────────────┐
│ DOMAIN LAYER                                                │
│ Pure Business Logic, Entities, Interfaces (No Frameworks)   │
└─────────────────┬───────────────────────────────────────────┘
                  │ depends on
┌─────────────────▼───────────────────────────────────────────┐
│ DATA LAYER                                                  │
│ Repository Implementations, Datasources, Models             │
└─────────────────┬───────────────────────────────────────────┘
                  │ depends on
┌─────────────────▼───────────────────────────────────────────┐
│ INFRASTRUCTURE LAYER                                        │
│ External Services (Isar, Supabase, HTTP, Flutterwave)       │
└─────────────────────────────────────────────────────────────┘
```

**Golden Rule:** Lower layers NEVER import upper layers. This prevents circular dependencies.

---

## Project Structure

### Root Directory Layout

```
FarmLink UG/
├── frontend/                          # Flutter mobile application
│   ├── lib/
│   │   ├── core/                     # Shared infrastructure
│   │   ├── features/                 # Feature modules
│   │   └── main.dart                 # Application entry point
│   ├── test/                         # Test suite
│   ├── android/                      # Android platform code
│   ├── ios/                          # iOS platform code (optional)
│   ├── linux/                        # Linux platform code
│   ├── pubspec.yaml                  # Dart dependencies
│   ├── analysis_options.yaml         # Linting rules
│   ├── .env.example                  # Environment template
│   └── .gitignore
│
├── backend/                          # Backend (Phase 2)
│   ├── src/                         # Source code
│   ├── migrations/                  # Database migrations
│   └── docker-compose.yml           # Local development
│
├── README.md                         # Project overview
├── ARCHITECTURE.md                   # This file
├── LICENSE                           # Apache 2.0
└── .gitignore
```

### Frontend `lib/` Structure

```
lib/
│
├── core/                             # Shared infrastructure (NO feature-specific code)
│   │
│   ├── domain/                       # Pure business abstractions
│   │   ├── entities/                # Core value objects (User, Transaction, etc.)
│   │   │   └── user.dart            # Shared across features
│   │   ├── repositories/            # Interfaces (contracts) - NO implementations
│   │   │   └── iauth_repository.dart
│   │   ├── exceptions/              # Custom exception hierarchy
│   │   │   ├── app_exception.dart
│   │   │   ├── network_exception.dart
│   │   │   └── storage_exception.dart
│   │   └── usecases/               # Cross-cutting concerns
│   │       └── check_connectivity_usecase.dart
│   │
│   ├── infrastructure/              # Concrete implementations
│   │   ├── storage/                # Local database
│   │   │   ├── isar_provider.dart  # Global Isar instance
│   │   │   └── schemas/            # Isar schema definitions
│   │   │       ├── user_schema.dart
│   │   │       ├── post_schema.dart
│   │   │       └── diagnostic_schema.dart
│   │   │
│   │   ├── sync/                   # CRITICAL: Outbox pattern & sync
│   │   │   ├── sync_worker.dart    # Main sync orchestrator
│   │   │   ├── outbox_queue.dart   # Pending items queue
│   │   │   └── conflict_resolver.dart
│   │   │
│   │   ├── connectivity/           # Network detection
│   │   │   └── connectivity_service.dart
│   │   │
│   │   └── services/               # External service clients
│   │       ├── supabase_service.dart
│   │       ├── flutterwave_service.dart
│   │       ├── plant_id_service.dart
│   │       └── logger_service.dart
│   │
│   ├── routing/                    # Navigation
│   │   ├── router_provider.dart    # GoRouter configuration
│   │   ├── main_shell.dart         # Bottom navigation shell
│   │   └── route_names.dart        # Route constants
│   │
│   ├── presentation/               # Global UI components
│   │   ├── widgets/               # Reusable widgets
│   │   │   ├── sync_signal_header.dart
│   │   │   ├── loading_indicator.dart
│   │   │   └── error_dialog.dart
│   │   └── theme/                 # Material 3 theming
│   │       ├── colors.dart
│   │       ├── typography.dart
│   │       └── theme_extension.dart
│   │
│   ├── utils/                     # Global helpers
│   │   ├── logger.dart            # Production logging
│   │   ├── validators.dart        # Input validation
│   │   ├── date_formatter.dart
│   │   └── image_processor.dart   # Compression utilities
│   │
│   └── constants/                 # Global constants
│       ├── api_endpoints.dart
│       ├── asset_paths.dart
│       └── feature_flags.dart
│
└── features/                        # Feature modules (ISOLATED)
    │
    ├── auth/                       # Feature: Authentication
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user.dart
    │   │   ├── repositories/
    │   │   │   └── iauth_repository.dart
    │   │   └── usecases/
    │   │       ├── send_otp_usecase.dart
    │   │       ├── verify_otp_usecase.dart
    │   │       └── logout_usecase.dart
    │   │
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── remote_auth_datasource.dart (Supabase)
    │   │   │   └── local_auth_datasource.dart (Isar)
    │   │   ├── models/
    │   │   │   └── user_model.dart (JSON ↔ Dart mapping)
    │   │   └── repositories/
    │   │       └── auth_repository.dart (IAuthRepository implementation)
    │   │
    │   └── presentation/
    │       ├── providers/
    │       │   └── auth_provider.dart (Riverpod StateNotifier)
    │       ├── pages/
    │       │   ├── otp_page.dart
    │       │   └── profile_page.dart
    │       └── widgets/
    │           ├── phone_input_widget.dart
    │           └── otp_input_widget.dart
    │
    ├── dashboard/                  # Feature: Home Dashboard
    │   ├── domain/ (minimal)
    │   ├── data/ (minimal)
    │   └── presentation/
    │       ├── pages/
    │       │   └── dashboard_page.dart
    │       └── widgets/
    │           ├── quick_actions_card.dart
    │           ├── market_pulse_list.dart
    │           └── communities_list.dart
    │
    ├── field_guide/                # Feature: Offline Encyclopedia
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── crop_guide.dart
    │   │   │   └── disease.dart
    │   │   └── repositories/
    │   │       └── ifieldguide_repository.dart
    │   │
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── remote_fieldguide_datasource.dart
    │   │   │   └── local_fieldguide_datasource.dart
    │   │   └── repositories/
    │   │       └── fieldguide_repository.dart
    │   │
    │   └── presentation/
    │       ├── pages/
    │       │   └── field_guide_page.dart
    │       └── widgets/
    │           ├── crop_card.dart
    │           └── disease_detail_widget.dart
    │
    ├── community/                  # Feature: Forums
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── post.dart
    │   │   │   └── community.dart
    │   │   ├── repositories/
    │   │   │   └── icommunity_repository.dart
    │   │   └── usecases/
    │   │       ├── fetch_posts_usecase.dart
    │   │       └── create_post_usecase.dart
    │   │
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── remote_community_datasource.dart
    │   │   │   └── local_community_datasource.dart
    │   │   └── repositories/
    │   │       └── community_repository.dart
    │   │
    │   └── presentation/
    │       ├── providers/
    │       │   └── community_provider.dart
    │       ├── pages/
    │       │   └── community_page.dart
    │       └── widgets/
    │           ├── post_card.dart
    │           └── voice_note_button.dart
    │
    ├── diagnostics/                # Feature: AI Disease Detection
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── diagnosis.dart
    │   │   │   └── treatment.dart
    │   │   └── repositories/
    │   │       └── idiagnostics_repository.dart
    │   │
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── remote_diagnostics_datasource.dart (Plant.id)
    │   │   │   └── local_diagnostics_datasource.dart (Isar)
    │   │   └── repositories/
    │   │       └── diagnostics_repository.dart
    │   │
    │   └── presentation/
    │       ├── pages/
    │       │   └── diagnostics_page.dart
    │       └── widgets/
    │           ├── camera_capture_widget.dart
    │           └── disease_result_widget.dart
    │
    └── payments/                   # Feature: Mobile Money
        ├── domain/
        │   ├── entities/
        │   │   ├── transaction.dart
        │   │   └── payment_status.dart
        │   └── repositories/
        │       └── ipayment_repository.dart
        │
        ├── data/
        │   ├── datasources/
        │   │   └── flutterwave_datasource.dart
        │   └── repositories/
        │       └── payment_repository.dart
        │
        └── presentation/
            ├── pages/
            │   └── payments_page.dart
            └── widgets/
                ├── payment_form_widget.dart
                └── transaction_history_widget.dart

└── main.dart                        # Application entry point
```

---

## Feature Documentation

### Feature Template

Each feature follows this pattern:

#### **Feature: `auth/` — Phone OTP Authentication**

**Domain Layer** (`auth/domain/`)
```dart
// entities/user.dart
class User {
  final String id;
  final String phone;
  final String? name;
  final DateTime? createdAt;
}

// repositories/iauth_repository.dart
abstract class IAuthRepository {
  Future<User> verifyOTP(String phone, String otp);
  Stream<User?> watchCurrentUser();
  Future<void> logout();
}
```

**Data Layer** (`auth/data/`)
```dart
// datasources/remote_auth_datasource.dart
class RemoteAuthDataSource {
  Future<UserModel> verifyOTP(String phone, String otp) async {
    // Call Supabase OTP verification
  }
}

// repositories/auth_repository.dart
class AuthRepository implements IAuthRepository {
  final IAuthRemoteDataSource _remote;
  final IAuthLocalDataSource _local;

  @override
  Future<User> verifyOTP(String phone, String otp) async {
    try {
      // Try remote first
      final user = await _remote.verifyOTP(phone, otp);
      // Cache locally
      await _local.saveUser(user);
      return user;
    } on NetworkException {
      // Fallback to cache
      return await _local.getUser();
    }
  }
}
```

**Presentation Layer** (`auth/presentation/`)
```dart
// providers/auth_provider.dart
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});

// pages/otp_page.dart
class OTPPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      body: authState.when(
        data: (user) => user != null ? HomePage() : OTPForm(),
        loading: () => LoadingIndicator(),
        error: (err, stack) => ErrorDialog(message: err.toString()),
      ),
    );
  }
}
```

---

### Implemented Features Summary

| Feature | Status | Description | Key Files |
|---------|--------|-------------|-----------|
| **Auth** | ✅ Complete | Phone OTP login, profile management | `auth/{domain,data,presentation}` |
| **Dashboard** | ✅ Complete | Home screen, quick actions | `dashboard/presentation/` |
| **Field Guide** | ✅ Complete | Offline crop encyclopedia | `field_guide/{domain,data,presentation}` |
| **Community** | ✅ Complete | Peer forums, discussion | `community/{domain,data,presentation}` |
| **Diagnostics** | ✅ Complete | AI disease detection UI | `diagnostics/{domain,data,presentation}` |
| **Payments** | ✅ Complete | Mobile money integration UI | `payments/{domain,data,presentation}` |

---

## Development Setup

### Prerequisites

```bash
# Minimum versions
Flutter SDK: 3.19.0+
Dart SDK: 3.1.0+
Android SDK: API level 33+
Xcode: 14.0+ (macOS only, for iOS builds)
```

### Installation

1. **Clone repository**
   ```bash
   git clone https://github.com/asiimwe-dev/FarmLink UG.git
   cd FarmLink UG/frontend
   ```

2. **Check Flutter setup**
   ```bash
   flutter doctor -v
   # Should show ✓ for Flutter, Dart, Android Studio, and target OS
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Configure environment variables**
   ```bash
   # Create .env file in frontend root
   cp .env.example .env
   
   # Edit .env with your credentials
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   FLUTTERWAVE_PUBLIC_KEY=FLWPUB_TEST_xxxxx
   PLANT_ID_API_KEY=xxxxx
   ```

5. **Generate code**
   ```bash
   # Generate Isar schemas and Riverpod providers
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run application**
   ```bash
   # List connected devices
   flutter devices
   
   # Run on emulator/device
   flutter run
   
   # Run with specific device ID
   flutter run -d <device_id>
   ```

### Development Workflow

```bash
# Check code quality
flutter analyze                    # 0 errors required

# Format code
dart format lib/

# Run tests
flutter test                       # All tests
flutter test test/features/auth/  # Feature tests

# Run with specific profile
flutter run --profile             # Performance profiling

# Build APK for testing
flutter build apk --debug         # Debug build
flutter build apk --release       # Release build

# Build for iOS (macOS only)
flutter build ios --release
```

---

## Design Patterns & Principles

### 1. **Repository Pattern**

**Benefit:** Abstraction layer allows swapping datasources without changing business logic.

```dart
// Domain layer (no implementation details)
abstract class IAuthRepository {
  Future<User> verifyOTP(String phone, String otp);
}

// Data layer (implementation)
class AuthRepository implements IAuthRepository {
  final IAuthRemoteDataSource _remote;
  final IAuthLocalDataSource _local;

  @override
  Future<User> verifyOTP(String phone, String otp) async {
    try {
      return await _remote.verifyOTP(phone, otp);
    } catch (e) {
      return await _local.getUser();  // Fallback to cache
    }
  }
}

// Testing (mock both datasources)
class MockAuthRemoteDataSource extends Mock implements IAuthRemoteDataSource {}
class MockAuthLocalDataSource extends Mock implements IAuthLocalDataSource {}

test('verifyOTP returns cached user on network error', () {
  final remote = MockAuthRemoteDataSource();
  final local = MockAuthLocalDataSource();
  
  when(remote.verifyOTP(any, any)).thenThrow(NetworkException(''));
  when(local.getUser()).thenAnswer((_) async => mockUser);
  
  final repo = AuthRepository(remote, local);
  final result = await repo.verifyOTP('256700000000', '123456');
  
  expect(result, mockUser);
});
```

### 2. **Riverpod for State Management**

**Benefit:** Type-safe, testable, no BuildContext needed.

```dart
// Define provider
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

// Use in widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return authState.when(
      data: (user) => Text(user?.phone ?? 'Not logged in'),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}

// Test with mocks
test('auth provider returns user', () async {
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(mockRepository),
    ],
  );
  
  final state = await container.read(authProvider.future);
  expect(state?.phone, '256700000000');
});
```

### 3. **Outbox Pattern (Critical for Offline-First)**

**Benefit:** Guarantees data consistency even if sync fails partway through.

```dart
// When user creates post (ALWAYS succeeds locally)
await _local.createPost(post);
await _local.markForSync(post.id, 'pending');

// Background sync worker
class SyncWorker {
  Future<void> syncAll() {
    final pendingPosts = await _local.getPendingPosts();
    
    for (final post in pendingPosts) {
      try {
        await _remote.createPost(post);
        await _local.markForSync(post.id, 'synced');
      } catch (e) {
        // Stay pending, retry next sync
        await _local.recordError(post.id, e.toString());
      }
    }
  }
}
```

### 4. **Exception Hierarchy**

**Benefit:** Explicit error handling at presentation layer.

```dart
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class NetworkException extends AppException {
  const NetworkException(String message) : super(message);
}

class StorageException extends AppException {
  const StorageException(String message) : super(message);
}

class ValidationException extends AppException {
  const ValidationException(String message) : super(message);
}

// Usage in repository
try {
  return await _remote.fetch();
} on SocketException catch (e) {
  throw NetworkException('No internet: ${e.message}');
} on DatabaseException catch (e) {
  throw StorageException('Database error: ${e.message}');
}
```

---

## Offline-First Sync Engine

### Architecture

```
┌────────────────────────────────────────────────────────────┐
│ User Action (post to forum, capture diagnostic, etc.)      │
└────────────┬─────────────────────────────────────────────┘
             │
             ▼
┌────────────────────────────────────────────────────────────┐
│ Check Network Status                                       │
└────┬──────────────────────────────────────┬────────────────┘
     │                                      │
     ▼ ONLINE                               ▼ OFFLINE
┌──────────────────┐                ┌──────────────────┐
│ Push to Supabase │                │ Write to Isar    │
│ Update local Isar│                │ Mark 'pending'   │
└──────────────────┘                └───────┬──────────┘
     │                                      │
     └──────────────────┬───────────────────┘
                        │
            ┌───────────▼────────────┐
            │ Monitor Connectivity    │
            │ (connectivity_plus)     │
            └───────────┬─────────────┘
                        │
         ┌──────────────▼──────────────┐
         │ Network Available?          │
         └───┬───────────────────────┬─┘
             │ YES                   │ NO
             ▼                       └─ Wait...
    ┌─────────────────────────┐
    │ SyncWorker.syncAll()    │
    │ 1. Fetch pending items  │
    │ 2. Push to Supabase     │
    │ 3. Resolve conflicts    │
    │ 4. Mark synced locally  │
    └─────────────────────────┘
```

### Key Components

#### `core/infrastructure/storage/isar_provider.dart`
```dart
// Global Isar instance
late final Isar isar;

Future<void> initializeIsar() async {
  isar = await Isar.open([
    UserSchema,
    PostSchema,
    DiagnosticSchema,
    TransactionSchema,
  ]);
}
```

#### `core/infrastructure/sync/sync_worker.dart`
```dart
class SyncWorker {
  final _connectivity = Connectivity();
  late StreamSubscription _connectivitySubscription;

  Future<void> initialize() async {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        _syncAll();  // Sync when online
      }
    });
  }

  Future<void> _syncAll() async {
    try {
      // Sync from each feature
      await _syncAuthData();
      await _syncCommunityPosts();
      await _syncDiagnostics();
      await _syncPayments();
    } catch (e) {
      logger.e('Sync failed: $e');
      // Will retry on next connectivity change
    }
  }
}
```

#### Isar Schema Example
```dart
// Isar schema with sync metadata
@collection
class PostSchema {
  Id id = Isar.autoIncrement;
  late String content;
  late String communityId;
  late DateTime createdAt;

  // Sync metadata
  @Index()
  late bool isPending;
  late String syncStatus;  // 'pending', 'syncing', 'synced', 'failed'
  late int retryCount;
  late String? lastError;
  late DateTime? syncedAt;
}
```

### Conflict Resolution Strategy

**Last Write Wins (LWW) with Manual Override**

```dart
class ConflictResolver {
  Future<Post> resolve(Post local, Post remote) async {
    if (remote.updatedAt.isAfter(local.updatedAt)) {
      // Remote is newer, use it
      return remote;
    } else {
      // Local is newer, keep it
      return local;
    }
  }
  
  // For forums, allow manual selection
  Future<Post> resolveForumConflict(Post local, Post remote) async {
    final choice = await _showConflictDialog(local, remote);
    return choice == 'local' ? local : remote;
  }
}
```

---

## Backend Architecture (Phase 2)

### Current Status
Frontend is production-ready. Backend design phase in progress.

### Planned PostgreSQL Schema

```sql
-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY,
  phone VARCHAR(20) UNIQUE NOT NULL,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  avatar_url TEXT,
  is_verified_expert BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Communities (crop-specific)
CREATE TABLE communities (
  id UUID PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  crop_type VARCHAR(50) NOT NULL,
  description TEXT,
  member_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT now()
);

-- Community posts
CREATE TABLE posts (
  id UUID PRIMARY KEY,
  community_id UUID REFERENCES communities(id),
  user_id UUID REFERENCES users(id),
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now(),
  INDEX idx_community_posts (community_id, created_at DESC)
);

-- Diagnostics
CREATE TABLE diagnostics (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  image_url TEXT NOT NULL,
  crop_type VARCHAR(50),
  disease_identified VARCHAR(100),
  confidence_score DECIMAL(3,2),
  treatment_recommendation TEXT,
  created_at TIMESTAMP DEFAULT now()
);

-- Payments
CREATE TABLE transactions (
  id UUID PRIMARY KEY,
  from_user_id UUID REFERENCES users(id),
  to_user_id UUID REFERENCES users(id),
  amount DECIMAL(10,2),
  currency VARCHAR(3) DEFAULT 'UGX',
  status VARCHAR(20),  -- 'pending', 'completed', 'failed'
  reference_id VARCHAR(100) UNIQUE,  -- Flutterwave reference
  created_at TIMESTAMP DEFAULT now(),
  completed_at TIMESTAMP
);
```

### Planned API Endpoints

```
POST   /api/v1/auth/send-otp
POST   /api/v1/auth/verify-otp
POST   /api/v1/auth/logout

GET    /api/v1/communities
GET    /api/v1/communities/{id}/posts
POST   /api/v1/communities/{id}/posts

GET    /api/v1/diagnostics
POST   /api/v1/diagnostics

GET    /api/v1/payments/history
POST   /api/v1/payments/initiate
POST   /api/v1/payments/webhook  # Flutterwave callback
```

### Row-Level Security (RLS) Policies

```sql
-- Users see only their own profile
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
CREATE POLICY user_self_access ON users
  FOR SELECT USING (auth.uid() = id);

-- Users can post to any community
CREATE POLICY user_can_post ON posts
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can edit only their own posts
CREATE POLICY user_edit_own_post ON posts
  FOR UPDATE USING (auth.uid() = user_id);

-- Users can view all posts
CREATE POLICY anyone_view_posts ON posts
  FOR SELECT USING (true);
```

### Real-Time Subscriptions

```dart
// Listen for new posts in community
Supabase.instance.client
  .from('posts')
  .on(RealtimeListenTypes.postgresChanges, 
      filter: PostgresChangeFilter(
        event: '*',
        schema: 'public',
        table: 'posts',
        filter: 'community_id=eq.${communityId}'))
  .subscribe((payload) {
    // Handle new post
  });
```

---

## Testing Strategy

### Test Structure

```
test/
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       ├── verify_otp_usecase_test.dart
│   │   │       └── logout_usecase_test.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── remote_auth_datasource_test.dart
│   │   │   │   └── local_auth_datasource_test.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_test.dart
│   │   └── presentation/
│   │       └── providers/
│   │           └── auth_provider_test.dart
│   ├── community/
│   ├── diagnostics/
│   └── ...
├── core/
│   ├── infrastructure/
│   │   ├── sync/
│   │   │   └── sync_worker_test.dart
│   │   └── storage/
│   │       └── isar_provider_test.dart
│   └── domain/
│       └── exceptions/
│           └── exception_test.dart
└── integration/
    ├── auth_flow_test.dart
    ├── community_post_sync_test.dart
    └── offline_scenario_test.dart
```

### Unit Test Example

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  group('VerifyOTPUsecase', () {
    late VerifyOTPUsecase usecase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      usecase = VerifyOTPUsecase(mockRepository);
    });

    test('returns user when OTP is valid', () async {
      // Arrange
      const phone = '256700000000';
      const otp = '123456';
      final mockUser = User(
        id: '1',
        phone: phone,
        name: 'John Farmer',
      );
      
      when(mockRepository.verifyOTP(phone, otp))
          .thenAnswer((_) async => mockUser);

      // Act
      final result = await usecase(phone, otp);

      // Assert
      expect(result, mockUser);
      verify(mockRepository.verifyOTP(phone, otp)).called(1);
    });

    test('throws exception when OTP is invalid', () async {
      // Arrange
      when(mockRepository.verifyOTP(any, any))
          .thenThrow(AppException('Invalid OTP'));

      // Act & Assert
      expect(
        () => usecase('256700000000', '000000'),
        throwsA(isA<AppException>()),
      );
    });
  });
}
```

### Widget Test Example

```dart
void main() {
  group('OTPPage', () {
    testWidgets('shows loading while verifying', (WidgetTester tester) async {
      // Arrange
      final mockAuthNotifier = MockAuthNotifier();
      when(mockAuthNotifier.state).thenReturn(AsyncValue.loading());

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWithValue(mockAuthNotifier),
          ],
          child: MaterialApp(home: OTPPage()),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/domain/usecases/verify_otp_usecase_test.dart

# Run with coverage
flutter test --coverage
coverage/

# Run integration tests (if available)
flutter drive --target=test_driver/app.dart
```

---

## Deployment & Build

### Android Build

```bash
# Debug build (for testing)
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk

# Release build
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Bundle (for Google Play)
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS Build (macOS only)

```bash
# Build iOS app
flutter build ios --release
# Output: build/ios/ipa/

# Build for simulator
flutter build ios --debug
```

### Building for Linux

```bash
# Build Linux app
flutter build linux --release
# Output: build/linux/release/bundle/
```

### Environment-Specific Builds

```bash
# Development build
flutter run --dart-define=ENV=development

# Production build
flutter run --dart-define=ENV=production \
            --dart-define=SUPABASE_URL=prod_url \
            --dart-define=SUPABASE_KEY=prod_key
```

---

## Code Quality & Standards

### Static Analysis

```bash
# Run analyzer
flutter analyze

# Show all issues (including info)
flutter analyze --no-fatal-infos

# Export results
flutter analyze > analysis-results.txt
```

### Current Quality Metrics

```
✅ 0 ERRORS
✅ 0 WARNINGS
ℹ️  107 info-level suggestions (const constructors, etc.)
```

### Code Formatting

```bash
# Format all files
dart format lib/ test/

# Check formatting
dart format lib/ --output=none --set-exit-if-changed
```

### Linting Rules

See `analysis_options.yaml` for custom rules:
- No unimplemented equals/hashCode
- Const constructors enforced
- Generated code exclusions (Isar, Freezed, etc.)

---

## Contributing & Code Standards

### Pull Request Process

1. **Fork and create feature branch**
   ```bash
   git checkout -b feature/add-crop-search
   ```

2. **Follow code standards**
   - Run `flutter analyze` (0 errors required)
   - Run `dart format lib/`
   - Add tests for new functionality
   - Update documentation

3. **Commit with clear messages**
   ```bash
   git commit -m "feat: add crop search to field guide

   - Implements search UI in field_guide/presentation/
   - Adds search usecase in field_guide/domain/usecases/
   - Adds tests for search functionality
   
   Fixes #123"
   ```

4. **Push and create pull request**
   ```bash
   git push origin feature/add-crop-search
   # Then create PR on GitHub
   ```

### Code Style Guide

**File Naming**
- Classes: `PascalCase` (e.g., `AuthProvider`)
- Files: `snake_case` (e.g., `auth_provider.dart`)
- Constants: `camelCase` (e.g., `defaultTimeout`)

**Class Organization**
```dart
class MyClass {
  // 1. Static fields & constants
  static const String className = 'MyClass';
  
  // 2. Instance fields
  final String name;
  final int count;
  
  // 3. Constructor
  const MyClass({
    required this.name,
    required this.count,
  });
  
  // 4. Factory constructors
  factory MyClass.empty() => MyClass(name: '', count: 0);
  
  // 5. Getters
  int get total => count * 2;
  
  // 6. Methods (public first, then private)
  void doSomething() => _internals();
  void _internals() {}
  
  // 7. Overrides (toString, hashCode, ==)
  @override
  String toString() => 'MyClass($name, $count)';
}
```

**Comments**
- Only comment non-obvious logic
- Use `///` for public APIs (generates documentation)
- Use `//` for implementation comments

```dart
/// Verifies OTP and returns authenticated user.
/// 
/// Throws [ValidationException] if phone or OTP invalid.
/// Throws [NetworkException] if no connectivity.
Future<User> verifyOTP(String phone, String otp) async {
  // Validate phone format
  if (!_isValidPhone(phone)) {
    throw ValidationException('Invalid phone format');
  }
  
  // Call backend
  return await _repository.verifyOTP(phone, otp);
}
```

### Feature Addition Checklist

When adding a new feature (e.g., `marketplace/`):

```
[ ] Create domain layer
    [ ] Create entities
    [ ] Create repository interfaces
    [ ] Create usecases
    
[ ] Create data layer
    [ ] Create remote datasource
    [ ] Create local datasource (Isar schema)
    [ ] Create models with JSON serialization
    [ ] Implement repository
    
[ ] Create presentation layer
    [ ] Create Riverpod providers
    [ ] Create pages
    [ ] Create reusable widgets
    
[ ] Add routing
    [ ] Add route name to constants
    [ ] Add GoRoute to router_provider
    [ ] Add navigation from relevant pages
    
[ ] Add tests
    [ ] Unit tests for domain usecases
    [ ] Unit tests for repository
    [ ] Widget tests for UI
    
[ ] Update documentation
    [ ] Add feature section to ARCHITECTURE.md
    [ ] Add feature to README.md feature list
    [ ] Document data model in architecture
    
[ ] Code quality
    [ ] Run flutter analyze (0 errors)
    [ ] Run dart format lib/
    [ ] Run flutter test
```

---

## Troubleshooting

### Build Issues

| Issue | Solution |
|-------|----------|
| `Gradle build failed` | Run `flutter clean && flutter pub get` |
| `Isar generated files error` | Run `flutter pub run build_runner build --delete-conflicting-outputs` |
| `Android SDK version mismatch` | Check `android/app/build.gradle.kts` and `flutter doctor` |
| `Pod file locked error` | Run `cd ios && rm -rf Pods && rm Podfile.lock && cd ..` then `flutter pub get` |

### Development Issues

| Issue | Solution |
|-------|----------|
| `RenderFlex overflowed` | Check widget constraints and use `SingleChildScrollView` |
| `State not updating` | Verify Riverpod provider is being `watch`ed, not `read` |
| `Isar queries empty` | Check schema migrations and `.open()` initialization |
| `Hot reload not working` | Use full restart: `r` then `R` |

---

## Additional Resources

- **Flutter**: https://flutter.dev/docs
- **Dart**: https://dart.dev/guides
- **Riverpod**: https://riverpod.dev/docs
- **Isar**: https://isar.dev/
- **Supabase**: https://supabase.com/docs
- **GoRouter**: https://pub.dev/packages/go_router

---

**Last Updated:** April 2026  
**Version:** 1.0  
**Maintainer:** FarmLink UG Development Team
