import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:veto_app/core/config/supabase_config.dart';
import 'package:veto_app/shared/models/group.dart';
import 'package:veto_app/shared/models/group_member.dart';

class GroupRepository {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // Создать новую группу
  Future<Group> createGroup({
    required String name,
    required String userId,
  }) async {
    try {
      // Создаем группу
      final groupData = {
        'name': name,
        'created_by': userId,
        'created_at': DateTime.now().toIso8601String(),
      };

      final groupResponse = await _supabase
          .from('groups')
          .insert(groupData)
          .select()
          .single();

      final group = Group.fromJson(groupResponse);

      // Автоматически добавляем создателя как owner
      await _supabase.from('group_members').insert({
        'group_id': group.id,
        'user_id': userId,
        'role': 'owner',
        'joined_at': DateTime.now().toIso8601String(),
      });

      return group;
    } catch (e) {
      throw Exception('Ошибка создания группы: $e');
    }
  }

  // Присоединиться к группе по ID
  Future<void> joinGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      // Проверяем, существует ли группа
      final groupExists = await _supabase
          .from('groups')
          .select('id')
          .eq('id', groupId)
          .maybeSingle();

      if (groupExists == null) {
        throw Exception('Группа не найдена');
      }

      // Проверяем, не является ли пользователь уже участником
      final alreadyMember = await _supabase
          .from('group_members')
          .select('user_id')
          .eq('group_id', groupId)
          .eq('user_id', userId)
          .maybeSingle();

      if (alreadyMember != null) {
        throw Exception('Вы уже в этой группе');
      }

      // Добавляем пользователя в группу
      await _supabase.from('group_members').insert({
        'group_id': groupId,
        'user_id': userId,
        'role': 'member',
        'joined_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Ошибка входа в группу: $e');
    }
  }

  // Получить группу по ID
  Future<Group> getGroup(String groupId) async {
    try {
      final response = await _supabase
          .from('groups')
          .select()
          .eq('id', groupId)
          .single();

      return Group.fromJson(response);
    } catch (e) {
      throw Exception('Ошибка получения группы: $e');
    }
  }

  // Получить все группы пользователя
  Future<List<Group>> getUserGroups(String userId) async {
    try {
      final response = await _supabase
          .from('group_members')
          .select('group_id, groups(*)')
          .eq('user_id', userId);

      return (response as List)
          .map((item) => Group.fromJson(item['groups']))
          .toList();
    } catch (e) {
      throw Exception('Ошибка получения групп: $e');
    }
  }

  // Получить участников группы
  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    try {
      final response = await _supabase
          .from('group_members')
          .select()
          .eq('group_id', groupId)
          .order('joined_at', ascending: true);

      return (response as List)
          .map((item) => GroupMember.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Ошибка получения участников: $e');
    }
  }

  // Получить участников с данными пользователей
  Future<List<Map<String, dynamic>>> getGroupMembersWithUsers(
      String groupId) async {
    try {
      final response = await _supabase
          .from('group_members')
          .select('*, users(*)')
          .eq('group_id', groupId)
          .order('joined_at', ascending: true);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      throw Exception('Ошибка получения участников: $e');
    }
  }

  // Покинуть группу
  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      await _supabase
          .from('group_members')
          .delete()
          .eq('group_id', groupId)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Ошибка выхода из группы: $e');
    }
  }

  // Удалить группу (только для owner)
  Future<void> deleteGroup(String groupId) async {
    try {
      await _supabase.from('groups').delete().eq('id', groupId);
    } catch (e) {
      throw Exception('Ошибка удаления группы: $e');
    }
  }

  // Получить информацию об участнике группы
  Future<GroupMember?> getGroupMember({
    required String groupId,
    required String userId,
  }) async {
    try {
      final response = await _supabase
          .from('group_members')
          .select()
          .eq('group_id', groupId)
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      return GroupMember.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}
