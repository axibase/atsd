# Установка

## Установка ATSD

```bash
curl -O https://www.axibase.com/public/atsd.moex.latest.tar.gz
tar -xzf atsd.moex.latest.tar.gz
./atsd/bin/atsd-tsd.sh start
```

## Установка MOEX консьюмеров

```bash
curl -O https://www.axibase.com/public/moex-consumer.tar.gz
tar -xzf moex-consumer.tar.gz /opt/moex-consumer
/opt/moex-consumer/install.sh
```

Параметры `atsd.host`, `atsd.port.tcp`, `atsd.port.udp` позволяют указать ATSD, на которую будут отправлены команды. Данные параметры необходимы в случае распределенной инсталляции.

```bash
systemctl start moex-consumer-asts-fond
systemctl start moex-consumer-asts-fx
systemctl start moex-consumer-spectra
```

## Требования к операционной системе

## Архитектура Процессора

* `x86_64` / `64` бита

## Операционная система

* Ubuntu `18.04`
* RedHat Enterprise Linux `7.x`
* CentOS `7.x`
* Debian `8.x`, `9.x`

## Требования к аппаратным ресурсам

## ЦПУ и ОЗУ

| Ресурс | Количество
| --- | :--- |
| ОЗУ | `8+` Гб |
| ЦПУ | `10+` GHz |
| Тип дисков | SSD |

:::tip Подсказка
Для подсчета общего количества ЦПУ умножьте количество ядер на тактовую частоту, например, `4 * 2.5` GHz = `10` GHz.
:::

## Дисковое пространство

* Установочные файлы: `10` GB.
* Данные: `50` GB **минимум**.

:::tip Подсказка
Заранее предусмотрите расширяемость диска без необходимости переустановки.
:::

## Оптимизация сетевого стека Linux

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