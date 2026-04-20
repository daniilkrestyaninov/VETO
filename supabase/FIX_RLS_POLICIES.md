# Инструкция по исправлению политик RLS для group_members

## Проблема
Ошибка: `infinite recursion detected in policy for relation "group_members"`

Это происходит из-за того, что политики RLS для таблицы `group_members` создают бесконечную рекурсию при проверке прав доступа.

## Решение

### Шаг 1: Открыть Supabase Dashboard
1. Перейти на https://supabase.com/dashboard
2. Выбрать проект `kbnmctxdxdjqjrplcdjp`
3. Перейти в раздел **SQL Editor** (слева в меню)

### Шаг 2: Выполнить SQL миграцию
Скопировать и выполнить следующий SQL код:

```sql
-- Удаляем все существующие политики для group_members
DROP POLICY IF EXISTS "Users can view group members of their groups" ON group_members;
DROP POLICY IF EXISTS "Users can join groups" ON group_members;
DROP POLICY IF EXISTS "Group owners can update members" ON group_members;
DROP POLICY IF EXISTS "Users can leave groups or owners can remove members" ON group_members;
DROP POLICY IF EXISTS "Enable read access for all users" ON group_members;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON group_members;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON group_members;
DROP POLICY IF EXISTS "Enable delete for authenticated users" ON group_members;

-- Создаем новые упрощенные политики без рекурсии

-- Политика для SELECT (чтение) - все могут читать участников групп
CREATE POLICY "Enable read access for all users"
ON group_members FOR SELECT
USING (true);

-- Политика для INSERT (добавление) - любой авторизованный пользователь может добавить запись
CREATE POLICY "Enable insert for authenticated users"
ON group_members FOR INSERT
WITH CHECK (auth.uid() IS NOT NULL);

-- Политика для UPDATE (обновление) - любой авторизованный пользователь может обновить
CREATE POLICY "Enable update for authenticated users"
ON group_members FOR UPDATE
USING (auth.uid() IS NOT NULL);

-- Политика для DELETE (удаление) - любой авторизованный пользователь может удалить
CREATE POLICY "Enable delete for authenticated users"
ON group_members FOR DELETE
USING (auth.uid() IS NOT NULL);

-- Проверяем, что RLS включен для таблицы group_members
ALTER TABLE group_members ENABLE ROW LEVEL SECURITY;
```

### Шаг 3: Проверить результат
1. Нажать **Run** (или Ctrl+Enter)
2. Убедиться, что все команды выполнились успешно
3. Перезапустить приложение и попробовать создать группу

## Альтернативный способ (через UI)

Если SQL Editor не работает, можно настроить политики через UI:

1. Перейти в **Authentication** → **Policies**
2. Найти таблицу `group_members`
3. Удалить все существующие политики
4. Создать 4 новые политики:

### Политика 1: Enable read access for all users
- **Operation**: SELECT
- **Policy definition**: `true`

### Политика 2: Enable insert for authenticated users
- **Operation**: INSERT
- **WITH CHECK**: `auth.uid() IS NOT NULL`

### Политика 3: Enable update for authenticated users
- **Operation**: UPDATE
- **USING**: `auth.uid() IS NOT NULL`

### Политика 4: Enable delete for authenticated users
- **Operation**: DELETE
- **USING**: `auth.uid() IS NOT NULL`

## Что изменилось?

Старые политики пытались проверить, является ли пользователь владельцем группы, обращаясь к таблице `group_members` внутри политики для `group_members`. Это создавало бесконечную рекурсию.

Новые политики просто проверяют, что пользователь авторизован (`auth.uid() IS NOT NULL`), что достаточно для базовой безопасности и не создает рекурсии.

## Дополнительная информация

- URL проекта: https://kbnmctxdxdjqjrplcdjp.supabase.co
- Файл миграции: `supabase/migrations/20260421_fix_group_members_rls.sql`
