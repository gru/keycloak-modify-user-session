# Журнал изменений

Все значимые изменения в этом проекте будут документироваться в этом файле.

Формат основан на [Keep a Changelog](https://keepachangelog.com/ru/1.0.0/),
и этот проект придерживается [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2023-22-10

### Добавлено
- Первоначальная настройка проекта с использованием Docker и Keycloak
- Скрипты PowerShell для управления пользователями и токенами
- README с инструкциями по настройке и тестированию
- Файл docker-compose.yml для запуска Keycloak и PostgreSQL
- Скрипт create-test-user.ps1 для создания тестового пользователя
- Скрипт exchange-token.ps1 для проверки работы Token Exchange
- Скрипт update-user-attribute.ps1 для изменения атрибутов пользователя
- Скрипт format-jwt-token.ps1 для форматирования JWT токенов
- Файл README.md с инструкциями по использованию
- Обновлена конфигурация Keycloak для поддержки Token Exchange
