# Metric Persistence Filter


The metric persistence filter field in the metric editor is used to discard
inserts based on a filter expression, similar to the filter expressions
found in the rule engine editor.

Below is a use case example of how the metric persistence filter can be
used.

To see which metrics have the most amount of inserts navigate to **Admin > Receive Statistics**:

![](images/top_hourly_metrics.png "top_hourly_metrics")

The [Series] icon provides a list of unique tags for the given metric. Often it is not worth storing many short-lived processes:

![](images/series.png)

To stop storing the short-lived processes, create a collection
containing filter expressions (collections can be found under the **Configuration > Named Collections**):

![](images/names_collections_new.png "names_collections")

Finally, apply the filter to the metric in order to ignore processes
matching any of those expressions:

`!likeAny(tags.command, collection('ignore-collector-process-commands'))`

Supported Functions:

-   Collection: `list(String value);`
-   Collection: `list(String value, String delimiter);`
-   Collection: `collection(String name);`
-   Boolean: `likeAll(Object message, Collection values);`
-   Boolean: `likeAny(Object message, Collection values);`
-   Expressions like: `tags.id NOT IN ('a', 'b', 'c')` are supported

![](images/disk_used.png "screenshot_4_1421925441")

As a result, the amount of short-lived processes being stored is
substantially reduced without modifying the collector scripts:

![](images/screenshot_5_1421925689.png "screenshot_5_1421925689")
