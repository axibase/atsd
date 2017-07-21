#!/bin/bash

SCRIPT=$(readlink -f $0)
DISTR_HOME="`dirname $SCRIPT`/.."
PIDDIR="`readlink -f ${DISTR_HOME}/pids`"
JAVA_DISTR_HOME="/usr/lib/jvm/java-1.7.0-openjdk-amd64" 
JPS="${JAVA_DISTR_HOME}/bin/jps"
DFS_START="`readlink -f ${DISTR_HOME}/hadoop/sbin/start-dfs.sh`"
DFS_STOP="`readlink -f ${DISTR_HOME}/hadoop/sbin/stop-dfs.sh`"
HADOOP="`readlink -f ${DISTR_HOME}/hadoop/bin/hadoop`"
LOGFILESTART="`readlink -f ${DISTR_HOME}/atsd/logs/start.log`"
LOGFILESTOP="`readlink -f ${DISTR_HOME}/atsd/logs/stop.log`"
HBASE_SITE="`readlink -f ${DISTR_HOME}/hbase/conf/hbase-site.xml`"
HDFS_SITE="`readlink -f ${DISTR_HOME}/hadoop/conf/hdfs-site.xml`"
command=""

function logger {
    if [ "$command" = "stop" ]; then
        logfile="$LOGFILESTOP"
    else
        logfile="$LOGFILESTART"
    fi
    echo " * [ATSD] $1" | tee -a $logfile
}

# hadoop components: DataNode, NameNode, SecondaryNameNode
# hbase components: HRegionServer, HMaster, HQuorumPeer

if [ ! -x "$DFS_START" ]; then
	logger "no HDFS startup file found: $DFS_START"
	exit 1
fi

dfs_user=`stat -c %U "$DFS_START"`

if [ "`whoami`" != "$dfs_user" ]; then
    echo "Current user: `whoami`. Expecting user: $dfs_user. User mismatch, switching user to $dfs_user."
	su -c "$SCRIPT $1 $2" "$dfs_user"
	exit $?
fi

if [ ! -d ${JAVA_DISTR_HOME} ]; then
    exit 1
fi

storageDriver="`awk 'f{print;f=0} /<name>hbase.rootdir<\/name>/{f=1}' $HBASE_SITE`"
regexp='.*<value>hdfs://.*</value>.*'
if ! [[ "$storageDriver" =~ $regexp ]]; then
    logger "Hbase is configured to start without HDFS. Skipping HDFS start."
    exit 0
fi

function start_dfs {
    "$DFS_START" >> $LOGFILESTART
	SAFEMODE_WAIT=16
	SAFEMODE_WAIT_STOP=20
	CHECK_PERIOD=10
	safemode_off='false'
    off_by_hand="false"
    dfs_off="false"
	logger "Checking HDFS safemode ..."
	i=0
	while [ "$i" -le "$SAFEMODE_WAIT_STOP" ]; do
		if [ "$i" -eq "$SAFEMODE_WAIT" ]; then
			logger "Exiting safemode forcefully"
			"$HADOOP" dfsadmin -safemode leave
			off_by_hand="true"
		fi
		response="`$HADOOP dfsadmin -safemode get 2>&1`"
		if [ "" != "`echo $response | grep "Safe mode is OFF"`" ]; then
			safemode_off='true'
		    logger "safemode is off."
			break;
		fi
		#if [ "Bad connection to DFS..." = "`echo $response | grep -o "Bad connection to DFS..."`" ]; then
		if [ `echo $response | grep -q "Bad connection to DFS..."` ]; then
		    if [ $i -eq 3 ]; then
		        dfs_off="true"
		        break;
		    fi
		fi
		logger "Waiting $CHECK_PERIOD seconds for HDFS to exit safemode.($i of $SAFEMODE_WAIT_STOP)"
		sleep "$CHECK_PERIOD"
		i=$[$i+1]
	done
    if [ "${dfs_off}" = "true" ]; then
        logger "Fail to connect to HDFS."
        return 1
    fi

	if [ "$safemode_off" = 'false' ]; then
		logger "HDFS is still in safemode."
		safemode_state=`$HADOOP dfsadmin -safemode get`
		logger "Safemode state: $safemode_state"
		logger "Exit."
		return 1
	fi
	
	logger "Checking HDFS for corrupted files ..."
	if [ "$off_by_hand" = "true" ]; then
	    "$HADOOP" fsck /hbase/ -openforwrite -files >> $LOGFILESTART
	    fsck_corrupt=`"$HADOOP" fsck /hbase/ -openforwrite -files | grep "Status: CORRUPT"`
	else
	    "$HADOOP" fsck /hbase/.logs/ -openforwrite -files >> $LOGFILESTART
	    fsck_corrupt=`"$HADOOP" fsck /hbase/.logs/ -openforwrite -files | grep "Status: CORRUPT"`
	fi

	if [ "" != "$fsck_corrupt" ]; then
	    if [ "$off_by_hand" = "true" ]; then
		    logger "Filesystem under path '/hbase/' is corrupted. Deleting /hbase/.logs"
	    else
		    logger "Filesystem under path '/hbase/.logs' is corrupted. Deleting /hbase/.logs"
	    fi
		"$HADOOP" fs -rmr -skipTrash /hbase/.logs/*
	    logger "Checking HDFS for corrupted files again ..."
	    "$HADOOP" fsck /hbase/.logs/ -openforwrite -files >> $LOGFILESTART
	    fsck_corrupt=`"$HADOOP" fsck /hbase/.logs/ -openforwrite -files | grep "Status: CORRUPT"`
	    if [ "" != "$fsck_corrupt" ]; then
	        logger "Corrupted files could not be deleted from HDFS"
	    else
	        logger "Corrupted files deleted from HDFS"
	        fsck_corrupt_all=`"$HADOOP" fsck /hbase/ -openforwrite -files | grep "Status: CORRUPT"`
	        if [ "" != "$fsck_corrupt_all" ]; then
	            logger "HDFS contains corrupted files in /hbase directory"
	            "$HADOOP" fsck /hbase/ -openforwrite -files >> $LOGFILESTART
				id_data_name_file="`awk -F "[<>]" 'f{print $3;f=0} /<name>dfs.name.dir<\/name>/{f=1}' ${HDFS_SITE}`/current/VERSION"
				id_data_file="`awk -F "[<>]" 'f{print $3;f=0} /<name>dfs.data.dir<\/name>/{f=1}' ${HDFS_SITE}`/current/VERSION"
				id_data_name=`grep namespaceID ${id_data_name_file}`
				id_data=`grep namespaceID ${id_data_file}`
				logger "$id_data_name_file: $id_data_name $id_data_file: $id_data"
	            return 1
	        fi
	    fi
	else
	    logger "No corrupted files in directory /hbase/.logs/ found."
	fi
	logger "Checking HDFS availability ..."
	"$HADOOP" fs -ls / > /dev/null
	if [ $? -ne 0 ]; then
		logger "HDFS is not available."
		return 1
    else
        logger "HDFS is available."
	fi
}

#return 0 if no process, 1 if some process finded
function clear_pids {
    pidfiles="`ls $PIDDIR | grep "^hadoop-.*\.pid"`"
	jps_output=`"$JPS" | grep "^[0-9]\+\ \+\(DataNode$\|NameNode$\|SecondaryNameNode$\)"`
	stopped="true"
    for file in $pidfiles; do
    	pid="`cat $PIDDIR/$file`"
    	if [ "`echo $jps_output | grep $pid`" = "" ]; then
    	    rm -f $PIDDIR/$file
    	else
    	    stopped="false"
    	fi
    done
    if [ "$stopped" = "true" ]; then
        return 0
    else
        return 1
    fi
}

#return 0 if all processes are started
function check_hdfs_is_started {
    if [ "" = "`$JPS | awk '{print $2}' | grep "^DataNode$"`" ]; then
        logger "DataNode is not running."
        return 1
    fi
    if [ "" = "`$JPS | awk '{print $2}' | grep "^NameNode$"`" ]; then
        logger "NameNode is not running."
        return 1
    fi
    if [ "" = "`$JPS | awk '{print $2}' | grep "^SecondaryNameNode$"`" ]; then
        logger "SecondaryNameNode is not running."
        return 1
    fi
    return 0
}

#return 0 if hsperfdata_owner equals with dfs_user
function check_hsperfdata_owner {
    tmpdir_owner=`stat -c %U /tmp/hsperfdata_$dfs_user`
    jps_processes_count=`$JPS | wc -l`
    if [[ "$jps_processes_coun" -le 1 ]] && [ "$dfs_user" != "$tmpdir_owner" ]; then
        logger "Java tmpdir folder owner mismatch. Expecting user: $dfs_user, current owner: $tmpdir_owner."
        return 1
    fi
    return 0
}

#return 0 if all processes are stopped
function check_hdfs_is_stopped {
    eCode=0
    if [ "" != "`$JPS | awk '{print $2}' | grep "^DataNode$"`" ]; then
        logger "DataNode is running."
        eCode=1
    fi
    if [ "" != "`$JPS | awk '{print $2}' | grep "^NameNode$"`" ]; then
        logger "NameNode is running."
        eCode=1
    fi
    if [ "" != "`$JPS | awk '{print $2}' | grep "^SecondaryNameNode$"`" ]; then
        logger "SecondaryNameNode is running."
        eCode=1
    fi
    if [ $eCode -eq 1 ]; then
        logger "jps output:"
        logger "`$JPS`"
    fi
    return $eCode
}

function stop_dfs {
    logger "Stopping HDFS processes with $DFS_STOP ..."
	"$DFS_STOP" >> $LOGFILESTOP
    sleep 3
    logger "HDFS stop script completed."
}

function print_status {
	jps_output=`"$JPS" | grep "^[0-9]\+\ \+\(DataNode$\|NameNode$\|SecondaryNameNode$\)"`
	echo "____________"
	if [ "" != "$jps_output" ]; then
	    echo "HDFS status:"
	    if echo $jps_output | grep -q "DataNode"; then
	        echo "DataNode: ON"
	    else
	        echo "DataNode: OFF"
	    fi
	    if echo $jps_output | grep -q "NameNode"; then
	        echo "NameNode: ON"
	    else
	        echo "NameNode: OFF"
	    fi
	    if echo $jps_output | grep -q "SecondaryNameNode"; then
	        echo "SecondaryNameNode: ON"
	    else
	        echo "SecondaryNameNode: OFF"
	    fi
	    echo "Report:"
	    $HADOOP dfsadmin -report
	    echo "FSCK:"
	    $HADOOP fsck /hbase/ -openforwrite
	else
		echo "All HDFS processes are stopped."
	fi
}

case "$1" in
  start   )
            command="start"
            logger "Starting HDFS ..."
			check_hdfs_is_stopped
			if [ $? -eq 1 ]; then
			    check_hdfs_is_started
			    if [ $? -eq 1 ]; then
			    	logger "HDFS is not fully started."
			    	exit 1
			    fi
				logger "HDFS is already running."
				exit 0
			fi
			clear_pids
			start_dfs
			if [ $? -ne 0 ]; then
				logger "Can't start HDFS."
				exit 1
			fi
			check_hdfs_is_started
			if [ $? -eq 1 ]; then
				logger "Can't start HDFS."
				check_hsperfdata_owner
				exit 1
			fi
			logger "HDFS started."
			exit 0
			;;
  stop    )
            command="stop"
            logger "Stopping HDFS ..."
            check_hdfs_is_stopped
			if [ $? -eq 0 ]; then
				logger "HDFS already stopped."
				exit 0
            fi
			stop_dfs
            check_hdfs_is_stopped
			if [ $? -eq 1 ]; then
				logger "Some HDFS components were not stopped. Examine the state of the following components: DataNode, NameNode, SecondaryNameNode."
				exit 1
			fi
			logger "HDFS stopped."
			exit 0
			;;
  status    )
			print_status
			exit 0
			;;
  *       ) echo "usage: $0 start | stop | status"
			exit 1
			;;
esac
