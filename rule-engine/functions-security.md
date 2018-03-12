# Security Functions

## Overview

Security functions check user permissions as part of rule notification logic. These functions can be used to allow or deny certain response actions such as sending portals or invoking scripts.

## Reference

* [userInGroup](#useringroup)
* [userHasRole](#userhasrole)
* [userAllowEntity](#userallowentity)
* [userAllowEntityGroup](#userallowentitygroup)
* [userAllowPortal](#userallowportal)

## Processing

The boolean functions below return `true` if the user is valid and is allowed to execute the given action. Otherwise, the function returns `false`. 

As an alternative to `if/else` syntax, set the optional `err` parameter to `true`, which will cause the function to terminate processing altogether in case of insufficient permissions.

### `userInGroup`

```javascript
  userInGroup(string u, string g [, boolean err]) boolean
```
Returns `true` if the user `u` exists, is enabled, and belongs to the specified user group `g`.

### `userHasRole`

```javascript
  userHasRole(string u, string r [, boolean err]) boolean
```
Returns `true` if the user `u` exists, is enabled, and has the specified role [`r`](../administration/user-authorization.md#role-based-access-control).

### `userAllowEntity`

```javascript
  userAllowEntity(string u, string e [, boolean err]) boolean
```
Returns `true` if the user `u` exists, is enabled, has [READ](../administration/user-authorization.md#entity-permissions) permission for the specified entity `e`.

### `userAllowEntityGroup`

```javascript
  userAllowEntityGroup(string u, string g [, boolean err]) boolean
```
Returns `true` if the user `u` exists, is enabled, and has [READ](../administration/user-authorization.md#entity-permissions) permission to the specified entity group `g`.

### `userAllowPortal`

```javascript
  userAllowPortal(string u, string p [, boolean err]) boolean
```
Returns `true` if the user `u` exists, is enabled, and has permissions to view the specified portal `p`.
