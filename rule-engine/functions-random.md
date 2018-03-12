# Random Functions

## Overview

## Reference

* [random](#random)
* [randomNormal](#randomnormal)
* [randomItem](#randomitem)
* [randomKey](#randomkey)

### `random`

```javascript
  random() double
```
Returns a uniformly distributed double number, greater than or equal to `0.0` and less than `1.0`.

### `randomNormal`

```javascript
  randomNormal() double
```

Returns a normally distributed double number, with a mean value of `0.0` and standard deviation `1.0`.

### `randomItem` 

```javascript
  randomItem([] c) string
```

Returns a random element from collection `c` using the **uniform** distribution. The probability of each element to be selected is `1/c.size()`.

The function returns the selected element converted to string format.

An input collection can contain elements of any type, such as strings or numbers, and can be specified as follows:

* Collection of strings

	```javascript
	  randomItem(['a', 'b', 'c'])
	```

* Collection of numbers

	```javascript
	  randomItem([1, 2, 3])
	```

Note that although the input collection contains numbers, the returned element will be a string which has to be parsed to a number if necessary.

	```javascript
	  randomItem([1, 2, 3]) = '2'
	```

	```javascript
	  Double.parseDouble(randomItem([1, 2, 3])) >= 2
	```

* Named collection

	> Named collections are listed on **Data > Named Collections** page.

	Assuming the collection contains the following records and the 2nd entry is randomly selected:

	```
		Kent
		Thomas
		Stacy
	```

	```javascript
	  randomItem(collection('oncall-person'))
	  // returns Thomas
	```

* Keys or values from an object map

	> Replacement tables are listed on **Data > Replacement Tables** page.

	Assuming the table contains the following records and the 2nd entry is randomly selected:

	```
		Kent=415.555-0000
		Thomas=415.555-0001
		Stacy=415.555-0002
	```

	```javascript
	  randomItem(replacementTable('oncall-person').keySet())
	  // returns Thomas
	```

	```javascript
	  randomItem(replacementTable('oncall-person').values())
	  // returns 415.555-0001
	```

	```javascript
	  randomItem(replacementTable('oncall-person').entrySet())
	  // returns Thomas=415.555-0001
	```

### `randomKey` 

```javascript
  randomKey([] m) string
```

Returns a random element from the specified map `m` of objects using the **uniform** distribution.

The keys in the map can be of any type, whereas the values must be numeric and represent probabilities of the given key to be selected.

The function returns the randomly selected key converted to string.

The sum of probabilities doesn't have to equal 1.0 as the inputs will be weighted to total 1.0.

An input map can be obtained using the `replacementTable()` lookup function.


```javascript
  randomKey(replacementTable('oncall-person'))
```

> Replacement tables are listed on **Data > Replacement Tables** page.

Assuming the table contains the following records, the second element has a 20% chance of being selected:

```
  Kent=0.5
  Thomas=0.2
  Stacy=0.3
```

The `excludeKeys` function can be used to remove some elements from the input map prior to invoking the `randomKey` function.	

```javascript
  randomKey(excludeKeys(replacementTable('oncall-person'),['Stacy']))
```
