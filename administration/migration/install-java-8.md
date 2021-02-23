# Install Java 8

Switch to `root` or execute the below steps under a user with `sudo` privileges.

## OpenJDK

* Ubuntu, Debian

```sh
apt-get install openjdk-8-jdk
```

* Red Hat Enterprise Linux, SLES, CentOS, Oracle Linux

```sh
yum install java-1.8.0-openjdk-devel
```

In case the package is not available, install Open JDK 8 using an alternative package repository or by downloading the binary.

## Update Alternatives for Java Executables

Review available Java installations and select Java 8 as the default option.

* Ubuntu, Debian

```sh
update-alternatives --config java
```

```sh
update-alternatives --config javac
```

* Red Hat Enterprise Linux, SLES, CentOS, Oracle Linux

```sh
alternatives --config java
```

```sh
alternatives --config javac
```

## Verify Installation

Verify that Java 8 is set as the default executable and compiler.

```sh
java -version
```

```sh
javac -version
```
