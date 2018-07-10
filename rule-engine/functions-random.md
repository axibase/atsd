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

## `randomNormal`

```javascript
randomNormal() double
```

Returns a normally distributed double number, with a mean value of `0.0` and standard deviation `1.0`.

## `randomItem`

```javascript
randomItem([] c) string
```

Returns a random element from a collection or map using the **uniform** distribution.

The probability of each element to be selected is `1/c.size()`.

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

`Key-value` maps are provided by the [`replacementTable`](functions-lookup.md#replacementtable) function.

> Replacement tables are listed on the **Data > Replacement Tables** page.

Assuming the replacement table contains the following rows and the second entry is randomly selected:

```elm
John Doe=(800) 555-0100
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
/*
  Returns a key-value object consisting of string key and string value
  The object fields can be accessed with .key and .value methods.
*/
randomItem(replacementTable('oncall-person'))
```

```javascript
selItem = randomItem(replacementTable('oncall-person'))
selKey = selItem.key
```

## `randomKey`

```javascript
randomKey([] m) string
```

Returns a random element from the specified map `m` of objects using **uniform** distribution.

The keys in the map can be of any type, whereas the values must be numeric and represent probabilities of the given key to be selected.

The function returns the randomly selected key converted to string.

The sum of probabilities does not have to equal `1.0` as the inputs are weighted to total `1.0`.

An input map can be obtained using the `replacementTable()` lookup function.

```javascript
randomKey(replacementTable('oncall-person'))
```

> Replacement tables are listed on the **Data > Replacement Tables** page.

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
