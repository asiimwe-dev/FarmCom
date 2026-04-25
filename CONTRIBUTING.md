# Contributing to FarmCom

Thank you for your interest in contributing to FarmCom! This guide will help you understand our development process, code standards, and how to submit contributions effectively.

---

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [Development Setup](#development-setup)
4. [Making Changes](#making-changes)
5. [Code Standards](#code-standards)
6. [Feature Development](#feature-development)
7. [Testing](#testing)
8. [Commit & Push](#commit--push)
9. [Pull Request Process](#pull-request-process)
10. [Reporting Issues](#reporting-issues)
11. [Questions & Support](#questions--support)

---

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of background, identity, or experience level.

### Expected Behavior

- **Be Respectful:** Treat all team members with courtesy and professionalism
- **Be Collaborative:** Work together to solve problems and improve the codebase
- **Be Constructive:** Provide feedback that helps improve code quality
- **Be Inclusive:** Welcome diverse perspectives and encourage participation

### Unacceptable Behavior

- Harassment, discrimination, or exclusionary language
- Disrespect or dismissive comments
- Spam or irrelevant content
- Personal attacks or insults

**Violations:** Report to the development team immediately.

---

## Getting Started

### Prerequisites

Before contributing, ensure you have:

```bash
# Required
Flutter SDK: 3.19.0+
Dart SDK: 3.1.0+
Git: 2.30+
Android SDK: API 33+ (for Android development)

# Optional
Xcode: 14.0+ (for iOS development)
Android Studio or VSCode
```

### Step 1: Fork & Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/FarmCom.git
cd FarmCom

# Add upstream remote for syncing
git remote add upstream https://github.com/asiimwe-dev/FarmCom.git
```

### Step 2: Verify Setup

```bash
# Check Flutter installation
flutter doctor -v

# Install dependencies
cd frontend
flutter pub get

# Verify code quality
flutter analyze
```

---

## Development Setup

### Environment Configuration

1. **Copy environment template**
   ```bash
   cd frontend
   cp .env.example .env
   ```

2. **Add your credentials** (development values)
   ```bash
   SUPABASE_URL=https://your-dev-project.supabase.co
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   FLUTTERWAVE_PUBLIC_KEY=FLWPUB_TEST_xxxxx
   PLANT_ID_API_KEY=xxxxx
   ```

3. **Never commit .env** (already in .gitignore)

### Generate Code

```bash
# Generate Isar schemas and Riverpod providers
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes during development
flutter pub run build_runner watch
```

### Running the App

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Run in debug mode (default)
flutter run

# Run in profile mode (performance testing)
flutter run --profile

# Run in release mode (production testing)
flutter run --release
```

---

## Making Changes

### Create Feature Branch

```bash
# Update main branch
git fetch upstream
git checkout main
git merge upstream/main

# Create feature branch
git checkout -b feature/your-feature-name
```

**Branch Naming Convention:**
- `feature/add-crop-search` — New feature
- `bugfix/fix-sync-worker` — Bug fix
- `docs/update-architecture` — Documentation
- `refactor/simplify-auth-provider` — Code refactoring
- `test/add-community-tests` — Test additions

### Making Your Changes

1. **Edit code following standards** (see [Code Standards](#code-standards))
2. **Test frequently** (`flutter run` and manual testing)
3. **Run analysis** (`flutter analyze` - 0 errors required)
4. **Format code** (`dart format lib/`)

---

## Code Standards

### File Naming

```
✅ Good
auth_provider.dart          # snake_case for files
verify_otp_usecase.dart
post_card.dart

❌ Avoid
AuthProvider.dart           # PascalCase for files
VerifyOTPUsecase.dart
PostCard.dart
```

### Class Naming

```dart
✅ Good
class AuthProvider { }              // PascalCase
class VerifyOTPUsecase { }
class SyncWorker { }

❌ Avoid
class auth_provider { }             // snake_case
class verify_otp_usecase { }
```

### Variable & Method Naming

```dart
✅ Good
String userName = 'John';           // camelCase
const defaultTimeout = Duration(seconds: 30);
Future<void> verifyOTP() async { }
bool _isValidEmail(String email) { }

❌ Avoid
String user_name = 'John';          // snake_case
const DEFAULT_TIMEOUT = Duration(seconds: 30);
Future<void> VerifyOTP() async { }  // PascalCase for method
```

### Code Organization

```dart
class MyClass {
  // 1. Static constants
  static const String className = 'MyClass';
  static const int maxRetries = 3;

  // 2. Static fields
  static int instanceCount = 0;

  // 3. Instance fields (final first)
  final String name;
  final int value;
  late String _internalState;

  // 4. Constructor
  const MyClass({
    required this.name,
    required this.value,
  });

  // 5. Factory constructors
  factory MyClass.empty() => MyClass(name: '', value: 0);

  // 6. Getters
  int get doubleValue => value * 2;
  bool get isEmpty => name.isEmpty;

  // 7. Setters (if needed)
  set internalState(String value) => _internalState = value;

  // 8. Public methods
  void publicMethod() => _privateHelper();

  // 9. Private methods
  void _privateHelper() { }

  // 10. Overrides (toString, hashCode, ==)
  @override
  String toString() => 'MyClass($name, $value)';

  @override
  int get hashCode => Object.hash(name, value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyClass && name == other.name && value == other.value;
}
```

### Commenting

```dart
✅ Good Comments

/// Verifies OTP against backend and returns authenticated user.
/// 
/// Throws [ValidationException] if phone or OTP invalid.
/// Throws [NetworkException] if network unavailable.
/// 
/// Example:
/// ```dart
/// final user = await repo.verifyOTP('256700000000', '123456');
/// ```
Future<User> verifyOTP(String phone, String otp) async { }

class MyClass {
  // Initialize cache with default values
  void _initializeCache() { }
  
  // User clicked verify button - validate and submit
  void _onVerifyPressed() { }
}

❌ Poor Comments

// Verify OTP
Future<User> verifyOTP(String phone, String otp) async { }

// This does something
void doSomething() { }
```

### Imports Organization

```dart
✅ Good

import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import 'package:farmcom/core/domain/exceptions/app_exception.dart';
import 'package:farmcom/core/utils/logger.dart';
import 'package:farmcom/features/auth/data/repositories/auth_repository.dart';

import '../providers/auth_provider.dart';
import 'widgets/phone_input_widget.dart';

❌ Avoid

import 'package:farmcom/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'widgets/phone_input_widget.dart';
import 'package:riverpod/riverpod.dart';
import '../providers/auth_provider.dart';
import 'package:farmcom/core/utils/logger.dart';
```

**Import Order:**
1. Dart imports (`dart:`)
2. Flutter imports (`package:flutter/`)
3. Third-party imports (`package:`)
4. Project imports (`package:farmcom/`)
5. Relative imports (`../`, `./`)

---

## Feature Development

### Step-by-Step Process

#### 1. Create Domain Layer

```bash
# Create directories
mkdir -p lib/features/marketplace/domain/{entities,repositories,usecases}
```

**`domain/entities/marketplace_listing.dart`**
```dart
/// Represents a product listing in the marketplace.
/// 
/// Pure domain object with no external dependencies.
class MarketplaceListing {
  final String id;
  final String title;
  final String description;
  final double price;
  final String farmerId;
  final DateTime createdAt;

  const MarketplaceListing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.farmerId,
    required this.createdAt,
  });
}
```

**`domain/repositories/imarketplace_repository.dart`**
```dart
/// Contract for marketplace data operations.
/// 
/// Implementation provided by data layer.
abstract class IMarketplaceRepository {
  Future<List<MarketplaceListing>> getListings({
    required String cropType,
    required int limit,
  });
  
  Future<void> createListing(MarketplaceListing listing);
}
```

#### 2. Create Data Layer

```bash
mkdir -p lib/features/marketplace/data/{datasources,models,repositories}
```

**`data/datasources/remote_marketplace_datasource.dart`**
```dart
abstract class IMarketplaceRemoteDataSource {
  Future<List<MarketplaceListingModel>> getListings({
    required String cropType,
    required int limit,
  });
}

class MarketplaceRemoteDataSource implements IMarketplaceRemoteDataSource {
  final SupabaseClient _supabase;

  MarketplaceRemoteDataSource(this._supabase);

  @override
  Future<List<MarketplaceListingModel>> getListings({
    required String cropType,
    required int limit,
  }) async {
    final response = await _supabase
        .from('marketplace_listings')
        .select()
        .eq('crop_type', cropType)
        .limit(limit)
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((item) => MarketplaceListingModel.fromJson(item))
        .toList();
  }
}
```

**`data/models/marketplace_listing_model.dart`**
```dart
class MarketplaceListingModel extends MarketplaceListing {
  const MarketplaceListingModel({
    required String id,
    required String title,
    required String description,
    required double price,
    required String farmerId,
    required DateTime createdAt,
  }) : super(
    id: id,
    title: title,
    description: description,
    price: price,
    farmerId: farmerId,
    createdAt: createdAt,
  );

  factory MarketplaceListingModel.fromJson(Map<String, dynamic> json) {
    return MarketplaceListingModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      farmerId: json['farmer_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'price': price,
    'farmer_id': farmerId,
    'created_at': createdAt.toIso8601String(),
  };
}
```

**`data/repositories/marketplace_repository.dart`**
```dart
class MarketplaceRepository implements IMarketplaceRepository {
  final IMarketplaceRemoteDataSource _remote;
  final IMarketplaceLocalDataSource _local;

  MarketplaceRepository(this._remote, this._local);

  @override
  Future<List<MarketplaceListing>> getListings({
    required String cropType,
    required int limit,
  }) async {
    try {
      final listings = await _remote.getListings(
        cropType: cropType,
        limit: limit,
      );
      await _local.cacheListings(listings);
      return listings;
    } catch (e) {
      return await _local.getListings(cropType: cropType);
    }
  }

  @override
  Future<void> createListing(MarketplaceListing listing) async {
    await _local.createListing(listing);
    await _local.markForSync(listing.id, 'pending');
  }
}
```

#### 3. Create Presentation Layer

```bash
mkdir -p lib/features/marketplace/presentation/{providers,pages,widgets}
```

**`presentation/providers/marketplace_provider.dart`**
```dart
final marketplaceProvider = FutureProvider.family<
  List<MarketplaceListing>,
  String
>((ref, cropType) async {
  final repository = ref.watch(marketplaceRepositoryProvider);
  return await repository.getListings(
    cropType: cropType,
    limit: 20,
  );
});
```

**`presentation/pages/marketplace_page.dart`**
```dart
class MarketplacePage extends ConsumerWidget {
  const MarketplacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listings = ref.watch(marketplaceProvider('Maize'));

    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace')),
      body: listings.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ListingCard(
            listing: items[index],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err'),
        ),
      ),
    );
  }
}
```

#### 4. Create Tests

```bash
mkdir -p test/features/marketplace/{domain,data,presentation}
```

**`test/features/marketplace/domain/repositories_test.dart`**
```dart
void main() {
  group('MarketplaceRepository', () {
    late MarketplaceRepository repository;
    late MockRemoteDataSource mockRemote;
    late MockLocalDataSource mockLocal;

    setUp(() {
      mockRemote = MockRemoteDataSource();
      mockLocal = MockLocalDataSource();
      repository = MarketplaceRepository(mockRemote, mockLocal);
    });

    test('returns listings from remote when online', () async {
      // Arrange
      final mockListings = [mockListing];
      when(mockRemote.getListings(
        cropType: anyNamed('cropType'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => mockListings);

      // Act
      final result = await repository.getListings(
        cropType: 'Maize',
        limit: 20,
      );

      // Assert
      expect(result, mockListings);
      verify(mockLocal.cacheListings(mockListings)).called(1);
    });

    test('returns cached listings when offline', () async {
      // Arrange
      final cachedListings = [mockListing];
      when(mockRemote.getListings(
        cropType: anyNamed('cropType'),
        limit: anyNamed('limit'),
      )).thenThrow(NetworkException('No internet'));
      when(mockLocal.getListings(cropType: 'Maize'))
          .thenAnswer((_) async => cachedListings);

      // Act
      final result = await repository.getListings(
        cropType: 'Maize',
        limit: 20,
      );

      // Assert
      expect(result, cachedListings);
    });
  });
}
```

#### 5. Register with Router

**`core/routing/router_provider.dart`**
```dart
GoRoute(
  path: '/marketplace',
  name: 'marketplace',
  builder: (context, state) => const MarketplacePage(),
),
```

#### 6. Update Documentation

Add to `ARCHITECTURE.md`:
```markdown
#### **Feature: `marketplace/`** 
Farmer-to-buyer direct marketplace listings.

**Domain:** MarketplaceListing entity, IMarketplaceRepository interface
**Data:** Remote (Supabase) and local (Isar) datasources
**Presentation:** Listing cards, marketplace home page, filters
```

---

## Testing

### Write Tests for All Changes

```bash
# Create test file
test/features/marketplace/data/repositories/marketplace_repository_test.dart
```

### Test Requirements

1. **Unit Tests** for all business logic (domain usecases)
2. **Repository Tests** with mocked datasources
3. **Widget Tests** for UI components
4. **Coverage** target: ≥70% for new code

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/marketplace/data/repositories/marketplace_repository_test.dart

# Run with coverage
flutter test --coverage

# View coverage report
coverage/index.html
```

### Mocking Pattern

```dart
// Use mockito for mocking
class MockMarketplaceRepository extends Mock 
    implements IMarketplaceRepository {}

class MockListingModel extends Mock 
    implements MarketplaceListingModel {}

// In test
setUp(() {
  mockRepository = MockMarketplaceRepository();
  mockListing = MockListingModel();
});

// Mock responses
when(mockRepository.getListings(
  cropType: anyNamed('cropType'),
  limit: anyNamed('limit'),
)).thenAnswer((_) async => [mockListing]);
```

---

## Commit & Push

### Before Committing

```bash
# 1. Format code
dart format lib/

# 2. Analyze
flutter analyze
# Must have 0 errors

# 3. Run tests
flutter test
# All tests must pass

# 4. Manual testing
flutter run
# Test your changes thoroughly
```

### Commit Guidelines

```bash
# Commit with clear message following format:
git add .
git commit -m "feat: add marketplace listing page

- Implements marketplace feature with Isar caching
- Adds remote/local datasource abstraction
- Includes unit tests for repository
- Adds integration with router

Fixes #123
Closes #456"
```

**Commit Message Format:**

```
<type>: <subject>

<body>

<footer>
```

**Type:**
- `feat` — New feature
- `fix` — Bug fix
- `docs` — Documentation changes
- `refactor` — Code refactoring (no behavior change)
- `test` — Test additions
- `chore` — Build/dependency updates

**Subject:**
- Imperative mood ("add" not "added" or "adds")
- No period at end
- Maximum 50 characters

**Body:**
- Explain what and why, not how
- Wrap at 72 characters
- Separate from subject with blank line

**Footer:**
- Reference related issues: `Fixes #123`
- Breaking changes: `BREAKING CHANGE: description`

### Push to Fork

```bash
# Push to your fork
git push origin feature/your-feature-name

# If upstream was updated:
git fetch upstream
git rebase upstream/main
git push origin feature/your-feature-name --force
```

---

## Pull Request Process

### Before Creating PR

- [ ] Branch is up to date with `upstream/main`
- [ ] All tests pass (`flutter test`)
- [ ] No linting errors (`flutter analyze`)
- [ ] Code is formatted (`dart format lib/`)
- [ ] Commits are clear and descriptive
- [ ] No merge conflicts

### Creating PR

1. **Go to GitHub** and click "New Pull Request"

2. **Select base repository:** `asiimwe-dev/FarmCom` (main branch)

3. **Select your fork** and feature branch

4. **Fill PR template:**

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] New feature
- [ ] Bug fix
- [ ] Documentation update
- [ ] Breaking change

## Related Issues
Closes #123

## Testing
- [ ] Unit tests added
- [ ] Manual testing completed
- [ ] No regressions found

## Checklist
- [ ] Code follows style guidelines
- [ ] No new warnings introduced
- [ ] Tests pass locally
- [ ] Documentation updated
- [ ] Changes are backward compatible
```

### Review Process

- **Code Review:** Maintainers will review your code within 1-2 days
- **Feedback:** Be responsive to feedback and questions
- **Updates:** Push additional commits to address feedback
- **Approval:** Once approved, maintainers will merge

---

## Reporting Issues

### Before Reporting

- [ ] Check existing issues (may be duplicate)
- [ ] Verify issue exists in latest code
- [ ] Test in debug and release builds
- [ ] Check device-specific (Android/iOS/Linux)

### Issue Template

**Title:** Clear, descriptive title

**Description:**
```markdown
## Environment
- Flutter version: (output of `flutter --version`)
- Device: (e.g., Infinix X669, Android 13)
- OS: (Android/iOS/Linux)

## Steps to Reproduce
1. Open app
2. Navigate to [page]
3. Tap [button]
4. Observe issue

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Screenshots/Logs
If applicable, attach screenshots or crash logs

## Severity
- Critical (app crash, data loss)
- High (feature broken)
- Medium (workaround exists)
- Low (cosmetic)
```

### Good Issue Examples

❌ **Bad:** "App crashes"
✅ **Good:** "App crashes when uploading diagnostic image >5MB on Android 12"

❌ **Bad:** "Feature doesn't work"
✅ **Good:** "Community forum posts don't sync after network reconnection; other features sync successfully"

---

## Questions & Support

### Getting Help

1. **Check ARCHITECTURE.md** — Most technical questions answered there
2. **Search existing issues** — Your question may have been asked
3. **Create discussion** — Use GitHub Discussions for questions

### Asking Good Questions

Provide context:
```
Q: How should I structure the new marketplace feature?
I've read ARCHITECTURE.md and understand the feature-first pattern. 
Looking at how community/ is structured, would marketplace/ follow 
the same domain/data/presentation layers?
```

Rather than:
```
Q: How do I add a new feature?
```

---

## Development Tips

### Performance Profiling

```bash
# Run with performance profiling
flutter run --profile

# Use DevTools for analysis
# Open: http://localhost:9100 (shown in terminal)
```

### Hot Reload

```bash
# While running flutter run:
# r - Hot reload
# R - Full restart
# q - Quit

# Note: Hot reload doesn't work for:
# - Top-level variables
# - Riverpod provider definitions
# Use R for those
```

### Debugging

```bash
# Add logging in code
import 'package:farmcom/core/utils/logger.dart';

logger.i('Info message');
logger.w('Warning message');
logger.e('Error message: $error');

# View logs in terminal/DevTools
```

### Testing Offline Behavior

```dart
// In Android Studio:
// Emulator > ... > Settings > Netspeed > Offline

// Or via adb:
adb shell setprop net.change 1
```

---

## Releases & Versioning

FarmCom follows [Semantic Versioning](https://semver.org/):

- **MAJOR** — Breaking changes
- **MINOR** — New features (backward compatible)
- **PATCH** — Bug fixes

Example: `v1.2.3` (Major.Minor.Patch)

---

## License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

---

## Recognition

All contributors will be recognized in:
- GitHub commit history
- CHANGELOG.md (for significant contributions)
- Project README.md (maintainers section, if applicable)

---

## Additional Resources

- [Effective Dart](https://dart.dev/guides/language/effective-dart) — Style guide
- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev/docs)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Domain-Driven Design](https://en.wikipedia.org/wiki/Domain-driven_design)

---

**Questions?** Create an issue or start a discussion. We're here to help! 🚀

**Last Updated:** April 2026  
**Maintained By:** FarmCom Development Team
