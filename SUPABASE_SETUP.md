# Инструкция по настройке Supabase для проекта Veto

## Шаг 1: Получить Anon Key

1. Откройте браузер и перейдите по ссылке:
   https://supabase.com/dashboard/project/kbnmctxdxdjqjrplcdjp/settings/api

2. Найдите раздел "Project API keys"

3. Скопируйте ключ "anon public" (он начинается с "eyJ...")

4. Откройте файл `veto_app/lib/core/config/supabase_config.dart`

5. Замените `'YOUR_SUPABASE_ANON_KEY'` на скопированный ключ

## Шаг 2: Создать таблицы в базе данных

1. Перейдите в SQL Editor:
   https://supabase.com/dashboard/project/kbnmctxdxdjqjrplcdjp/sql/new

2. Скопируйте содержимое файла `supabase_schema.sql` (находится в корне проекта)

3. Вставьте в SQL Editor и нажмите "Run"

4. Убедитесь, что все таблицы созданы без ошибок

## Шаг 3: Включить Realtime для таблиц

1. Перейдите в Database → Replication:
   https://supabase.com/dashboard/project/kbnmctxdxdjqjrplcdjp/database/replication

2. Включите Realtime для следующих таблиц:
   - ✅ group_members
   - ✅ sessions
   - ✅ options
   - ✅ veto_logs

## Шаг 4: Проверить работу приложения

После выполнения всех шагов:

1. Перезапустите приложение:
   ```bash
   cd veto_app
   flutter run -d FOA
   ```

2. Протестируйте функционал:
   - Введите имя и нажмите "БЫСТРЫЙ СТАРТ"
   - Создайте группу
   - Скопируйте код группы
   - На другом устройстве войдите в группу по коду
   - Добавьте варианты выбора
   - Проверьте, что изменения видны на обоих устройствах в реальном времени
   - Нажмите "ЗАПУСТИТЬ РУЛЕТКУ"

## Текущий статус:

✅ URL проекта настроен: `https://kbnmctxdxdjqjrplcdjp.supabase.co`
⏳ Нужно добавить Anon Key
⏳ Нужно выполнить SQL-скрипт
⏳ Нужно включить Realtime

## Если возникнут проблемы:

1. Проверьте, что Anon Key скопирован полностью (он очень длинный)
2. Убедитесь, что SQL-скрипт выполнился без ошибок
3. Проверьте, что Realtime включен для всех нужных таблиц
4. Посмотрите логи в консоли Flutter на наличие ошибок подключения
