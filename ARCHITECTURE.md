# FarmCom Architecture Guide

## Overview
FarmCom uses **Clean Architecture + Domain-Driven Design (DDD)** with a strict **Feature-First** organization. This ensures:
- **Zero coupling** between features
- **Testability** at every layer
- **Offline-first resilience** through centralized sync
- **Scalability** for Phase 2 (marketplace) and Phase 3 (lending)

---

## Directory Structure

### `lib/core/` — Shared Infrastructure & Abstractions

#### `core/domain/`
Pure business logic shared across all features. **No external dependencies here.**

```
domain/
├── entities/           # Shared value objects (User, Transaction, etc.)
├── repositories/       # Interfaces only - contracts that features implement
├── exceptions/         # AppException, NetworkException, StorageException
└── usecases/          # Cross-cutting concerns (CheckConnectivity, SyncOutbox)
```

**Example:** `core/domain/repositories/iauth_repository.dart` (interface)
```dart
abstract class IAuthRepository {
  Future<User> verifyOTP(String phone, String otp);
  Stream<User?> watchCurrentUser();
}
```

#### `core/infrastructure/`
**Concrete implementations** of storage, network, and external services. Features depend on these.

```
infrastructure/
├── connectivity/       # Network state stream, offline detection
├── storage/           # Isar database initialization & migrations
├── sync/              # **CRITICAL**: Outbox pattern, sync worker, conflict resolution
├── services/          # Supabase, Flutterwave, Plant.id API clients
└── cache/             # In-memory caching layer for DTOs
```

**Key Files:**
- `sync/outbox_queue.dart` — Queues offline actions
- `sync/sync_worker.dart` — Syncs when online
- `storage/isar_provider.dart` — Global DB instance
- `services/supabase_service.dart` — Auth & data sync

#### `core/routing/`
GoRouter setup with `StatefulShellRoute` for persistent bottom navigation.

#### `core/theme/`
Material 3 colors, typography, theme extensions.

#### `core/constants/`
API endpoints, asset paths, feature flags.

#### `core/utils/`
Global helpers: image compression, date formatting, validators.

---

### `lib/features/` — Feature Modules

Each feature is **completely isolated**. Structure:

```
features/[FEATURE]/
├── domain/            # Pure business logic (no Flutter dependencies)
│   ├── entities/      # User, Post, Disease (core domain objects)
│   ├── repositories/  # Interfaces that data layer implements
│   └── usecases/      # Business workflows (VerifyOTP, FetchPosts)
│
├── data/              # External data + mapping to domain
│   ├── datasources/   # Remote (Supabase) & Local (Isar) data access
│   ├── models/        # DTO classes with JSON serialization
│   └── repositories/  # Implementation of domain/repositories/
│
└── presentation/      # UI + State Management
    ├── providers/     # Riverpod StateNotifiers & AsyncValues
    ├── pages/         # Full-screen widgets
    └── widgets/       # Reusable UI components
```

---

#### **Feature: `auth/`**
Phone OTP login, user profiles, session management.

**Domain:**
- `auth/domain/entities/user.dart` — User entity (pure Dart)
- `auth/domain/repositories/iauth_repository.dart` — Contract
- `auth/domain/usecases/verify_otp_usecase.dart` — Business logic

**Data:**
- `auth/data/datasources/remote_auth_datasource.dart` — Supabase OTP
- `auth/data/datasources/local_auth_datasource.dart` — Isar user cache
- `auth/data/models/user_model.dart` — JSON ↔ Dart mapping
- `auth/data/repositories/auth_repository.dart` — Implements `IAuthRepository`

**Presentation:**
- `auth/presentation/providers/auth_provider.dart` — Riverpod StateNotifier
- `auth/presentation/pages/otp_page.dart` — OTP entry UI
- `auth/presentation/widgets/phone_input_widget.dart` — Reusable input

---

#### **Feature: `field_guide/`**
Offline crop encyclopedia with disease diagnostics.

**Key Domain Concept:**
```dart
class CropGuide {
  final String cropName;
  final List<Disease> diseases;
  final List<GrowingTip> tips;
}
```

**Data Flow:**
1. Remote datasource fetches from Supabase (Phase 2)
2. Caches to Isar locally
3. App works offline from Isar
4. Sync worker pushes user notes back when online

---

#### **Feature: `community/`**
Offline-first forums with message outbox queue.

**Critical Design:**
```
community/data/datasources/local_community_datasource.dart
  → Writes to Isar immediately (offline)
  → Marks post as pending_sync

community/domain/usecases/sync_posts_usecase.dart
  → Called by core/infrastructure/sync/sync_worker.dart
  → Reads pending posts, pushes to Supabase
  → Marks as synced
```

---

#### **Feature: `diagnostics/`**
Camera + AI disease detection (Plant.id integration).

**Workflow:**
1. User takes photo (stored locally)
2. Compress & upload to Plant.id API
3. Parse disease results
4. Store to Isar for offline access
5. Sync metadata back to Supabase

---

#### **Feature: `payments/`**
Mobile money (Flutterwave) UI & escrow logic.

**Injected Service Pattern:**
```dart
// In auth feature
final paymentRepo = container.read(paymentRepositoryProvider);
await paymentRepo.verifyPaymentStatus(transactionId);

// In community feature (expert consulting)
await paymentRepo.initializeEscrow(expertId, amount);
```

---

### `test/` — Test Structure (Mirrors `lib/`)

```
test/
├── features/
│   ├── auth/
│   │   ├── domain/     # Business logic unit tests
│   │   ├── data/       # Repository & datasource mocks
│   │   └── presentation/
│   ├── community/
│   └── ...
├── core/
│   ├── infrastructure/ # Sync engine, storage tests
│   └── domain/
└── integration/        # Multi-feature workflows
```

---

## Key Architectural Decisions

### 1. **Offline-First Sync Engine** (Critical for Uganda)
```dart
// Location: core/infrastructure/sync/sync_worker.dart
class SyncWorker {
  Future<void> syncAll() {
    // Called when online
    // Iterates through all features' pending items
    // Resolves conflicts
    // Updates local state
  }
}
```

### 2. **Isar as Single Source of Truth**
- All reads go through local cache first
- Remote updates sync back locally
- No network call = no crash

### 3. **Repository Pattern for Testability**
```dart
// Feature implementation
class AuthRepository implements IAuthRepository {
  final IAuthRemoteDataSource _remote;
  final IAuthLocalDataSource _local;
  
  @override
  Future<User> verifyOTP(String phone, String otp) async {
    // Try remote first, fallback to cache
  }
}

// Test: mock both datasources
```

### 4. **Riverpod for State Management**
- No `context` passing hell
- Reactive updates across features
- Easy to test with mocks

### 5. **Feature Isolation**
- `auth/` knows nothing about `community/`
- Both depend on `core/domain/` interfaces
- Easy to remove/add features for Phase 2/3

---

## Development Workflow

### Adding a New Feature (e.g., `marketplace/`)

1. **Create domain layer** (pure Dart, no dependencies)
   ```bash
   mkdir -p lib/features/marketplace/{domain,data,presentation}
   # Define entities & repository interfaces
   ```

2. **Implement data layer** (datasources + repository)
   ```bash
   mkdir -p lib/features/marketplace/data/{datasources,models,repositories}
   # Implement IMarketplaceRepository
   ```

3. **Build presentation** (providers + UI)
   ```bash
   mkdir -p lib/features/marketplace/presentation/{providers,pages,widgets}
   # Create Riverpod providers
   ```

4. **Add tests** (mirror structure)
   ```bash
   mkdir -p test/features/marketplace/{domain,data,presentation}
   ```

5. **Register with GoRouter** in `core/routing/`

---

## Dependency Flow (Clean Architecture)

```
Presentation Layer
    ↓ (depends on)
Domain Layer (entities, usecases, repository interfaces)
    ↓ (depends on)
Data Layer (datasources, implementations)
    ↓ (depends on)
Infrastructure Layer (Isar, Supabase, HTTP)
```

**Rule:** Lower layers **never** import upper layers. This prevents cycles.

---

## Phase 2/3 Scalability

This architecture supports:

### **Phase 2: Marketplace**
- Add `features/marketplace/`
- Reuse `core/domain/Payment`, `core/infrastructure/storage/`
- No changes needed to existing features ✅

### **Phase 3: Lending**
- Add `features/lending/`
- Inject payment & user data through repository interfaces
- Zero coupling ✅

---

## Conventions

| Layer | Rules |
|-------|-------|
| **Domain** | Pure Dart, no Flutter, no packages except `equatable` |
| **Data** | Can use `isar`, `supabase-flutter`, `http` |
| **Presentation** | Can use `flutter`, `riverpod`, `go_router` |
| **Core** | Interfaces live in `domain/`, implementations in `infrastructure/` |

---

## Next Steps

1. ✅ Structure created
2. Create `lib/main.dart` → GoRouter + Isar init
3. Define `core/domain/` interfaces
4. Scaffold `auth/` feature end-to-end
5. Build shared infrastructure (sync, storage)

Ready to start building! 🚀
