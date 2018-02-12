# Security Functions

## Overview

Security functions provide the way to check permission settings specified at **Settings > Users** and **Settings > Users Groups** pages.

## Reference

* [userInGroup](#useringroup)
* [userHasRole](#userhasrole)
* [userAllowEntity](#userallowentity)
* [userAllowEntityGroup](#userallowentitygroup)
* [userAllowPortal](#userallowportal)

### `userInGroup`

```javascript
  userInGroup(string u, string g) boolean
```
Returns `true` if the user `u` exists, is enabled, and belongs to the specified user group `g`.

### `userHasRole`

```javascript
  userHasRole(string u, string r) boolean
```
Returns `true` if the user `u` exists, is enabled, and has the specified role [`r`](../administration/user-authorization.md#role-based-access-control).

### `userAllowEntity`

```javascript
  userAllowEntity(string u, string e) boolean
```
Returns `true` if the user `u` exists, is enabled, has [READ](../administration/user-authorization.md#entity-permissions) permission for the specified entity `e`.

### `userAllowEntityGroup`

```javascript
  userAllowEntityGroup(string u, string g) boolean
```
Returns `true` if the user `u` exists, is enabled, and has [READ](../administration/user-authorization.md#entity-permissions) permission to the specified entity group `g`.

### `userAllowPortal`

```javascript
  userAllowPortal(string u, string p) boolean
```
Returns `true` if the user `u` exists, is enabled, and has permissions to view the specified portal `p`.