# Установка

## Требования к операционной системе

### Архитектура Процессора

* `x86_64` / `64`-битная версия

### Операционная система

* Ubuntu `16.04`, `18.04`
* RedHat Enterprise Linux `7.x`
* CentOS `7.x`
* Debian `8.x`, `9.x`

### ЦПУ и ОЗУ

| Ресурс | Количество
| --- | :--- |
| ОЗУ | `16` Гб |
| ЦПУ | `10+` ГГц |
| Тип дисков | SSD |

:::tip Подсказка
Для подсчета общего количества ЦПУ умножьте количество ядер на тактовую частоту, например, `4 * 2.5` ГГц = `10` ГГц.
:::

### Дисковое пространство

* Установочные файлы: `1` Гб
* Дневные лог файлы: `20` Гб
* Исторические данные: `200` Гб

:::tip Рекомендация
Заранее предусмотрите расширяемость диска без необходимости переустановки.
:::

## Установка Java

### Java для ATSD

Установите Java 8 согласно [инструкции](../../administration/migration/install-java-8.md).

Добавьте `JAVA_HOME` в параметры окружения пользователя в `.bashrc`.

```sh
jp=`dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"`; \
  sed -i "s,^export JAVA_HOME=.*,export JAVA_HOME=$jp,g" ~/.bashrc ; \
  echo $jp
```

### Java для консьюмеров

Установите Java 15 через менеджер пакетов.

```sh
curl -s "https://get.sdkman.io" | bash
sdk install java 15.0.2-librca
```

## Установка ATSD

Загрузите и распакуйте установочные файлы.

```bash
curl -O https://www.axibase.com/public/atsd.moex.latest.tar.gz
tar -xzf atsd.moex.latest.tar.gz
```

Произведите запуск приложения.

```sh
./atsd/bin/atsd-tsd.sh start
```

## Установка MOEX консьюмеров

Загрузите и распакуйте установочные файлы.

```bash
curl -O https://www.axibase.com/public/moex-consumer.tar.gz
tar -xzf moex-consumer.tar.gz /opt/moex-consumer
```

Присвойте переменной окружения `JAVA_HOME` путь к версии Java, используемой консьюмером.

```sh
sdk use java 15.0.2-librca
```

Запустите установочный скрипт.

```sh
/opt/moex-consumer/install.sh
```

Параметры `atsd.host`, `atsd.port.tcp`, `atsd.port.udp` позволяют указать ATSD, на которую будут отправлены команды. Данные параметры необходимы в случае распределенной инсталляции.

```bash
systemctl start moex-consumer-asts-fond
systemctl start moex-consumer-asts-fx
systemctl start moex-consumer-spectra
```

## Оптимизация сетевого стека для консьюмеров

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

## Оптимизация сетевого стека для ATSD

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

## Сихронизация с сервером точного времени Московской биржи

Проверьте доступность NTP сервера. В случае недоступности обратитесь к хостинг-провайдеру.

```bash
ping 91.203.252.12
```

Установите `ntpd` в качестве NTP клиента по умолчанию.

```
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

Проверьте, что время синхронизировано

```bash
ntpstat
```

```text
synchronised to NTP server (91.203.254.12) at stratum 3
   time correct to within 5 ms
   polling server every 64 s
```