// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionRepositoryHash() => r'bc62a5d272a12a7ca16598ab38ff078bf8e1e656';

/// See also [sessionRepository].
@ProviderFor(sessionRepository)
final sessionRepositoryProvider =
    AutoDisposeProvider<SessionRepository>.internal(
  sessionRepository,
  name: r'sessionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SessionRepositoryRef = AutoDisposeProviderRef<SessionRepository>;
String _$sessionHash() => r'b663c2413bc7207c6a29b5ce6d77d4d32d0940d1';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [session].
@ProviderFor(session)
const sessionProvider = SessionFamily();

/// See also [session].
class SessionFamily extends Family<AsyncValue<models.Session>> {
  /// See also [session].
  const SessionFamily();

  /// See also [session].
  SessionProvider call(
    String sessionId,
  ) {
    return SessionProvider(
      sessionId,
    );
  }

  @override
  SessionProvider getProviderOverride(
    covariant SessionProvider provider,
  ) {
    return call(
      provider.sessionId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sessionProvider';
}

/// See also [session].
class SessionProvider extends AutoDisposeFutureProvider<models.Session> {
  /// See also [session].
  SessionProvider(
    String sessionId,
  ) : this._internal(
          (ref) => session(
            ref as SessionRef,
            sessionId,
          ),
          from: sessionProvider,
          name: r'sessionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionHash,
          dependencies: SessionFamily._dependencies,
          allTransitiveDependencies: SessionFamily._allTransitiveDependencies,
          sessionId: sessionId,
        );

  SessionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionId,
  }) : super.internal();

  final String sessionId;

  @override
  Override overrideWith(
    FutureOr<models.Session> Function(SessionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SessionProvider._internal(
        (ref) => create(ref as SessionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionId: sessionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<models.Session> createElement() {
    return _SessionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionProvider && other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SessionRef on AutoDisposeFutureProviderRef<models.Session> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _SessionProviderElement
    extends AutoDisposeFutureProviderElement<models.Session> with SessionRef {
  _SessionProviderElement(super.provider);

  @override
  String get sessionId => (origin as SessionProvider).sessionId;
}

String _$activeSessionHash() => r'f374dd9b19f30db3ce3e06e89ccf15ef0b06e9cb';

abstract class _$ActiveSession
    extends BuildlessAutoDisposeAsyncNotifier<models.Session?> {
  late final String groupId;

  FutureOr<models.Session?> build(
    String groupId,
  );
}

/// See also [ActiveSession].
@ProviderFor(ActiveSession)
const activeSessionProvider = ActiveSessionFamily();

/// See also [ActiveSession].
class ActiveSessionFamily extends Family<AsyncValue<models.Session?>> {
  /// See also [ActiveSession].
  const ActiveSessionFamily();

  /// See also [ActiveSession].
  ActiveSessionProvider call(
    String groupId,
  ) {
    return ActiveSessionProvider(
      groupId,
    );
  }

  @override
  ActiveSessionProvider getProviderOverride(
    covariant ActiveSessionProvider provider,
  ) {
    return call(
      provider.groupId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'activeSessionProvider';
}

/// See also [ActiveSession].
class ActiveSessionProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ActiveSession, models.Session?> {
  /// See also [ActiveSession].
  ActiveSessionProvider(
    String groupId,
  ) : this._internal(
          () => ActiveSession()..groupId = groupId,
          from: activeSessionProvider,
          name: r'activeSessionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activeSessionHash,
          dependencies: ActiveSessionFamily._dependencies,
          allTransitiveDependencies:
              ActiveSessionFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  ActiveSessionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  FutureOr<models.Session?> runNotifierBuild(
    covariant ActiveSession notifier,
  ) {
    return notifier.build(
      groupId,
    );
  }

  @override
  Override overrideWith(ActiveSession Function() create) {
    return ProviderOverride(
      origin: this,
      override: ActiveSessionProvider._internal(
        () => create()..groupId = groupId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ActiveSession, models.Session?>
      createElement() {
    return _ActiveSessionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveSessionProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ActiveSessionRef on AutoDisposeAsyncNotifierProviderRef<models.Session?> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _ActiveSessionProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ActiveSession,
        models.Session?> with ActiveSessionRef {
  _ActiveSessionProviderElement(super.provider);

  @override
  String get groupId => (origin as ActiveSessionProvider).groupId;
}

String _$sessionOptionsHash() => r'9dd8ba2e2f2edfc9b1dbe1efd78fc0dac0b2c3a1';

abstract class _$SessionOptions
    extends BuildlessAutoDisposeAsyncNotifier<List<Option>> {
  late final String sessionId;

  FutureOr<List<Option>> build(
    String sessionId,
  );
}

/// See also [SessionOptions].
@ProviderFor(SessionOptions)
const sessionOptionsProvider = SessionOptionsFamily();

/// See also [SessionOptions].
class SessionOptionsFamily extends Family<AsyncValue<List<Option>>> {
  /// See also [SessionOptions].
  const SessionOptionsFamily();

  /// See also [SessionOptions].
  SessionOptionsProvider call(
    String sessionId,
  ) {
    return SessionOptionsProvider(
      sessionId,
    );
  }

  @override
  SessionOptionsProvider getProviderOverride(
    covariant SessionOptionsProvider provider,
  ) {
    return call(
      provider.sessionId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sessionOptionsProvider';
}

/// See also [SessionOptions].
class SessionOptionsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<SessionOptions, List<Option>> {
  /// See also [SessionOptions].
  SessionOptionsProvider(
    String sessionId,
  ) : this._internal(
          () => SessionOptions()..sessionId = sessionId,
          from: sessionOptionsProvider,
          name: r'sessionOptionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionOptionsHash,
          dependencies: SessionOptionsFamily._dependencies,
          allTransitiveDependencies:
              SessionOptionsFamily._allTransitiveDependencies,
          sessionId: sessionId,
        );

  SessionOptionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionId,
  }) : super.internal();

  final String sessionId;

  @override
  FutureOr<List<Option>> runNotifierBuild(
    covariant SessionOptions notifier,
  ) {
    return notifier.build(
      sessionId,
    );
  }

  @override
  Override overrideWith(SessionOptions Function() create) {
    return ProviderOverride(
      origin: this,
      override: SessionOptionsProvider._internal(
        () => create()..sessionId = sessionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionId: sessionId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SessionOptions, List<Option>>
      createElement() {
    return _SessionOptionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionOptionsProvider && other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SessionOptionsRef on AutoDisposeAsyncNotifierProviderRef<List<Option>> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _SessionOptionsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SessionOptions,
        List<Option>> with SessionOptionsRef {
  _SessionOptionsProviderElement(super.provider);

  @override
  String get sessionId => (origin as SessionOptionsProvider).sessionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
