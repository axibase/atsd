# `ping` Command

## Description

This command can be sent by clients to maintain an open connection by preventing an inactivity timeout.
The server responds `ok` to the `ping` command.

## Syntax

```ls
ping
```

## Fields

None.

## ABNF Syntax

```txt
command = "ping"
```

## Examples

```txt
ping
```

> Response

```txt
ok
```
