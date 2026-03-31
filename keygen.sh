#!/bin/bash

# Установка Ansible
set -e

echo "Installing Ansible..."
sudo dnf install -y ansible


# ----------------------------------------------------------------
# Автокопирование SSH ключа на несколько хостов через sshpass для ansible
# ----------------------------------------------------------------

KEY="$HOME/.ssh/id_ed25519"
CONFIG="$HOME/.ssh/config"

HOSTS=(
    "stapp01"
    "stapp02"
    "stapp03"
    "stlb01"
    "stdb01"
    "ststor01"
    "stbkp01"
    "stmail01"
    "jenkins"
)

# --- Проверяем наличие sshpass ---
if ! command -v sshpass &>/dev/null; then
    echo "Установите sshpass"
    exit 1
fi

# --- 1. Создаём ключ, если его нет ---
if [ ! -f "$KEY" ]; then
    echo "Создаём ключ $KEY..."
    ssh-keygen -t ed25519 -f "$KEY" -N ""
else
    echo "Ключ $KEY уже существует"
fi

SSHUSER="ansible"
SSHPASS="ansible"

# --- 2. Цикл по хостам ---
for HOST in "${HOSTS[@]}"; do
    ALIAS="${HOST%%.*}"
     
    echo "=== $ALIAS ($SSHUSER@$HOST) ==="

    # --- Копируем ключ через sshpass ---
    sshpass -p "$SSHPASS" ssh-copy-id -i "$KEY.pub" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$SSHUSER@$HOST"

    if [ $? -ne 0 ]; then
        echo "❌ Ошибка копирования ключа на $HOST"
        echo "Попробуйте вручную: ssh-copy-id -i $KEY.pub $SSHUSER@$HOST"
        continue
    fi

    # --- Добавляем в ~/.ssh/config ---
    if ! grep -q "Host $ALIAS" "$CONFIG"; then
        cat <<EOF >> "$CONFIG"
Host $ALIAS
    HostName $HOST
    User $SSHUSER
    IdentityFile $KEY
    IdentitiesOnly yes
    StrictHostKeyChecking accept-new
EOF
    fi

    echo "✅ Ключ успешно установлен для $ALIAS"
done

echo "=== Готово! Подключение через алиасы ==="
for ENTRY in "${HOSTS[@]}"; do
    HOST=$(echo "$HOST")
    ALIAS=$(echo "$HOST" | cut -d'.' -f1)
    echo "ssh $ALIAS"
done