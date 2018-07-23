# Control Flow

Response actions support the following syntax options for conditional processing and iteration.

## Conditional Processing

Use `@if/@else/@end` syntax for conditional processing.

`@if` and `@else` branches accept boolean conditions.

```css
@if{condition_A}
@else{condition_B}
@else{}
@end{}
```

The result of applying this template is the original text less any text contained in branches that evaluates to `false`. The processed text retains non-printable characters such as space, tabs, and line breaks within the printed branches.

The following example prints the entity tags table in ASCII format for the entity `nurswgvml007`.

```javascript
@if{entity == 'nurswgvml007'}
${addTable(entity.tags, 'ascii')}
@end{}
```

## Iteration

Use the `@foreach` template to iterate over a collection.

```javascript
@foreach{item : collection}
@{item.field}
@end{}
```

* `collection` is the name of the iterated collection.
* `item` is any name assigned to the current element of the collection.
* Refer to items in the collection using `@{}` syntax instead of the regular placeholder `${}` syntax.

```javascript
@foreach{lnk : exLinks}
@{lnk}
@end{}
```

The result is the original text plus inserted blocks of text for each item in the collection. The produced text includes non-printable characters such as space, tabs, and line breaks inside the `@foreach` block.

The following example prints an entity link for each entity in the `servers` collection.

```javascript
@foreach{srv : servers}
* @{getEntityLink(srv)}
@end{}
```
