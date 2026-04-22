# МИГРАЦИЯ БД - ОБЯЗАТЕЛЬНО ВЫПОЛНИТЬ!

## Способ 1: Через Supabase Dashboard (РЕКОМЕНДУЕТСЯ)

1. Откройте https://supabase.com/dashboard
2. Войдите в проект (kbnmctxdxdjqjrplcdjp)
3. Перейдите в **SQL Editor** (левое меню)
4. Нажмите **New Query**
5. Скопируйте и вставьте SQL из файла `migration_add_selected_option.sql`
6. Нажмите **RUN** или **Ctrl+Enter**
7. Убедитесь, что выполнение прошло успешно (зеленая галочка)

## Способ 2: Через Table Editor (альтернатива)

### Для таблицы sessions:
1. Откройте **Table Editor** -> **sessions**
2. Нажмите **+ Add Column**
3. Заполните:
   - Name: `selected_option_id`
   - Type: `uuid`
   - Foreign Key: `options.id`
   - On Delete: `SET NULL`
   - Nullable: ✓ (да)
4. Сохраните

### Для таблицы veto_logs:
1. Откройте **Table Editor** -> **veto_logs**
2. Нажмите **+ Add Column**
3. Заполните:
   - Name: `vetoed_option_id`
   - Type: `uuid`
   - Foreign Key: `options.id`
   - On Delete: `SET NULL`
   - Nullable: ✓ (да)
4. Сохраните

## Проверка

После выполнения миграции проверьте:
- В таблице `sessions` появилось поле `selected_option_id`
- В таблице `veto_logs` появилось поле `vetoed_option_id`

## Что это дает?

✅ Рулетка выбирает результат один раз на сервере
✅ Все устройства видят одинаковый результат
✅ Вето корректно сохраняет информацию об отклоненном варианте
✅ Полная синхронизация между всеми участниками

---

**ВАЖНО:** Без этой миграции приложение не будет работать корректно!
