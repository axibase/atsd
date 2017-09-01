# Installation on AWS HBase S3

## Overview

Axibase Time Series Database can be deployed on HBase using [AWS S3](http://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-hbase-s3.html) as the underlying file system.

This installation option simplifies backup and recovery in addition to right-sizing the HBase cluster based on CPU and memory demands, as opposed to storage requirements.

## Mini-cluster

The smallest cluster size for testing and development is two EC2 instances, one of which can be shared by the HBase Master and ATSD.

## Create Cluster Configuration File

This configuration enables S3 storage mode with a [consistent view](http://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-plan-consistent-view.html), and specifies the full path to the HBase root directory in S3.


```sh
nano emr-atsd.json
```

```json
[
   {
     "Classification": "hbase",
     "Properties": {
       "hbase.emr.storageMode": "s3"
     }
   },
   {
     "Classification": "emrfs-site",
     "Properties": {
       "fs.s3.consistent": "true"
     }
   },
   {
     "Classification": "hbase-site",
     "Properties": {
       "hbase.rootdir": "s3://atsd/hbase-root"
     }
   }   
]
```

## Create S3 Bucket

The S3 bucket must be created prior to installation.  The bucket, named `atsd` in the example below, will store the HBase root directory including metadata and data files.

```sh
aws s3 mb s3://atsd
```

The HBase root directory will be created if necessary when the cluster is started for the first time. It will be not deleted when the cluster is stopped or terminated.

If the HBase root directory already exists, you can list the files for verification.

```sh
aws s3 ls --summarize --human-readable --recursive s3://atsd
```

## Download Distribution Files

```sh
curl -o atsd-cluster.tar.gz https://axibase.com/public/atsd-cluster.tar.gz
```

```sh
tar -xvf atsd-cluster.tar.gz atsd/atsd-hbase*jar
```

## Upload ATSD Co-processor File to S3

The `atsd-hbase.$REVISION.jar` file contains ATSD co-processors and filters.

By storing the jar file in S3, one makes Java classes in this file automatically available to all region servers when they are started.

```sh
aws s3 cp atsd/atsd-hbase.*.jar s3://atsd/hbase-root/lib/atsd-hbase.jar
```

Verify that the jar file is stored in S3:

```sh
aws s3 ls --summarize --human-readable --recursive s3://atsd/hbase-root/lib
```

```
  2017-08-31 21:43:24  555.1 KiB hbase-root/lib/atsd-hbase.jar

  Total Objects: 1
    Total Size: 555.1 KiB
```

The `atsd-hbase.jar` should be stored in a directory identified by the `hbase.dynamic.jars.dir` setting in HBase. By default this directory resolves to `hbase.rootdir/lib`.

> When uploading the jar file to the `hbase.rootdir/lib` directory, the revision is removed to avoid changing the `coprocessor.jar` setting in ATSD when the jar file is replaced.

## Launch Cluster

Copy the launch command into an editor.

```sh
export CLUSTER_ID=$(            \
aws emr create-cluster          \
--name "ATSD HBase"             \
--applications Name=HBase       \
--release-label emr-5.3.1       \
--output text                   \
--use-default-roles             \
--ec2-attributes KeyName=<key-name>,SubnetId=<subnet>  \
--instance-groups               \
  Name=Master,InstanceCount=1,InstanceGroupType=MASTER,InstanceType=m4.large        \
  Name=RegionServers,InstanceCount=3,InstanceGroupType=CORE,InstanceType=m4.large   \
--configurations file://emr-atsd.json         \
)
```

Replace `<key-name>` and `<subnet>` parameters.

The `<key-name>` parameter corresponds to the name of the private key used to login into cluster nodes.

The `<subnet>` parameter is required when launching particular instance types. To find out the correct subnet for your account, you can launch a sample cluster manually in the AWS EMR console and lookup the settings using AWS CLI export.

![](images/aws-cli-export.png "AWS CLI export")

Adjust EC2 instance types and the total instance count for the `RegionServers` group as appropriate. Review [AWS documentation](http://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-gs-launch-sample-cluster.html) for additional commands.

Execute the launch command.

## Verify HBase Status

### Login into Master Node

Monitor the cluster status until the bootstrapping process is complete.

```sh
watch 'aws emr describe-cluster --cluster-id $CLUSTER_ID | grep MasterPublic | cut -d "\"" -f 4'
```

Determine the public IP address of the HBase Master node.

```
export MASTER_IP=$(aws emr describe-cluster --cluster-id $CLUSTER_ID | grep MasterPublic | cut -d "\"" -f 4) ; echo $MASTER_IP
```

Specify the path to private ssh key and log in to the node.

```sh
ssh -i /path/to/<key-name>.pem hadoop@$MASTER_IP
```

Wait until HBase services are running on the HMaster node.

```sh
watch 'initctl list | grep hbase'
```

```
  hbase-thrift start/running, process 8137
  hbase-rest start/running, process 7842
  hbase-master start/running, process 7987
```

Verify HBase version (1.2.3+) and rerun the status command until the cluster becomes operational.


```sh
echo "status" | hbase shell
```

Wait until the error `Server is not running yet` disappears.

```

```

## Install ATSD

Log in to the server where ATSD will be installed (HMasted node in case of mini-cluster).

```sh
ssh -i /path/to/<key-name>.pem ec2-user@$PUBLIC_IP
```

Change to a volume with at least 10GB of available disk space.

```sh
df -h
```

```sh
cd /mnt
```

Download the ATSD distribution files.

```sh
curl -o atsd-cluster.tar.gz https://axibase.com/public/atsd-cluster.tar.gz
```

```sh
tar -xvf atsd-cluster.tar.gz
```

Set Path to Java 8 in the ATSD start script.

```sh
JP=`dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"`; sed -i "s,^export JAVA_HOME=.*,export JAVA_HOME=$JP,g" atsd/atsd/bin/start-atsd.sh ; echo $JP
```

Set Path to ATSD coprocessor file.

```sh
echo "coprocessors.jar=s3://atsd/hbase-root/lib/atsd-hbase.jar" >> atsd/atsd/conf/server.properties
```

If installing on a server such as HBase master where ports 8081, 8082, 8084, 8088, 8443 are taken, replace default ATSD port numbers to 9081, 9082, 9084, 9088, 9443 respectively.

```sh
sed -i 's/80/90/g' atsd/atsd/conf/server.properties
sed -i 's/8443/9443/g' atsd/atsd/conf/server.properties
```

Check memory usage and increase ATSD JVM memory to 50% of total physical memory installed in the server, if available.

```sh
free
```

```sh
nano atsd/atsd/conf/atsd-env.sh
JAVA_OPTS="-server -Xmx4000M -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath="$atsd_home"/logs"
```

If the installation is performed on an instance other than HMaster Node, specify the HMaster private hostname with the `hbase.zookeeper.quorum` setting.

```sh
nano atsd/atsd/conf/hadoop.properties
```

```sh
hbase.zookeeper.quorum = 10.50.0.102
```

Start ATSD.

```sh
./atsd/atsd/bin/start-atsd.sh
```

Monitor the startup progress using the log file.

```
tail -f atsd/atsd/logs/atsd.log
```

This process may take several minutes to complete before ATSD is initialized:

```
ATSD start completed
```

Log in to the ATSD web interface on https://atsd_hostname:8443 or https://atsd_hostname:9443 if port settings were previously changed.

## Port Access

Make sure that the EC2 Security Group associated with the ATSD EC2 instance allows access to the ATSD listening ports. 

Edit security rules, if necessary, to open inbound access to these ports.

When launching ATSD in a mini-cluster, you can specify a specific security group with ATSD ports open for the Master node in the launch command:

```sh
export CLUSTER_ID=$(            \
aws emr create-cluster          \
--name "ATSD HBase"             \
--applications Name=HBase       \
--release-label emr-5.3.1       \
--output text                   \
--use-default-roles             \
--ec2-attributes KeyName=<key-name>,SubnetId=<subnet>,EmrManagedMasterSecurityGroup=<sg-master>,EmrManagedSlaveSecurityGroup=<sg-slave>  \
--instance-groups               \
  Name=Master,InstanceCount=1,InstanceGroupType=MASTER,InstanceType=m4.large        \
  Name=RegionServers,InstanceCount=1,InstanceGroupType=CORE,InstanceType=m4.large   \
--configurations file://emr-atsd.json         \
)
```
