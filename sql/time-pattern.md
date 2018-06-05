# Date and Time Pattern letters

## Pattern Letters

```txt
| Symbol | Date or Time Component        | Presentation       | Examples                                       |
|--------|-------------------------------|--------------------|------------------------------------------------|
| G      | Era                           | text               | AD; Anno Domini; A                             |
| u      | Year                          | year               | 2004; 04                                       |
| y      | Year of era                   | year               | 2004; 04                                       |
| D      | Day of year                   | number             | 189                                            |
| M/L    | Month of year                 | number/text        | 7; 07; Jul; July; J                            |
| d      | Day of month                  | number             | 10                                             |
| Q/q    | Quarter of year               | number/text        | 3; 03; Q3; 3rd quarter                         |
| Y      | Week-based year               | year               | 1996; 96                                       |
| w      | Week of week-based-year       | number             | 27                                             |
| W      | Week of month                 | number             | 4                                              |
| E      | Day of week                   | text               | Tue; Tuesday; T                                |
| e      | Localized day of week         | number/text        | 3; 03; Tue; Tuesday; T                         |
| c      | Day of week                   | number/text        | 2                                              |
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
| V      | Time-zone ID                  | zone-id            | America/Los_Angeles; Z; -08:30                 |
| z      | Time-zone name                | zone-name          | Pacific Standard Time; PST                     |
| O      | Localized zone-offset         | offset-O           | GMT+8; GMT+08:00; UTC-08:00;                   |
| X      | Zone-offset 'Z' for zero      | offset-X           | Z; -08; -0830; -08:30; -083015; -08:30:15      |
| x      | Zone-offset                   | offset-x           | +0000; -08; -0830; -08:30; -083015; -08:30:15  |
| Z      | Zone-offset in RFC822 format  | offset-Z           | Z; +0100 (same as XX)                          |
| ZZ     | Zone-offset in ISO8601 format | offset-Z           | Z; +01:00 (same as XXX)                        |
| ZZZ    | Zone-id                       | text               | Europe/Berlin (same as VV)                     |
| p      | Pad next                      | pad modifier       | 1                                              |
| '      | Escape for text               | delimiter          |                                                |
| ''     | Single quote                  | literal            | '                                              |
| [      | Optional section start        |                    |                                                |
| ]      | Optional section end          |                    |                                                |
```

Note: localized day of week pattern (`e`) prints day number of week in US locale starting from Sunday.
To print day number of week starting from Monday, use the `c` pattern.

## Examples

```ls
| Date and Time Pattern            | Result                               |
|----------------------------------|--------------------------------------|
| 'yyyy.MM.dd G ''at'' HH:mm:ss z' | 2001.07.04 AD at 12:08:56 PDT        |
| 'EEE, MMM d, ''''yy'             | Wed, Jul 4, '01                      |
| 'h:mm a'                         | 12:08 PM                             |
| 'hh ''o''''clock'' a, zzzz'      | 12 o'clock PM, Pacific Daylight Time |
| 'K:mm a, z'                      | 0:08 PM, PDT                         |
| 'yyyyy.MMMM.dd GGG hh:mm a'      | 02001.July.04 AD 12:08 PM            |
| 'EEE, d MMM yyyy HH:mm:ss Z'     | Wed, 4 Jul 2001 12:08:56 -0700       |
| 'yyMMddHHmmssZ'                  | 010704120856-0700                    |
| 'yyyy-MM-dd''T''HH:mm:ss.SSSZ'   | 2001-07-04T12:08:56.235-0700         |
| 'yyyy-MM-dd''T''HH:mm:ss.SSSXXX' | 2001-07-04T12:08:56.235-07:00        |
| 'YYYY-''W''ww-c'                 | 2001-W27-3                           |
```

## Custom Formatting

If the default pattern letters are not sufficient, use String and Math functions to apply custom formatting.

```sql
CEIL(CAST(date_format(time, 'M') AS NUMBER)/3) AS "Quarter"
```
