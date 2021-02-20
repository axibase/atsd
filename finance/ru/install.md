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
Заранее предусмотрите расширяемость диска пбез необходимости переустановки.
:::
