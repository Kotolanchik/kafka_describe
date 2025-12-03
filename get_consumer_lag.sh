#!/bin/bash

# Определение директории, где находится скрипт
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KAFKA_DIR="/opt/kafka/bin"

# Утилиты
KAFKA_CONSUMER_GROUPS="$KAFKA_DIR/kafka-consumer-groups.sh"

if [ "$#" -ne 2 ]; then
    echo "Использование: $0 <bootstrap-server> <output-file>"
    echo "Пример: $0 172.22.42.228:6667 lag_info.txt"
    exit 1
fi

BOOTSTRAP_SERVER=$1
OUTPUT_FILE=$2

# Проверка, существуют ли утилиты
if [ ! -x "$KAFKA_CONSUMER_GROUPS" ]; then
    echo "Ошибка: kafka-consumer-groups.sh не найден в $KAFKA_DIR"
    exit 1
fi

echo "=== Лаги по Consumer Groups ===" > "$OUTPUT_FILE"
echo >> "$OUTPUT_FILE"

for group in $($KAFKA_CONSUMER_GROUPS --list --bootstrap-server $BOOTSTRAP_SERVER); do
    echo "--- Группа: $group ---" >> "$OUTPUT_FILE"
    $KAFKA_CONSUMER_GROUPS --describe --group "$group" --bootstrap-server $BOOTSTRAP_SERVER 2>/dev/null >> "$OUTPUT_FILE" || echo "Ошибка при описании группы: $group" >> "$OUTPUT_FILE"
    echo >> "$OUTPUT_FILE"
done

echo "=== Готово ===" >> "$OUTPUT_FILE"

echo "Результаты записаны в: $OUTPUT_FILE"
