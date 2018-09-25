---
sidebarDepth: 0
---

# Getting Started: Portals

## Contents

1. [Introduction](./getting-started.md)
1. [Inserting Data](./getting-started-insert.md)
1. Portals
1. [Exporting Data](./getting-started-export.md)
1. [SQL](./getting-started-sql.md)
1. [Alerting](./getting-started-alert.md)

## Creating Portals

A [portal](../portals/README.md) is a collection of [widgets](https://axibase.com/products/axibase-time-series-database/visualization/widgets/) displayed on one page.

A portal can be defined as a `template` portal to display data for a specific entity which is passed as a parameter. A portal can also be `regular`, in which case the entity is defined in the configuration text by the user. These instructions detail the creation of a **regular** portal for the entity `br-1905`.

Expand **Portals** from the top menu and click **Create**

![](./resources/getting-started-portal_1.png)

1. Specify a portal name.

2. Set portal to **Regular** in the **Type** drop-down list.

3. Copy the following configuration text into the **Content** window.

    ```ls
    [configuration]
      height-units = 2
      width-units = 2
      time-span = 24 hour
      update-interval = 5 second

    [group]
      widgets-per-row = 2
      [widget]
        type = chart
        [series]
          entity = br-1905
          metric = temperature

      [widget]
        type = gauge
        mode = half
        thresholds = 0, 20, 40, 60, 100
        [series]
          entity = br-1905
          metric = temperature
    ```

    The above portal contains two widgets: a 24-hour linear [time chart](https://axibase.com/products/axibase-time-series-database/visualization/widgets/time-chart/) and a [gauge](https://axibase.com/products/axibase-time-series-database/visualization/widgets/gauge-chart/) showing the last value.

4. Click **Save**.

5. To view the portal, click **View By Name**.

![](./resources/portal-edit.png)

The resulting portal is shown below:

![](./resources/portal-view.png)

## Adding Widgets

Add a third time chart which contains a calculated series by appending the following text to widget configuration in the **Content** window:

```ls
[widget]
  type = chart
  mode = stack
  [series]
    entity = br-1905
    metric = temperature
    color = orange
    # multiply values by 2
    replace-value = value * 2
```

Reload the portal to view the new chart.

Start a [`bash` loop](./getting-started-insert.md#sending-values-continuously) to observe new data points as they appear in the portal.

Review the [Selecting Series Overview](../portals/selecting-series.md) and the [Charts Reference](https://axibase.com/products/axibase-time-series-database/visualization/) for more layout examples.

## Metadata

The Charts library provides settings and functions to [add metadata](https://axibase.com/products/axibase-time-series-database/visualization/widgets/metadata/) to charts and thus eliminate manual tagging and labeling.

Add the following settings at the `[configuration]` level to automatically embed entity and metric metadata into series legend.

```ls
legend-position = top
add-meta = true
label-format = meta.entity.label: meta.metric.label (meta.metric.units)
```

![](./resources/portal-meta-edit.png)

Click **View By Name** to view the updated portal.

![](./resources/portal-meta-view.png)

Continue to [Part 4: Export Data](getting-started-export.md).
