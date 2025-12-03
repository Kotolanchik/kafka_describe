#!/bin/bash

# Определение директории, где находится скрипт
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KAFKA_DIR="/opt/kafka/bin"

# Утилиты
KAFKA_TOPICS="$KAFKA_DIR/kafka-topics.sh"
KAFKA_RUN_CLASS="$KAFKA_DIR/kafka-run-class.sh"

if [ "$#" -ne 3 ]; then
    echo "Использование: $0 <bootstrap-server> <zookeeper> <output-file>"
    echo "Пример: $0 172.22.42.228:6667 172.22.42.225:2181 topic_info.txt"
    exit 1
fi

BOOTSTRAP_SERVER=$1
ZOOKEEPER=$2
OUTPUT_FILE=$3

# Проверка, существуют ли утилиты
if [ ! -x "$KAFKA_TOPICS" ] || [ ! -x "$KAFKA_RUN_CLASS" ]; then
    echo "Ошибка: Утилиты Kafka не найдены в $KAFKA_DIR"
    exit 1
fi

echo "=== Количество сообщений в топиках ===" > "$OUTPUT_FILE"
echo >> "$OUTPUT_FILE"

for topic in $($KAFKA_TOPICS --list --zookeeper $ZOOKEEPER); do
    offsets=$($KAFKA_RUN_CLASS kafka.tools.GetOffsetShell --broker-list $BOOTSTRAP_SERVER --topic "$topic" 2>/dev/null | awk -F: '{sum += $3} END {print sum+0}')
    if [ -z "$offsets" ] || [ "$offsets" -eq 0 ]; then
        echo "Топик: $topic -> Нет данных" >> "$OUTPUT_FILE"
    else
        echo "Топик: $topic -> Сообщений: $offsets" >> "$OUTPUT_FILE"
    fi
done

echo >> "$OUTPUT_FILE"
echo "=== Готово ===" >> "$OUTPUT_FILE"

echo "Результаты записаны в: $OUTPUT_FILE"

