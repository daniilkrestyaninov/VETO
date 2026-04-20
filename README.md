# VETO - Диктатор Решений

Мобильное приложение для коллективного принятия решений с брутальным подходом.

## Технологический стек

- **Frontend**: Flutter (Dart)
- **State Management**: Riverpod
- **Backend & Database**: Supabase (PostgreSQL)
- **Real-time**: Supabase Realtime Channels
- **Routing**: GoRouter
- **UI Style**: Brutalism

## Структура проекта (Clean Architecture)

```
lib/
├── core/
│   ├── config/          # Конфигурация Supabase
│   ├── router/          # GoRouter настройка
│   └── theme/           # Брутальная тема
├── features/
│   ├── auth/            # Аутентификация
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── groups/          # Группы и лобби
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── session/         # Сессии и рулетка
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── veto/            # Логика вето
│       ├── data/
│       ├── domain/
│       └── presentation/
└── shared/
    ├── models/          # Модели данных
    └── widgets/         # Переиспользуемые виджеты
```

## Настройка проекта

### 1. Установка зависимостей

```bash
flutter pub get
```

### 2. Настройка Supabase

1. Создайте проект на [supabase.com](https://supabase.com)
2. Перейдите в SQL Editor и выполните скрипт из `supabase_schema.sql`
3. Скопируйте URL и Anon Key из Settings → API
4. Вставьте их в `lib/core/config/supabase_config.dart`:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

### 3. Генерация кода Riverpod

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Запуск приложения

```bash
flutter run
```

## Этапы разработки

- [x] **Этап 1**: Настройка Supabase и схема БД
- [x] **Этап 2**: Инициализация Flutter-проекта
- [ ] **Этап 3**: Модуль Аутентификации и Главный экран
- [ ] **Этап 4**: Real-time Лобби (State Management)
- [ ] **Этап 5**: Логика «Диктатора» и UI рулетки
- [ ] **Этап 6**: Логика «Вето»

## База данных

### Таблицы:
- `users` - Пользователи
- `groups` - Группы
- `group_members` - Участники групп (с veto_tokens)
- `sessions` - Сессии принятия решений
- `options` - Варианты выбора
- `veto_logs` - История использования вето

### Особенности:
- Row Level Security (RLS) на всех таблицах
- Автоматическая выдача 3 veto-токенов при вступлении в группу
- Автоматическое списание токена при использовании вето
- Real-time синхронизация для лобби и сессий

## Следующие шаги

Готов к **Этапу 3**: Реализация аутентификации и создания/входа в группы.
