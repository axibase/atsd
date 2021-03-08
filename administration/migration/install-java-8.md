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

In case the package is not available, install OpenJDK 8 by downloading the binary, configuring an alternative package repository, or using an alternative package manager such as [SDKMAN](https://sdkman.io/):

```sh
# non-root privileges required
curl -s "https://get.sdkman.io" | bash
sdk list java # list all available packages
sdk install java 8.0.282-librca # Choose one of the OpenJDK 8 vendors
sdk use java 8.0.282-librca
```

## Update Alternatives for Java Executables

Review available Java installations and select Java 8 as the default option. Applies only to Java versions installed using the system package manager (`apt`or `yum`).

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
