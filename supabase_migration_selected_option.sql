-- Добавляем поле selected_option_id в таблицу sessions
-- Это поле хранит ID выбранного варианта во время spinning

ALTER TABLE sessions 
ADD COLUMN IF NOT EXISTS selected_option_id UUID REFERENCES options(id) ON DELETE SET NULL;

-- Добавляем поле vetoed_option_id в таблицу veto_logs
-- Это поле хранит ID варианта, который был отклонен вето

ALTER TABLE veto_logs 
ADD COLUMN IF NOT EXISTS vetoed_option_id UUID REFERENCES options(id) ON DELETE SET NULL;

-- Комментарии для документации
COMMENT ON COLUMN sessions.selected_option_id IS 'ID выбранного варианта при статусе spinning (выбирается на сервере)';
COMMENT ON COLUMN veto_logs.vetoed_option_id IS 'ID варианта, который был отклонен через вето';
