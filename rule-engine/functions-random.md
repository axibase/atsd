# Distribution Functions

## Overview

## Reference

* [`random`](#random)
* [`randomNormal`](#randomnormal)
* [`randomItem`](#randomitem)
* [`randomKey`](#randomkey)

## `random`

```javascript
random() double
```

Returns a uniformly distributed double number, greater than or equal to `0.0` and less than `1.0`.

The mean value is `0.5`. The range of values is `[0, 1)`.

To generate a sample for a customized mean and value range, use the following formula:

```javascript
customMean + (random()-0.5)*customRange
```

```javascript
# Generate a random value from a uniform distribution with a mean of 10 in the [9, 11) range.
10 + (random()-0.5)*2
```

## `randomNormal`

```javascript
randomNormal() double
```

Returns a normally distributed double number, with a mean value of `0.0` and standard deviation `1.0`.

To generate a sample for a customized mean and deviation, use the following formula:

```javascript
customMean + randomNormal()*customStdDev
```

```javascript
# Generate a random value from a normal distribution with a mean of 10 and standard deviation of 2.
# 68.2% of values will be in the [8, 12] range.
10 + randomNormal()*2
```

## `randomItem`

```csharp
randomItem([object] c | map m) string
```

Returns a random element from a collection or map using the **uniform** distribution.

The probability of each element to be selected is `1/c.size()` or `1/m.size()` respectively.

Returns the selected element converted to string format. For maps, the returned object is a `key-value` object.

Input collection can contain elements of any type, such as strings or numbers, and can be specified as follows:

### String Collection

```javascript
randomItem(['a', 'b', 'c'])
```

### Number Collection

```javascript
randomItem([1, 2, 3])
```

Note that although the input collection contains numbers, the returned element is a string which has to be parsed to a number if necessary.

```javascript
randomItem([1, 2, 3]) = '2'
```

```javascript
Double.parseDouble(randomItem([1, 2, 3])) >= 2
```

### Named Collection

Named collections are listed on the **Data > Named Collections** page.

Assuming the collection contains the following records and the 2nd entry is randomly selected:

```elm
John Doe
Mary Jones
Jack Smith
```

```javascript
// returns Mary Jones
randomItem(collection('oncall-person'))
```

### Key-Value Map

Key-value maps can be loaded with the [`replacementTable`](functions-lookup.md#replacementtable) function.

The replacement tables are listed on the **Data > Replacement Tables** page.

Assuming the replacement table contains the following rows and the second entry is randomly selected:

```elm
John Doe  =(800) 555-0100
Mary Jones=(800) 555-0200
Jack Smith=(800) 555-0300
```

```javascript
// returns Mary Jones
randomItem(replacementTable('oncall-person').keySet())
```

```javascript
// returns (800) 555-0200
randomItem(replacementTable('oncall-person').values())
```

```javascript
/* Returns a key-value object consisting of string key and string value
The object fields can be accessed with .key and .value methods. */
randomItem(replacementTable('oncall-person'))
```

```javascript
selItem = randomItem(replacementTable('oncall-person'))
selKey = selItem.key
```

## `randomKey`

```csharp
randomKey(map m) string
```

Returns a random element from the specified map `m` of objects using **uniform** distribution.

The keys in the map can be of any type, whereas the values must be numeric and represent probabilities of the given key to be selected.

The function returns the randomly selected key converted to string.

The sum of probabilities does not have to equal `1.0` as the inputs are weighted to total `1.0`.

An input map can be obtained using the `replacementTable()` lookup function.

```javascript
randomKey(replacementTable('oncall-person'))
```

Replacement tables are listed on the **Data > Replacement Tables** page.

Assuming the table contains the following records, the second element has a 20% chance of being selected:

```elm
John Doe=0.5
Mary Jones=0.2
Jack Smith=0.3
```

The `excludeKeys` function can be used to remove some elements from the input map prior to invoking the `randomKey` function.

```javascript
randomKey(excludeKeys(replacementTable('oncall-person'),['Jack Smith']))
```
