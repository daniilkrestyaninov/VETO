# Этап 3 - Завершение настройки

## Что сделано:

✅ AuthRepository - полная реализация аутентификации
✅ GroupRepository - создание и вход в группы
✅ Riverpod провайдеры (auth_provider.dart, group_provider.dart)
✅ UI экрана аутентификации с брутальным дизайном
✅ UI экрана выбора группы (создать/войти)
✅ BrutalTextField виджет
✅ Обновлен роутер с новым маршрутом /group-select

## Необходимые действия для запуска:

### 1. Установите Flutter SDK (если еще не установлен)
Скачайте с https://flutter.dev/docs/get-started/install

### 2. Установите зависимости
```bash
cd veto_app
flutter pub get
```

### 3. Сгенерируйте код для Riverpod
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Эта команда создаст файлы:
- `lib/features/auth/domain/auth_provider.g.dart`
- `lib/features/groups/domain/group_provider.g.dart`

### 4. Настройте Supabase
В файле `lib/core/config/supabase_config.dart` замените:
```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

На ваши реальные значения из Supabase Dashboard → Settings → API

### 5. Запустите приложение
```bash
flutter run
```

## Структура Этапа 3:

```
lib/features/
├── auth/
│   ├── data/
│   │   └── auth_repository.dart          ✅ Работа с Supabase Auth
│   ├── domain/
│   │   └── auth_provider.dart            ✅ Riverpod провайдеры
│   └── presentation/
│       ├── auth_screen.dart              ✅ Экран входа
│       └── widgets/
│           └── brutal_text_field.dart    ✅ Брутальное поле ввода
└── groups/
    ├── data/
    │   └── group_repository.dart         ✅ Работа с группами
    ├── domain/
    │   └── group_provider.dart           ✅ Riverpod провайдеры
    └── presentation/
        ├── group_select_screen.dart      ✅ Создать/войти в группу
        └── group_lobby_screen.dart       ⏳ Следующий этап
```

## Функционал:

### AuthScreen (`/auth`)
- Быстрый старт (анонимный вход с именем пользователя)
- Кнопка входа с email (заглушка)
- Брутальный дизайн с предупреждением

### GroupSelectScreen (`/group-select`)
- Переключатель "Создать" / "Войти"
- Создание новой группы с названием
- Вход в существующую группу по коду (UUID)
- Автоматический переход в лобби после создания/входа

## Следующий этап:

**Этап 4: Real-time Лобби**
- Реализация экрана лобби с real-time обновлениями
- Отображение списка участников
- Добавление вариантов выбора
- Кнопка запуска рулетки
- Supabase Realtime для синхронизации

Готов продолжить, когда выполните команды выше!
