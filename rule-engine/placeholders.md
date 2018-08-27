# Placeholders

## Overview

Placeholders are expressions that can be used to include details and context information in email messages, webhook notifications, scripts, and logging events.

![](./images/placeholders-email.png)

## Syntax

The placeholder is declared with the dollar sign `$` and curly braces `{}` containing an expression.

```bash
${expression}
```

When the response action is triggered, the expression between the braces is resolved to a concrete value based on the window context.

The replacements in the original input text, such as email subject, are performed _in-place_ where each placeholder is substituted with the value of its expression, converted to a string.

The placeholder expression can refer to:

* [Window](window-fields.md) fields

  `Alert created for ${rule} with ${status}.`

* [Entity](../api/meta/entity/list.md#fields) and [metric](../api/meta/metric/list.md#fields) tags and fields

  `Incident registered in ${entity.tags.location}.`

* Literal values (constants) of different [data types](variables.md#data-types)

  `Memory usage is too high ${value/1024}.`

* User-defined [variables](variables.md)

  `Action executed by ${msg_user}.`

* [Function](functions.md) results

  `Last message received on ${date_format(last_msg.timestamp)}.`

Commonly used placeholders are listed in context cards for the editor fields where the placeholders are accepted.

![](./images/placeholder-card.png)

## Error Handling

Unknown fields and variables are evaluated to `null`.

If the expression itself evaluates to `null`, the placeholder is substituted with an **empty** string.

If the expression cannot be evaluated due to an error, the placeholder is left unchanged and an error message is presented on the **Rule Errors** page.

## Examples

```bash
ActiveMQ on ${entity} recorded unauthorized connection from ${tags.remoteaddress}.
```

```txt
ActiveMQ on nurswgvml007 recorded unauthorized connection from 192.0.2.106.
```

---

```bash
Average CPU usage on ${entity} is high: ${round(avg()*100,1)}%
```

```txt
Average CPU usage on nurswgvml007 exceeds threshold: 70.2%
```

---

```bash
File System '${tags.file_system}' is low on disk space: ${value} (used)
```

```txt
File System '/opt/apps' is low on disk space: 95.567 (used)
```

---

```bash
Server ${entity.label}/${entity} located at site ${upper(entity.tags.location)} is shutting down.
```

```txt
Server Apps-NUR/nurswgvml007 located at site NUR is shutting down.
```
