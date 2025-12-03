Набор bash-скриптов для мониторинга Apache Kafka:

- Получение количества сообщений в топиках (get_count_topic_msg.sh)
- Проверка лагов consumer group'ов (get_consumer_lag.sh)

Перед вызовом необходимо сделать скрипты исполняемыми :
- chmod +x get_count_topic_msg.sh
- chmod +x get_consumer_lag.sh

Вызов скрипта локально get_count_topic_msg.sh:

``` bash
ssh user@remote-server 'bash -s' < get_count_topic_msg.sh 'bootstrap-list' 'zookeeper-list' /dev/stdout > info_topic.txt
```

Вызов скрипта локально get_consumer_lag.sh:
``` bash
ssh user@remote-server 'bash -s' < get_consumer_lag.sh 'bootstrap-list' /dev/stdout > info_lag.txt
```

1. bootstrap-server-list — список брокеров: ```'host1:port1,host2:port2,host3:port3'```
2. zookeeper-list — список Zookeeper'ов: ```'zk1:port,zk2:port,zk3:port'```
3. output-file — имя файла, в который будет записан результат


