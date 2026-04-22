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
String _$sessionOptionsHash() => r'bd87c432e22c7124aa67cd028db363b00598c7c2';

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

/// See also [sessionOptions].
@ProviderFor(sessionOptions)
const sessionOptionsProvider = SessionOptionsFamily();

/// See also [sessionOptions].
class SessionOptionsFamily extends Family<AsyncValue<List<Option>>> {
  /// See also [sessionOptions].
  const SessionOptionsFamily();

  /// See also [sessionOptions].
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

/// See also [sessionOptions].
class SessionOptionsProvider extends AutoDisposeStreamProvider<List<Option>> {
  /// See also [sessionOptions].
  SessionOptionsProvider(
    String sessionId,
  ) : this._internal(
          (ref) => sessionOptions(
            ref as SessionOptionsRef,
            sessionId,
          ),
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
  Override overrideWith(
    Stream<List<Option>> Function(SessionOptionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SessionOptionsProvider._internal(
        (ref) => create(ref as SessionOptionsRef),
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
  AutoDisposeStreamProviderElement<List<Option>> createElement() {
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
mixin SessionOptionsRef on AutoDisposeStreamProviderRef<List<Option>> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _SessionOptionsProviderElement
    extends AutoDisposeStreamProviderElement<List<Option>>
    with SessionOptionsRef {
  _SessionOptionsProviderElement(super.provider);

  @override
  String get sessionId => (origin as SessionOptionsProvider).sessionId;
}

String _$sessionHash() => r'b663c2413bc7207c6a29b5ce6d77d4d32d0940d1';

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

String _$userVetoTokensHash() => r'634e601c7f07fa26af68cccac88619d48914f60b';

/// See also [userVetoTokens].
@ProviderFor(userVetoTokens)
const userVetoTokensProvider = UserVetoTokensFamily();

/// See also [userVetoTokens].
class UserVetoTokensFamily extends Family<AsyncValue<int>> {
  /// See also [userVetoTokens].
  const UserVetoTokensFamily();

  /// See also [userVetoTokens].
  UserVetoTokensProvider call({
    required String groupId,
    required String userId,
  }) {
    return UserVetoTokensProvider(
      groupId: groupId,
      userId: userId,
    );
  }

  @override
  UserVetoTokensProvider getProviderOverride(
    covariant UserVetoTokensProvider provider,
  ) {
    return call(
      groupId: provider.groupId,
      userId: provider.userId,
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
  String? get name => r'userVetoTokensProvider';
}

/// See also [userVetoTokens].
class UserVetoTokensProvider extends AutoDisposeFutureProvider<int> {
  /// See also [userVetoTokens].
  UserVetoTokensProvider({
    required String groupId,
    required String userId,
  }) : this._internal(
          (ref) => userVetoTokens(
            ref as UserVetoTokensRef,
            groupId: groupId,
            userId: userId,
          ),
          from: userVetoTokensProvider,
          name: r'userVetoTokensProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userVetoTokensHash,
          dependencies: UserVetoTokensFamily._dependencies,
          allTransitiveDependencies:
              UserVetoTokensFamily._allTransitiveDependencies,
          groupId: groupId,
          userId: userId,
        );

  UserVetoTokensProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
    required this.userId,
  }) : super.internal();

  final String groupId;
  final String userId;

  @override
  Override overrideWith(
    FutureOr<int> Function(UserVetoTokensRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserVetoTokensProvider._internal(
        (ref) => create(ref as UserVetoTokensRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _UserVetoTokensProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserVetoTokensProvider &&
        other.groupId == groupId &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserVetoTokensRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `groupId` of this provider.
  String get groupId;

  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserVetoTokensProviderElement
    extends AutoDisposeFutureProviderElement<int> with UserVetoTokensRef {
  _UserVetoTokensProviderElement(super.provider);

  @override
  String get groupId => (origin as UserVetoTokensProvider).groupId;
  @override
  String get userId => (origin as UserVetoTokensProvider).userId;
}

String _$activeSessionHash() => r'4d4825a6ace832e5f9f1d46b7942bede5216c6a9';

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

String _$vetoLogsHash() => r'8541c88ccb02d2aeb2542a07316d9f7fcbef4229';

abstract class _$VetoLogs
    extends BuildlessAutoDisposeAsyncNotifier<List<VetoLog>> {
  late final String sessionId;

  FutureOr<List<VetoLog>> build(
    String sessionId,
  );
}

/// See also [VetoLogs].
@ProviderFor(VetoLogs)
const vetoLogsProvider = VetoLogsFamily();

/// See also [VetoLogs].
class VetoLogsFamily extends Family<AsyncValue<List<VetoLog>>> {
  /// See also [VetoLogs].
  const VetoLogsFamily();

  /// See also [VetoLogs].
  VetoLogsProvider call(
    String sessionId,
  ) {
    return VetoLogsProvider(
      sessionId,
    );
  }

  @override
  VetoLogsProvider getProviderOverride(
    covariant VetoLogsProvider provider,
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
  String? get name => r'vetoLogsProvider';
}

/// See also [VetoLogs].
class VetoLogsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<VetoLogs, List<VetoLog>> {
  /// See also [VetoLogs].
  VetoLogsProvider(
    String sessionId,
  ) : this._internal(
          () => VetoLogs()..sessionId = sessionId,
          from: vetoLogsProvider,
          name: r'vetoLogsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$vetoLogsHash,
          dependencies: VetoLogsFamily._dependencies,
          allTransitiveDependencies: VetoLogsFamily._allTransitiveDependencies,
          sessionId: sessionId,
        );

  VetoLogsProvider._internal(
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
  FutureOr<List<VetoLog>> runNotifierBuild(
    covariant VetoLogs notifier,
  ) {
    return notifier.build(
      sessionId,
    );
  }

  @override
  Override overrideWith(VetoLogs Function() create) {
    return ProviderOverride(
      origin: this,
      override: VetoLogsProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<VetoLogs, List<VetoLog>>
      createElement() {
    return _VetoLogsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VetoLogsProvider && other.sessionId == sessionId;
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
mixin VetoLogsRef on AutoDisposeAsyncNotifierProviderRef<List<VetoLog>> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _VetoLogsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VetoLogs, List<VetoLog>>
    with VetoLogsRef {
  _VetoLogsProviderElement(super.provider);

  @override
  String get sessionId => (origin as VetoLogsProvider).sessionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
