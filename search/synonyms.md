# Synonym Search

## Overview

Synonym search allows finding series with metadata fields containing values with a similar meaning in the original or other languages.

For example, a user searching for series with 'currency' keyword might be interested in locating series with keywords `money`, `cash` as well as `geld` (German) and `dinero` (Spanish).

The synonyms can be created for all [metadata fields](README.md#overview).

## Configuration

The list of synonyms can be specified in the `conf/synonym.conf` file accessible on the **Settings > Configuration Files** page.

## Syntax

The synonyms for a keyword are defined with the assign `=>` operator. The search results will match the same series when searched either by the keyword itself or one of its synonyms.

```css
keyword => synonym[, synonym]
```

Multiple synonyms can be specified on one line, separated by a comma.

Synonyms are disabled when the keyword is specified as field name. The following searches will yield different results:

```css
keyword:value
synonym:value
```

## Examples

* The word 'money' has one synonym.

```css
money => currency
location => place, site
```

Searching for 'money' would match series containing either keyword, 'money' or 'currency'.
The same results will be displayed if the 'currency' keyword is searched as well.

* The word 'location' has four synonyms.

```css
location => place, site, Ort, место
```

Searching for `location` would match the below series since it has an entity tag `location`.
Likewise, searching for `ort` would match the same series since `ort` is a synonym of `location`, which is one of the entity tags.

```sql
student_count         -- metric
nyu.edu               -- entity
location = NYC        -- entity tag
school = CAS          -- series tag
```

However, `location:NYC` and `place:NYC` searches would produce different results because synonyms are not supported in field names and therefore 'place' as a field name is not enabled as a synonym for the 'location' field name. As a result, `place:NYC` will not match the above series.

## Implementation

After the `conf/synonym.conf` file is updated, the search index must be refreshed by an administrator on the **Settings > Diagnostics > Search Index** page.
