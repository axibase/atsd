# Установка

Ознакомьтесь с [требованиями](../requirements.md) к операционной системе и аппаратному обеспечению.

При возникновении вопросов обращайтесь в службу поддержки `support-atsd@axibase.com`.

## Установка Java

Установите Java 8 для ATSD согласно [инструкции](../../administration/migration/install-java-8.md).

Установите Java 16 (при установке MOEX консьюмеров на данном сервере) через менеджер пакетов.

```sh
sudo apt install zip unzip # Архиватор необходим для установки SDKMAN
curl -s "https://get.sdkman.io" | bash
sdk install java 16.0.1-librca
```

## Установка ATSD

Загрузите установочные файлы.

```bash
curl -O https://www.axibase.com/public/atsd.moex.latest.tar.gz
tar -xozf atsd.moex.latest.tar.gz
```

Произведите запуск базы.

```sh
./atsd/bin/atsd-tsd.sh start
```

## Установка консьюмеров

MOEX консьюмеры являются самостоятельными Java-приложениями, выполняющими функцию надежного и высокопроизводительного получения и декодирования FAST сообщений, получаемых от шлюзов FAST Московской биржи.

Загрузите и распакуйте установочные файлы.

```bash
curl -O https://www.axibase.com/public/moex-consumer.tar.gz
tar -xzf moex-consumer.tar.gz -C /opt moex-consumer
```

Присвойте переменной окружения `JAVA_HOME` путь к версии Java, используемой консьюмером.

```sh
sdk use java 16.0.1-librca
```

Запустите установочный скрипт.

```sh
/opt/moex-consumer/scripts/install.sh
```

Параметры `atsd.host`, `atsd.port.tcp`, `atsd.port.udp` позволяют указать ATSD, на которую будут отправлены команды. Данные параметры необходимы в случае распределенной инсталляции.

```bash
systemctl start moex-consumer-asts-fond
systemctl start moex-consumer-asts-fx
systemctl start moex-consumer-spectra
```

Альтернативный способ запуска и остановки консьюмеров – через скрипты `start.sh` и `stop.sh` в каталогах `/opt/moex-consumer/{asts-fx,asts-fond,spectra}/bin`

## Настройка операционной системы

Увеличьте параметр `ulimit` `nofile` до `32768` и выше.

### Оптимизация сетевого стека для консьюмеров

Сконфигурируйте параметры сетевых буферов и отключите Reverse Path Filtering.

```bash
sudo vim /etc/sysctl.conf
```

```text
# Increase the maximum total buffer-space allocatable
net.ipv4.udp_mem = 65536 131072 262144

# Default Socket Receive Buffer
net.core.rmem_default = 25165824

# Maximum Socket Receive Buffer
net.core.rmem_max = 134217728

# Increase the read-buffer space allocatable (minimum size,
# initial size, and maximum size in bytes)
net.ipv4.tcp_rmem = 20480 12582912 25165824
net.ipv4.udp_rmem_min = 16384

# Default Socket Send Buffer
net.core.wmem_default = 25165824

# Maximum Socket Send Buffer
net.core.wmem_max = 25165824

# Increase the write-buffer-space allocatable
net.ipv4.tcp_wmem = 20480 12582912 25165824
net.ipv4.udp_wmem_min = 16384

# Maximum number of packets in waiting queue
net.core.netdev_max_backlog=50000

# Disable Reverse Path Filtering
net.ipv4.conf.all.rp_filter = 0
```

Примените сохранённые изменения

```bash
sudo sysctl -p
```

### Оптимизация сетевого стека для ATSD

При установке ATSD на сервере, отличном от сервера консьюмеров, также увеличьте размеры сетевых буферов.

```bash
sudo vim /etc/sysctl.conf
```

```sh
net.ipv4.udp_mem = 65536 131072 262144
net.core.rmem_default = 25165824
net.core.rmem_max = 25165824
net.ipv4.tcp_rmem = 20480 12582912 25165824
net.ipv4.udp_rmem_min = 16384
net.core.wmem_default = 25165824
net.core.wmem_max = 25165824
net.ipv4.tcp_wmem = 20480 12582912 25165824
net.ipv4.udp_wmem_min = 16384
net.core.netdev_max_backlog = 50000
```

```bash
sudo sysctl -p
```

## Синхронизация времени

Для корректной работы систем, в частности встроенных средств мониторинга задержки, необходима синхронизация с сервером точного времени Московской биржи.

<!-- markdownlint-disable MD104 -->
Проверьте доступность NTP сервера. В случае недоступности обратитесь к DMA-провайдеру.

```bash
ping 91.203.252.12
```

Установите `ntpd` в качестве NTP клиента по умолчанию.

```bash
sudo timedatectl set-ntp no
sudo apt update && sudo apt install ntp
```

Пропишите NTP сервера биржи в качестве единственных источников точного времени, закомментировав пулы умолчанию.

```bash
sudo vim /etc/ntp.conf
```

```text
server 91.203.252.12
server 91.203.254.12

#pool 0.ubuntu.pool.ntp.org iburst
#pool 1.ubuntu.pool.ntp.org iburst
#pool 2.ubuntu.pool.ntp.org iburst
#pool 3.ubuntu.pool.ntp.org iburst
```

Перезапустите сервис `ntpd`.

```bash
sudo service ntp restart
```

Проверьте, что время синхронизировано.

```bash
ntpstat
```

```text
synchronised to NTP server (91.203.254.12) at stratum 3
   time correct to within 5 ms
   polling server every 64 s
```

## Отправка снэпшотов сделок

Для проверки, что все сделки были корректно заложены, настройте отправку файлов со сделками (снэпшоты) на сервер ATSD для восполнения потерь.

Создайте токен для доступа к сервису закладки снэпшотов. Откройте **Admin > Users > Create Token**.
Укажите `/api/v1/trades/upload` в поле **URL**, метод `POST` и нажмите **Issue Token**.
Укажите полученный токен в поле `TOKEN` в файле `/opt/moex-consumer/scripts/moex-consumer-env.sh`.

Добавьте скрипты для отправки снэпшотов по окончании торгового дня.

```sh
crontab -e
```

```txt
10 1 * * 1-6 /opt/moex-consumer/scripts/daily_trades_upload.sh spectra
14 1 * * 1-6 /opt/moex-consumer/scripts/daily_trades_upload.sh asts-fx
12 1 * * 1-6 /opt/moex-consumer/scripts/daily_trades_upload.sh asts-fond
20 1 * * 1-6 /opt/moex-consumer/scripts/daily_trade_snapshot_upload.sh asts-fx
22 1 * * 1-6 /opt/moex-consumer/scripts/daily_trade_snapshot_upload.sh asts-fond
```