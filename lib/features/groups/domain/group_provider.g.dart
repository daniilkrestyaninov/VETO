// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$groupRepositoryHash() => r'bf89d04afc9d50fcdfdf3038118e1133413496eb';

/// See also [groupRepository].
@ProviderFor(groupRepository)
final groupRepositoryProvider = AutoDisposeProvider<GroupRepository>.internal(
  groupRepository,
  name: r'groupRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$groupRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GroupRepositoryRef = AutoDisposeProviderRef<GroupRepository>;
String _$createGroupHash() => r'50c97ac07f88ccc310fa43713b32d5abc4e8fdf1';

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

/// See also [createGroup].
@ProviderFor(createGroup)
const createGroupProvider = CreateGroupFamily();

/// See also [createGroup].
class CreateGroupFamily extends Family<AsyncValue<Group>> {
  /// See also [createGroup].
  const CreateGroupFamily();

  /// See also [createGroup].
  CreateGroupProvider call({
    required String groupName,
    required String userId,
  }) {
    return CreateGroupProvider(
      groupName: groupName,
      userId: userId,
    );
  }

  @override
  CreateGroupProvider getProviderOverride(
    covariant CreateGroupProvider provider,
  ) {
    return call(
      groupName: provider.groupName,
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
  String? get name => r'createGroupProvider';
}

/// See also [createGroup].
class CreateGroupProvider extends AutoDisposeFutureProvider<Group> {
  /// See also [createGroup].
  CreateGroupProvider({
    required String groupName,
    required String userId,
  }) : this._internal(
          (ref) => createGroup(
            ref as CreateGroupRef,
            groupName: groupName,
            userId: userId,
          ),
          from: createGroupProvider,
          name: r'createGroupProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createGroupHash,
          dependencies: CreateGroupFamily._dependencies,
          allTransitiveDependencies:
              CreateGroupFamily._allTransitiveDependencies,
          groupName: groupName,
          userId: userId,
        );

  CreateGroupProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupName,
    required this.userId,
  }) : super.internal();

  final String groupName;
  final String userId;

  @override
  Override overrideWith(
    FutureOr<Group> Function(CreateGroupRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateGroupProvider._internal(
        (ref) => create(ref as CreateGroupRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupName: groupName,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Group> createElement() {
    return _CreateGroupProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateGroupProvider &&
        other.groupName == groupName &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupName.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateGroupRef on AutoDisposeFutureProviderRef<Group> {
  /// The parameter `groupName` of this provider.
  String get groupName;

  /// The parameter `userId` of this provider.
  String get userId;
}

class _CreateGroupProviderElement
    extends AutoDisposeFutureProviderElement<Group> with CreateGroupRef {
  _CreateGroupProviderElement(super.provider);

  @override
  String get groupName => (origin as CreateGroupProvider).groupName;
  @override
  String get userId => (origin as CreateGroupProvider).userId;
}

String _$joinGroupHash() => r'850158e79f0b0aa794f9cb9da311ddd5517fed40';

/// See also [joinGroup].
@ProviderFor(joinGroup)
const joinGroupProvider = JoinGroupFamily();

/// See also [joinGroup].
class JoinGroupFamily extends Family<AsyncValue<void>> {
  /// See also [joinGroup].
  const JoinGroupFamily();

  /// See also [joinGroup].
  JoinGroupProvider call({
    required String groupId,
    required String userId,
  }) {
    return JoinGroupProvider(
      groupId: groupId,
      userId: userId,
    );
  }

  @override
  JoinGroupProvider getProviderOverride(
    covariant JoinGroupProvider provider,
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
  String? get name => r'joinGroupProvider';
}

/// See also [joinGroup].
class JoinGroupProvider extends AutoDisposeFutureProvider<void> {
  /// See also [joinGroup].
  JoinGroupProvider({
    required String groupId,
    required String userId,
  }) : this._internal(
          (ref) => joinGroup(
            ref as JoinGroupRef,
            groupId: groupId,
            userId: userId,
          ),
          from: joinGroupProvider,
          name: r'joinGroupProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$joinGroupHash,
          dependencies: JoinGroupFamily._dependencies,
          allTransitiveDependencies: JoinGroupFamily._allTransitiveDependencies,
          groupId: groupId,
          userId: userId,
        );

  JoinGroupProvider._internal(
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
    FutureOr<void> Function(JoinGroupRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JoinGroupProvider._internal(
        (ref) => create(ref as JoinGroupRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _JoinGroupProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JoinGroupProvider &&
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
mixin JoinGroupRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `groupId` of this provider.
  String get groupId;

  /// The parameter `userId` of this provider.
  String get userId;
}

class _JoinGroupProviderElement extends AutoDisposeFutureProviderElement<void>
    with JoinGroupRef {
  _JoinGroupProviderElement(super.provider);

  @override
  String get groupId => (origin as JoinGroupProvider).groupId;
  @override
  String get userId => (origin as JoinGroupProvider).userId;
}

String _$groupHash() => r'32b24d5d50a130bdfd76bbd98429e620146ddd3d';

/// See also [group].
@ProviderFor(group)
const groupProvider = GroupFamily();

/// See also [group].
class GroupFamily extends Family<AsyncValue<Group>> {
  /// See also [group].
  const GroupFamily();

  /// See also [group].
  GroupProvider call(
    String groupId,
  ) {
    return GroupProvider(
      groupId,
    );
  }

  @override
  GroupProvider getProviderOverride(
    covariant GroupProvider provider,
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
  String? get name => r'groupProvider';
}

/// See also [group].
class GroupProvider extends AutoDisposeFutureProvider<Group> {
  /// See also [group].
  GroupProvider(
    String groupId,
  ) : this._internal(
          (ref) => group(
            ref as GroupRef,
            groupId,
          ),
          from: groupProvider,
          name: r'groupProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupHash,
          dependencies: GroupFamily._dependencies,
          allTransitiveDependencies: GroupFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  GroupProvider._internal(
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
  Override overrideWith(
    FutureOr<Group> Function(GroupRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupProvider._internal(
        (ref) => create(ref as GroupRef),
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
  AutoDisposeFutureProviderElement<Group> createElement() {
    return _GroupProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupProvider && other.groupId == groupId;
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
mixin GroupRef on AutoDisposeFutureProviderRef<Group> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GroupProviderElement extends AutoDisposeFutureProviderElement<Group>
    with GroupRef {
  _GroupProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupProvider).groupId;
}

String _$groupMembersHash() => r'4988df9a2b6d49b62555a21ee6f2c900dddf5339';

/// See also [groupMembers].
@ProviderFor(groupMembers)
const groupMembersProvider = GroupMembersFamily();

/// See also [groupMembers].
class GroupMembersFamily extends Family<AsyncValue<List<GroupMember>>> {
  /// See also [groupMembers].
  const GroupMembersFamily();

  /// See also [groupMembers].
  GroupMembersProvider call(
    String groupId,
  ) {
    return GroupMembersProvider(
      groupId,
    );
  }

  @override
  GroupMembersProvider getProviderOverride(
    covariant GroupMembersProvider provider,
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
  String? get name => r'groupMembersProvider';
}

/// See also [groupMembers].
class GroupMembersProvider
    extends AutoDisposeFutureProvider<List<GroupMember>> {
  /// See also [groupMembers].
  GroupMembersProvider(
    String groupId,
  ) : this._internal(
          (ref) => groupMembers(
            ref as GroupMembersRef,
            groupId,
          ),
          from: groupMembersProvider,
          name: r'groupMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupMembersHash,
          dependencies: GroupMembersFamily._dependencies,
          allTransitiveDependencies:
              GroupMembersFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  GroupMembersProvider._internal(
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
  Override overrideWith(
    FutureOr<List<GroupMember>> Function(GroupMembersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupMembersProvider._internal(
        (ref) => create(ref as GroupMembersRef),
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
  AutoDisposeFutureProviderElement<List<GroupMember>> createElement() {
    return _GroupMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupMembersProvider && other.groupId == groupId;
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
mixin GroupMembersRef on AutoDisposeFutureProviderRef<List<GroupMember>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GroupMembersProviderElement
    extends AutoDisposeFutureProviderElement<List<GroupMember>>
    with GroupMembersRef {
  _GroupMembersProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupMembersProvider).groupId;
}

String _$groupMembersWithUsersHash() =>
    r'f3a252c24efd3a60d5e660fa379a4b85742055bc';

/// See also [groupMembersWithUsers].
@ProviderFor(groupMembersWithUsers)
const groupMembersWithUsersProvider = GroupMembersWithUsersFamily();

/// See also [groupMembersWithUsers].
class GroupMembersWithUsersFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [groupMembersWithUsers].
  const GroupMembersWithUsersFamily();

  /// See also [groupMembersWithUsers].
  GroupMembersWithUsersProvider call(
    String groupId,
  ) {
    return GroupMembersWithUsersProvider(
      groupId,
    );
  }

  @override
  GroupMembersWithUsersProvider getProviderOverride(
    covariant GroupMembersWithUsersProvider provider,
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
  String? get name => r'groupMembersWithUsersProvider';
}

/// See also [groupMembersWithUsers].
class GroupMembersWithUsersProvider
    extends AutoDisposeStreamProvider<List<Map<String, dynamic>>> {
  /// See also [groupMembersWithUsers].
  GroupMembersWithUsersProvider(
    String groupId,
  ) : this._internal(
          (ref) => groupMembersWithUsers(
            ref as GroupMembersWithUsersRef,
            groupId,
          ),
          from: groupMembersWithUsersProvider,
          name: r'groupMembersWithUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupMembersWithUsersHash,
          dependencies: GroupMembersWithUsersFamily._dependencies,
          allTransitiveDependencies:
              GroupMembersWithUsersFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  GroupMembersWithUsersProvider._internal(
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
  Override overrideWith(
    Stream<List<Map<String, dynamic>>> Function(
            GroupMembersWithUsersRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupMembersWithUsersProvider._internal(
        (ref) => create(ref as GroupMembersWithUsersRef),
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
  AutoDisposeStreamProviderElement<List<Map<String, dynamic>>> createElement() {
    return _GroupMembersWithUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupMembersWithUsersProvider && other.groupId == groupId;
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
mixin GroupMembersWithUsersRef
    on AutoDisposeStreamProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GroupMembersWithUsersProviderElement
    extends AutoDisposeStreamProviderElement<List<Map<String, dynamic>>>
    with GroupMembersWithUsersRef {
  _GroupMembersWithUsersProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupMembersWithUsersProvider).groupId;
}

String _$groupMemberHash() => r'e846d25b76ee3b2b05478c839d2d0c270e019d61';

/// See also [groupMember].
@ProviderFor(groupMember)
const groupMemberProvider = GroupMemberFamily();

/// See also [groupMember].
class GroupMemberFamily extends Family<AsyncValue<GroupMember?>> {
  /// See also [groupMember].
  const GroupMemberFamily();

  /// See also [groupMember].
  GroupMemberProvider call({
    required String groupId,
    required String userId,
  }) {
    return GroupMemberProvider(
      groupId: groupId,
      userId: userId,
    );
  }

  @override
  GroupMemberProvider getProviderOverride(
    covariant GroupMemberProvider provider,
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
  String? get name => r'groupMemberProvider';
}

/// See also [groupMember].
class GroupMemberProvider extends AutoDisposeFutureProvider<GroupMember?> {
  /// See also [groupMember].
  GroupMemberProvider({
    required String groupId,
    required String userId,
  }) : this._internal(
          (ref) => groupMember(
            ref as GroupMemberRef,
            groupId: groupId,
            userId: userId,
          ),
          from: groupMemberProvider,
          name: r'groupMemberProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$groupMemberHash,
          dependencies: GroupMemberFamily._dependencies,
          allTransitiveDependencies:
              GroupMemberFamily._allTransitiveDependencies,
          groupId: groupId,
          userId: userId,
        );

  GroupMemberProvider._internal(
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
    FutureOr<GroupMember?> Function(GroupMemberRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupMemberProvider._internal(
        (ref) => create(ref as GroupMemberRef),
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
  AutoDisposeFutureProviderElement<GroupMember?> createElement() {
    return _GroupMemberProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupMemberProvider &&
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
mixin GroupMemberRef on AutoDisposeFutureProviderRef<GroupMember?> {
  /// The parameter `groupId` of this provider.
  String get groupId;

  /// The parameter `userId` of this provider.
  String get userId;
}

class _GroupMemberProviderElement
    extends AutoDisposeFutureProviderElement<GroupMember?> with GroupMemberRef {
  _GroupMemberProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupMemberProvider).groupId;
  @override
  String get userId => (origin as GroupMemberProvider).userId;
}

String _$userGroupsHash() => r'87cfbcd170e2730de740e4815b867cd291ad91a1';

abstract class _$UserGroups
    extends BuildlessAutoDisposeAsyncNotifier<List<Group>> {
  late final String userId;

  FutureOr<List<Group>> build(
    String userId,
  );
}

/// See also [UserGroups].
@ProviderFor(UserGroups)
const userGroupsProvider = UserGroupsFamily();

/// See also [UserGroups].
class UserGroupsFamily extends Family<AsyncValue<List<Group>>> {
  /// See also [UserGroups].
  const UserGroupsFamily();

  /// See also [UserGroups].
  UserGroupsProvider call(
    String userId,
  ) {
    return UserGroupsProvider(
      userId,
    );
  }

  @override
  UserGroupsProvider getProviderOverride(
    covariant UserGroupsProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'userGroupsProvider';
}

/// See also [UserGroups].
class UserGroupsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UserGroups, List<Group>> {
  /// See also [UserGroups].
  UserGroupsProvider(
    String userId,
  ) : this._internal(
          () => UserGroups()..userId = userId,
          from: userGroupsProvider,
          name: r'userGroupsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userGroupsHash,
          dependencies: UserGroupsFamily._dependencies,
          allTransitiveDependencies:
              UserGroupsFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserGroupsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  FutureOr<List<Group>> runNotifierBuild(
    covariant UserGroups notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(UserGroups Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserGroupsProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserGroups, List<Group>>
      createElement() {
    return _UserGroupsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserGroupsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserGroupsRef on AutoDisposeAsyncNotifierProviderRef<List<Group>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserGroupsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserGroups, List<Group>>
    with UserGroupsRef {
  _UserGroupsProviderElement(super.provider);

  @override
  String get userId => (origin as UserGroupsProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
