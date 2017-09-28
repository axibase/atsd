# Compression Tests

## Overview

The following tests estimate the amount of disk space required to store the same dataset containing 10+ million `time:value` samples in different databases. 

## Results

| **Database** | **Version** | **Schema** | **Compressed** | **Bytes per Sample** | **Test Link** |
|:---|:---|:---|:---|---:|---|
| PostgreSQL | 9.6   | Specific   | No  | 21.6 | [view](postgres.md) |
| PostgreSQL | 9.6   | Universal  | No  | 83.7 | [view](postgres.md) |
| MySQL      | 5.7   | Specific   | Yes | 8.2  | [view](mysql.md) |
| MySQL      | 5.7   | Specific   | No  | 15.6 | [view](mysql.md) |
| MySQL      | 5.7   | Universal  | Yes | 34.5 | [view](mysql.md) |
| MySQL      | 5.7   | Universal  | No  | 70.7 | [view](mysql.md) |
| Oracle      | EE, 12c (12.2.0.1)   | Specific   | Yes | 9.4  | [view](oracle.md) |
| Oracle      | EE, 12c (12.2.0.1)   | Specific   | No  | 13.4 | [view](oracle.md) |
| Oracle      | EE, 12c (12.2.0.1)   | Universal  | Yes | 39.3 | [view](oracle.md) |
| Oracle      | EE, 12c (12.2.0.1)   | Universal  | No  | 52.5 | [view](oracle.md) |
| **ATSD**       | **17340** | **Universal**  | **Yes** | **1.9**  | [view](atsd.md)  |
