-- Миграция: Добавление полей для серверной логики рулетки
-- Дата: 2026-04-21
-- Описание: Добавляем selected_option_id в sessions и vetoed_option_id в veto_logs

BEGIN;

-- 1. Добавляем поле selected_option_id в таблицу sessions
ALTER TABLE sessions 
ADD COLUMN IF NOT EXISTS selected_option_id UUID REFERENCES options(id) ON DELETE SET NULL;

-- 2. Добавляем поле vetoed_option_id в таблицу veto_logs
ALTER TABLE veto_logs 
ADD COLUMN IF NOT EXISTS vetoed_option_id UUID REFERENCES options(id) ON DELETE SET NULL;

-- 3. Комментарии для документации
COMMENT ON COLUMN sessions.selected_option_id IS 'ID выбранного варианта при статусе spinning (выбирается на сервере один раз)';
COMMENT ON COLUMN veto_logs.vetoed_option_id IS 'ID варианта, который был отклонен через вето';

COMMIT;
