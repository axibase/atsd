# Control Flow

The following syntax options for conditional processing and iteration are supported in response actions.

## If / Else

The `if/else` syntax below enables condition processing.

The `if` and `else` branches accept boolean conditions.

```javascript
@if{condition}
  @else{condition}
  @else{}
@end{}
```

The result of applying this template is the original text without text contained in branches that evaluated to `false`.

The following example adds the table with entity tags only for `nurswgvml007` entity.

```javascript
  @if{entity == 'nurswgvml007'}
    ${addTable(entity.tags, 'ascii')}
  @end{}
```

## Iteration

```javascript
@foreach{item : collection}
  @{item.field}
@end{}
```

The result is the original text with inserted blocks of text for each item in the collection.

Note that the items in the collection are referenced using `@{}` syntax instead of the default placeholder `${}` syntax.

The following example add the details table with entity tags only if the tags.status is equal to `start`.

```javascript
@foreach{srv : servers}
  * ${getEntityLink('@{srv}')}<br>
@end{}
```
