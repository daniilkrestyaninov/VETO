import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:veto_app/features/groups/data/group_repository.dart';
import 'package:veto_app/shared/models/group.dart';
import 'package:veto_app/shared/models/group_member.dart';

part 'group_provider.g.dart';

// Провайдер репозитория
@riverpod
GroupRepository groupRepository(GroupRepositoryRef ref) {
  return GroupRepository();
}

// Простой провайдер для создания группы (без состояния)
@riverpod
Future<Group> createGroup(
  CreateGroupRef ref, {
  required String groupName,
  required String userId,
}) async {
  final repo = ref.watch(groupRepositoryProvider);
  return await repo.createGroup(name: groupName, userId: userId);
}

// Простой провайдер для входа в группу (без состояния)
@riverpod
Future<void> joinGroup(
  JoinGroupRef ref, {
  required String groupId,
  required String userId,
}) async {
  final repo = ref.watch(groupRepositoryProvider);
  await repo.joinGroup(groupId: groupId, userId: userId);
}

// Провайдер списка групп пользователя
@riverpod
class UserGroups extends _$UserGroups {
  @override
  Future<List<Group>> build(String userId) async {
    final repo = ref.watch(groupRepositoryProvider);
    return await repo.getUserGroups(userId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(groupRepositoryProvider);
      return await repo.getUserGroups(userId);
    });
  }
}

// Провайдер конкретной группы
@riverpod
Future<Group> group(GroupRef ref, String groupId) async {
  final repo = ref.watch(groupRepositoryProvider);
  return await repo.getGroup(groupId);
}

// Провайдер участников группы
@riverpod
Future<List<GroupMember>> groupMembers(
    GroupMembersRef ref, String groupId) async {
  final repo = ref.watch(groupRepositoryProvider);
  return await repo.getGroupMembers(groupId);
}

// Провайдер участников с данными пользователей с Stream
@riverpod
Stream<List<Map<String, dynamic>>> groupMembersWithUsers(
  GroupMembersWithUsersRef ref,
  String groupId,
) {
  final repo = ref.watch(groupRepositoryProvider);
  return repo.streamGroupMembersWithUsers(groupId);
}

// Провайдер информации об участнике
@riverpod
Future<GroupMember?> groupMember(
  GroupMemberRef ref, {
  required String groupId,
  required String userId,
}) async {
  final repo = ref.watch(groupRepositoryProvider);
  return await repo.getGroupMember(groupId: groupId, userId: userId);
}
