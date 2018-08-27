# Security Functions

## Overview

These functions check user permissions as part of the rule notification logic and allow or deny response actions such as sending portals or invoking scripts.

## Reference

* [`userInGroup`](#useringroup)
* [`userHasRole`](#userhasrole)
* [`userAllowEntity`](#userallowentity)
* [`userAllowEntityGroup`](#userallowentitygroup)
* [`userAllowPortal`](#userallowportal)

## Processing

The boolean functions below return `true` if the user is valid and allowed to execute the given action. Otherwise, the function returns `false`.

As an alternative to `if/else` syntax, set the optional `err` parameter to `true`, which causes the function to raise error and stop processing altogether in case of insufficient permissions.

## `userInGroup`

```javascript
userInGroup(string user, string group [, boolean err]) boolean
```

Returns `true` if the `user` exists, is enabled, and belongs to the specified user `group`.

## `userHasRole`

```javascript
userHasRole(string user, string role [, boolean err]) boolean
```

Returns `true` if the `user` exists, is enabled, and has the specified [`role`](../administration/user-authorization.md#role-based-access-control).

## `userAllowEntity`

```javascript
userAllowEntity(string user, string entity [, boolean err]) boolean
```

Returns `true` if the `user` exists, is enabled, and has [`READ`](../administration/user-authorization.md#entity-permissions) permission for the specified `entity`.

## `userAllowEntityGroup`

```javascript
userAllowEntityGroup(string user, string entityGroup [, boolean err]) boolean
```

Returns `true` if the `user` exists, is enabled, and has [`READ`](../administration/user-authorization.md#entity-permissions) permission to the specified `entityGroup`.

## `userAllowPortal`

```javascript
userAllowPortal(string user, string portal [, boolean err]) boolean
```

Returns `true` if the user `user` exists, is enabled, and has permissions to view the specified `portal`.
