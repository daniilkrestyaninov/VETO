-- РАДИКАЛЬНОЕ РЕШЕНИЕ: Пересоздание таблицы group_members
-- ВНИМАНИЕ: Это удалит все данные из таблицы group_members!

-- Удаляем таблицу полностью (это также удалит все политики)
DROP TABLE IF EXISTS group_members CASCADE;

-- Создаем таблицу заново
CREATE TABLE group_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('owner', 'member')),
    veto_tokens INTEGER NOT NULL DEFAULT 3,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(group_id, user_id)
);

-- Создаем индексы для производительности
CREATE INDEX idx_group_members_group_id ON group_members(group_id);
CREATE INDEX idx_group_members_user_id ON group_members(user_id);

-- НЕ включаем RLS (оставляем таблицу открытой для разработки)
-- ALTER TABLE group_members ENABLE ROW LEVEL SECURITY;

-- Если хочешь включить RLS позже, используй эти простые политики:
-- CREATE POLICY "Allow all for authenticated users" ON group_members FOR ALL USING (auth.uid() IS NOT NULL);
