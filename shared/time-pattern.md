# Date and Time Pattern letters

## Pattern Letters

```txt
| Symbol | Date or Time Component        | Presentation       | Examples                                       |
|--------|-------------------------------|--------------------|------------------------------------------------|
| G      | Era                           | text               | AD                                             |
| y      | Year of era                   | year               | 2004; 04                                       |
| D      | Day of year                   | number             | 189                                            |
| M      | Month of year                 | number             | 7                                              |
| MM     | Month of year                 | number             | 07                                             |
| MMM    | Month of year                 | text               | Jul                                            |
| MMMM   | Month of year                 | text               | July                                           |
| MMMMM  | Month of year                 | text               | J                                              |
| d      | Day of month                  | number             | 10                                             |
| Q/q    | Quarter of year               | number             | 3                                              |
| QQ     | Quarter of year               | number             | 03                                             |
| QQQ    | Quarter of year               | text               | Q3                                             |
| QQQQ   | Quarter of year               | text               | 3rd quarter                                    |
| Y      | Week-based year               | year               | 1996; 96                                       |
| w      | Week of week-based-year       | number             | 27                                             |
| W      | Week of month                 | number             | 4                                              |
| u      | Day of week                   | number             | 2                                              |
| e      | Localized day of week         | number             | 3                                              |
| ee     | Localized day of week         | number             | 03                                             |
| eee    | Localized day of week         | text               | Tue                                            |
| eeee   | Localized day of week         | text               | Tuesday                                        |
| eeeee  | Localized day of week         | text               | T                                              |
| F      | Week of month                 | number             | 3                                              |
| a      | AM-PM of day                  | text               | PM                                             |
| h      | Clock hour of AM-PM (1-12)    | number             | 12                                             |
| K      | Hour of AM-PM (0-11)          | number             | 0                                              |
| k      | Clock hour of AM-PM (1-24)    | number             | 0                                              |
| H      | Hour of day (0-23)            | number             | 0                                              |
| m      | Minute of hour                | number             | 30                                             |
| s      | Second of minute              | number             | 55                                             |
| S      | Fraction of second            | fraction           | 978                                            |
| A      | Milli of day                  | number             | 1234                                           |
| n      | Nano of second                | number             | 987654321                                      |
| N      | Nano of day                   | number             | 1234000000                                     |
| VV     | Time-zone ID                  | zone-id            | America/Los_Angeles; Z; -08:30                 |
| z      | Short time-zone name          | zone-name          | PST                                            |
| zzzz   | Full time-zone name           | zone-name          | Pacific Standard Time; PST                     |
| O      | Short localized zone-offset   | offset-O           | GMT+8                                          |
| OOOO   | Full localized zone-offset    | offset-O           | GMT+08:00; UTC-08:00                           |
| X      | Zone-offset 'Z' for zero      | offset-X           | Z; -08                                         |
| XX     | Zone-offset 'Z' for zero      | offset-X           | Z; -0830                                       |
| XXX    | Zone-offset 'Z' for zero      | offset-X           | Z; -08:30                                      |
| XXXX   | Zone-offset 'Z' for zero      | offset-X           | Z; -083015                                     |
| XXXXX  | Zone-offset 'Z' for zero      | offset-X           | Z; -08:30:15                                   |
| x      | Zone-offset                   | offset-x           | -08                                            |
| xx     | Zone-offset                   | offset-x           | -0830                                          |
| xxx    | Zone-offset                   | offset-x           | -08:30                                         |
| xxxx   | Zone-offset                   | offset-x           | -083015                                        |
| xxxxx  | Zone-offset                   | offset-x           | -08:30:15                                      |
| Z      | Zone-offset in RFC822 format  | offset-Z           | Z; +0100 (same as XX)                          |
| ZZ     | Zone-offset in ISO8601 format | offset-Z           | Z; +01:00 (same as XXX)                        |
| ZZZ    | Zone-id                       | text               | Europe/Berlin (same as VV)                     |
| p      | Pad next                      | pad modifier       | 1                                              |
| T      | T literal                     | text               | T                                              |
| '      | Escape for text               | delimiter          |                                                |
| ''     | Single quote                  | literal            | '                                              |
| [      | Optional section start        |                    |                                                |
| ]      | Optional section end          |                    |                                                |
```

Note: localized day of week pattern (`e`) prints day number of week in US locale starting from Sunday.
To print day number of week starting from Monday, use the `u` pattern.

## Examples

```ls
| Date and Time Pattern          | Result                               |
|--------------------------------|--------------------------------------|
| `yyyy.MM.dd G 'at' HH:mm:ss z` | 2001.07.04 AD at 12:08:56 PDT        |
| `eee, MMM d, ''yy`             | Wed, Jul 4, '01                      |
| `h:mm a'                       | 12:08 PM                             |
| `hh 'o''clock' a, zzzz`        | 12 o'clock PM, Pacific Daylight Time |
| `K:mm a, z`                    | 0:08 PM, PDT                         |
| `yyyyy.MMMM.dd GGG hh:mm a`    | 02001.July.04 AD 12:08 PM            |
| `eee, d MMM yyyy HH:mm:ss Z`   | Wed, 4 Jul 2001 12:08:56 -0700       |
| `yyMMddHHmmssZ`                | 010704120856-0700                    |
| `yyyy-MM-ddTHH:mm:ss.SSSZ`     | 2001-07-04T12:08:56.235-0700         |
| `yyyy-MM-ddTHH:mm:ss.SSSXXX`   | 2001-07-04T12:08:56.235-07:00        |
| `YYYY-'W'ww-u'                 | 2001-W27-3                           |
```