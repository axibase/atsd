# Window

## Overview

A window is an in-memory structure created by Rule Engine for each unique combination of metric, entity, and grouping tags extracted from incoming commands.

Windows are accessible on the **Alerts > Rule Windows** page.

![](./images/rule-windows.png)

## Window Length

### `count` Windows

Count-based windows accumulate up to the specified number of samples. Samples are sorted **by command timestamp**, with the most recent sample placed at the end of the array. When the window is full, the first (**oldest** by command time) sample is removed from the window to free up space at the end of the array for an incoming sample.

<svg version="1.1" baseProfile="full" width="400" height="70" xmlns="http://www.w3.org/2000/svg">
<style type="text/css" >
<![CDATA[
    rect {
        fill: #0099cc;
        opacity: 0;
    }
    @keyframes abc {
      0%   {transform: translate(350px, 20px); opacity: 0;}
      10%  {transform: translate(65px, 20px); opacity: 1;}
      39%  {transform: translate(65px, 20px); opacity: 1;}
      40%, 100% {transform: translate(20px, 20px); opacity: 0;}
    }
    @keyframes abc2 {
      0%, 10% {transform: translate(350px, 20px); opacity: 0;}
      20%  {transform: translate(120px, 20px); opacity: 1;}
      39%  {transform: translate(120px, 20px)}
      40%  {transform: translate(65px, 20px)}
      49%  {transform: translate(65px, 20px); opacity: 1;}
      50%, 100% {transform: translate(20px, 20px); opacity: 0;}
    }
    @keyframes abc3 {
      0%, 20% {transform: translate(350px, 20px); opacity: 0;}
      30%  {transform: translate(175px, 20px); opacity: 1;}
      39%  {transform: translate(175px, 20px)}
      40%  {transform: translate(120px, 20px)}
      49%  {transform: translate(120px, 20px)}
      50%  {transform: translate(65px, 20px)}
      59%  {transform: translate(65px, 20px); opacity: 1;}
      60%, 100% {transform: translate(20px, 20px); opacity: 0;}
    }
    @keyframes base {
      0%   {transform: translate(350px, 20px); opacity: 0;}
      25%  {transform: translate(175px, 20px); opacity: 1;}
      49%  {transform: translate(175px, 20px)}
      50%  {transform: translate(120px, 20px)}
      74%  {transform: translate(120px, 20px)}
      75%  {transform: translate(65px, 20px)}
      95%  {transform: translate(65px, 20px); opacity: 1;}
      100% {transform: translate(20px, 20px); opacity: 0;}
    }
    @keyframes alert {
      0%, 74%  {stroke: #E81B00; stroke-width:2}  
      75%,100%  {stroke: silver; stroke-width:2}
    }
    .init-1 {
      animation: abc 15s 0s 1 linear;
    }
    .init-2 {
      animation: abc2 15s 0s 1 linear;
    }
    .init-3 {
      animation: abc3 15s 0s 1 linear;
    }
    .rep-4-5 {
      animation: base 6.0s 4.5s linear infinite;
    }
    .rep-6-0 {
      animation: base 6.0s 6.0s linear infinite;
    }
    .rep-7-5 {
      animation: base 6.0s 7.5s linear infinite;
    }
    .rep-9-0 {
      animation: base 6.0s 9.0s linear infinite;
    }  
    .rep-alert {
      animation: alert 6.0s 9.0s linear infinite;
    }
]]>
</style>  

<rect id="win" width="170" height="50" rx="5" ry="5" x="50" y="10" style="stroke-width:2;stroke:silver;fill:white;opacity:1" class="rep-alert" fill="white" />
<rect transform="translate(350,20)" width="30" height="30" rx="3" ry="3" class="evt init-1"/>
<rect transform="translate(350,20)" width="30" height="30" rx="3" ry="3" class="evt init-2"/>
<rect transform="translate(350,20)" width="30" height="30" rx="3" ry="3" class="evt init-3"/>
<rect transform="translate(350,20)" width="30" height="30" rx="3" ry="3" class="evt rep-4-5"/>
<rect transform="translate(350,20)" width="30" height="30" rx="3" ry="3" class="evt rep-6-0"/>
<rect transform="translate(350,20)" width="30" height="30" rx="3" ry="3" style="fill:#E81B00" class="evt rep-7-5"/>
<rect transform="translate(350,20)" width="30" height="30" rx="3" ry="3" class="evt rep-9-0"/>

</svg>
<br/><br/>

![Count Based Window](./images/count_based_window3.png "count_based_window")

### `time` Windows

Time-based windows store samples received within the specified time interval. There is no limit to the number of samples stored in time-based windows.

The start of the interval is initially set to current time minus the window length, and is constantly incremented as time passes, thus these windows are sometimes referred to as **sliding** windows. If the timestamp of the incoming command is equal to or greater than the window start time, the command is added to the window.

> The **end** time in time-based windows is not set. As such, the window accepts commands with future timestamps unless they are discarded with the [Time filter](filters.md#time-offset-filter) or [filter expression](filters.md#filter-expression) such as `timestamp <= now.getMillis() + 60000`.

Old commands are automatically removed from the window once their timestamp is earlier than the defined window start time.

![Time Based Window](./images/time_based_window3.png)

## Window Status

Response actions are triggered on window status changes.

As new data is received and old data is removed from the window, the rule engine re-evaluates the condition which can cause the status of the current window to change, triggering response actions.

### Initial Status

New windows are created based on incoming data, no historical data is loaded from the database unless the **Load History** setting is turned on.

The window for the given [grouping](grouping.md) key is created when the first matching command is received by the rule engine.

New windows are assigned initial status of `CANCEL` which is then updated based on the results of a boolean condition, either `true` or `false`.

### Triggers

Response actions can be triggered whenever window status changes as well as at scheduled intervals when the status is `REPEAT`. Triggers for each action type are configured and executed separately.

### Status Events

| Previous Status | New Status | Previous Condition Value | New Condition Value | Trigger Name |
| --- | --- | --- | --- | --- |
| `CANCEL` | `OPEN` | `false` | `true` | `On Open` |
| `OPEN`  | `REPEAT` | `true` | `true` | `On Repeat` |
| `REPEAT` | `REPEAT` | `true` | `true` | `On Repeat` |
| `OPEN` | `CANCEL` | `true` | `false` | `On Cancel` |
| `REPEAT` | `CANCEL` | `true` | `false` | `On Cancel` |
| `CANCEL` | `CANCEL` | `false` | `false` | Not available |

### `OPEN` Status

The window is assigned `OPEN` status when the condition value changes from `false` to `true`.

### `REPEAT` Status

The window is assigned `REPEAT` status when the condition value remains `true` upon subsequent evaluation. `REPEAT` status requires at least two `true` consecutive evaluations.

When the window is in `REPEAT` status, response actions can be executed with the frequency specified in the rule editor, for example, every ten evaluations or every five minutes.

### `CANCEL` Status

`CANCEL` is the initial status assigned to new windows. The `CANCEL` status is also assigned to the window when the condition changes from `true` to `false` or when the window is destroyed on rule modification.

Windows in `CANCEL` status do not trigger `repeat` actions upon subsequent `false` evaluations. Emulate this behavior by creating a rule with a negated expression which returns `true` instead of `false` for the same condition.

A window assumes the `CANCEL` status when the condition changes from `true` to `false` as well as when the rule is modified, deleted, or the database is orderly shutdown. `On Cancel` triggers are not invoked, even if enabled, when the rule is modified, deleted, or in case of shutdown.  This behavior is controlled with `cancel.on.rule.change` server property.

## Life Cycle

When a rule is deleted or modified with the rule editor, all windows for the given rule are dropped. Windows are re-created when new matching commands are received by the database.

Newly created windows contain only **new commands**, unless **Load History** setting is enabled. Such windows load historical values received over the same interval as the window duration, or the same number of commands as the window length.

![](./images/load-history.png)

## Timers

The condition is re-evaluated each time a new matching command is added to or removed from the window.

To evaluate the rule on schedule, regardless of external commands, create rules based on `timer` metrics:

* `timer_15s`: Command is received every 15 seconds.
* `timer_1m`: Command is received every 1 minute.
* `timer_15m`: Command is received every 15 minutes.
* `timer_1h`: Command is received every 1 hour.

[`timer`](scheduled-rules.md) metrics are produced by the built-in database scheduler and are always available.

## Window Fields

Windows expose a set of continuously updated [window fields](window-fields.md) which can be included in the [condition](condition.md) expression, the [filter](filters.md) expression and user-defined [variables](variables.md).
