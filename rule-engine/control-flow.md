# Control Flow

The following syntax options for conditional processing and iteration are supported in response actions.

> Note the spaces and new lines between opening `@if{}/@foreach{}` and closing `@end{}` keywords are kept as is.

## Conditional Processing

The `if/else` syntax below enables condition processing.

The `if` and `else` branches accept boolean conditions.

```css
@if{condition}
@else{condition}
@else{}
@end{}
```

The result of applying this template is the original text less any text contained in branches that evaluated to `false`.

The following example adds the table with entity tags only for `nurswgvml007` entity.

```javascript
@if{entity == 'nurswgvml007'}
${addTable(entity.tags, 'ascii')}
@end{}
```

## Iteration

```css
@foreach{item : collection}
@{item.field}
@end{}
```

The result is the original text plus inserted blocks of text for each item in the collection.

Note that the items in the collection are referenced using `@{}` syntax instead of the default placeholder `${}` syntax.

The following example adds entity link for each element in collection `servers`.

```javascript
@foreach{srv : servers}
* @{getEntityLink(srv)}
@end{}
```
