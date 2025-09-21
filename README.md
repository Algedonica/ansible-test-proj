# Ansible: сервер статики

Этот репозиторий реализует тестовое задание: поднять тестовое окружение в Docker (Ubuntu 24.04 + SSH) и развернуть Ansible’ом nginx, который раздаёт изображения по пути `/images`.

## Быстрый старт

1) Запустите тестовое окружение:

```sh
docker compose up -d --build
```

По умолчанию:
- SSH: localhost:2222 (user/pass: devops/devops)
- HTTP: http://localhost:8080

2) Установите зависимости для управления (локально): Ansible 2.15+.

3) Если используете парольную аутентификацию, установите sshpass (для нативного OpenSSH Ansible)

4) Запустите плейбук:

```sh
ansible-playbook playbooks/site.yml -i inventories/dev/hosts.ini
```

По окончании nginx будет доступен на 80 порту контейнера (проброшен на 8080 хоста). Каталог `/images` будет отдавать листинг и файлы.

## Структура

- `Dockerfile`, `docker-compose.yml` — тестовое окружение: Ubuntu 24.04 + openssh-server.
- `ansible.cfg`, `inventories/dev/hosts.ini` — базовая конфигурация и инвентори.
- `playbooks/site.yml` — основной плейбук.
- `roles/` — роли:
	- `common/packages` — обновление системы и утилиты (htop, ncdu, git, nano).
	- `system/users` — пользователи/группы, SSH-ключи, shell, состояния.
	- `system/zsh` — установка zsh и oh-my-zsh только для пользователей с `/bin/zsh`.
	- `system/ssh` — настройка sshd (без root, без пустых паролей, VERBOSE, без X11Forwarding).
	- `web/nginx` — установка и конфигурация nginx, gzip, логи, кэширование 1 час, vhost `/images`.
	- `web/static` — загрузка набора изображений в каталог, из которого nginx отдаёт `/images`.