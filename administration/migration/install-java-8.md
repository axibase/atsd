# Install Java 8

Switch to `root` or execute the below steps under a user with `sudo` privileges.

## OpenJDK

* Ubuntu, Debian

```sh
apt-get install openjdk-8-jdk
```

In case of `Unable to locate package` error, install Oracle JDK.

* Red Hat Enterprise Linux, SLES, CentOS, Oracle Linux

```sh
yum install java-1.8.0-openjdk-devel
```

In case of `No package available` error, install Oracle JDK.

## Oracle JDK

Open the Oracle [Java 8 JDK](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) page.

Accept the license.

Copy the `Linux 64: *tar.gz` download link for Java SE Development Kit 8 into the `curl` command below.

```sh
curl -k -L -O -H "Cookie: oraclelicense=accept-securebackup-cookie" \
https://download.oracle.com/otn-pub/java/jdk/8u192-b12/750e1c8617c5452694857ad95c3ee230/jdk-8u192-linux-x64.tar.gz
```

Download the archive.

Expand the archive into the `/opt/jdk` directory.

```sh
mkdir /opt/jdk
```

```sh
tar -xzf jdk-8u192-linux-x64.tar.gz -C /opt/jdk
```

Add Oracle JDK to the java alternatives.

* Ubuntu, Debian

```sh
update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_192/bin/java 100
```

```sh
update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_192/bin/javac 100
```

* Red Hat Enterprise Linux, SLES, CentOS, Oracle Linux

```sh
alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_192/bin/java 100
```

```sh
alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_192/bin/javac 100
```

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
