## Installation Notes

This document describes the Windows MongoDB [replica sets](https://docs.mongodb.com/manual/replication/) installation and setup

### Reference

[Install MongoDB Community Edition on Windows](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-windows/)


### Preparation

The following components must be installed

- MongoDB version **3.4.0** or higher
- git with **bash support**

If you encounter  `missing api-ms-win-crt-runtime-l1-1-0.dll` you may need to install additional components.

see [this ](http://stackoverflow.com/questions/33265663/api-ms-win-crt-runtime-l1-1-0-dll-is-missing-when-opening-microsoft-office-file) for more information

### Path Setup

You must ensure that mongo command is available in your path

For example:

`set PATH=%PATH%;C:\Program Files\MongoDB\Server\3.4\bin`

### Installation

> Note: all bash commands must be run as **Administrator**. The `mongo`command must be run on a **cmd** or **powershell** prompt due to a bash tty bug

#### Environment Settings

|Variable|Usage|Default|Notes|
|--------|-----|-------|-----|
|RS_NAME|sets name of replica set| rs0| |
|MONGO_HOME|location of data, logs, etc| /e/mongo| will be created if it does not exist|
|MONGO_OPLOGSZ|oplog size| 100| size in MB|
|RS_MULTI|set up rs on single instance| false| use only for testing , **not** for production|
|RS_CLEANUP|clean up data and logs folder| false| use only for testing , **extreme caution** in production|

### Installing on multiple machines

This is the **recommended** setup.

You will run a **_single_** instance of a mongo replicaset on **each** machine.

Run the following command on **_each_** machine. You must set up an **odd** number of replicas. Set up at least **3** replicas

`init.sh`

### Install replicaset on a single machine

This setup will run the **entire** replicaset on a single machine.

This is **not** recommended for production environments since a failure of server will result in all replicas being unavailable


```

export RS_MULTI=true
init.sh

```

### Activate replicaset

The final step requires a script to be run in order to activate the replica sets

First you must create/edit the list of replica set hosts file `hosts.txt`

Add a line with each `host:port` for the replicaset

```

10.8.16.120:27017
10.8.16.121:27017
10.8.16.122:27017

```

run the script `initialize.sh`


### Verify replicaset

any replicaset instance run mongo command client

`mongo`

and type in the command `db.isMaster()`

you should get a result that looks like this

```
rs0:SECONDARY> db.isMaster();
{
        "hosts" : [
                "10.8.16.120:27017",
                "10.8.16.121:27017",
                "10.8.16.122:27017"
        ],
        "setName" : "rs0",
        "setVersion" : 1,
        "ismaster" : true,
        "secondary" : false,
        "primary" : "10.8.16.120:27017",
        "me" : "10.8.16.120:27017",
        "electionId" : ObjectId("7fffffff0000000000000001"),
        "lastWrite" : {
                "opTime" : {
                        "ts" : Timestamp(1486043539, 2),
                        "t" : NumberLong(1)
                },
                "lastWriteDate" : ISODate("2017-02-02T13:52:19Z")
        },
        "maxBsonObjectSize" : 16777216,
        "maxMessageSizeBytes" : 48000000,
        "maxWriteBatchSize" : 1000,
        "localTime" : ISODate("2017-02-02T13:52:22.612Z"),
        "maxWireVersion" : 5,
        "minWireVersion" : 0,
        "readOnly" : false,
        "ok" : 1
}
```

In particular, note the line

`"primary" : "10.8.16.120:27017",`

This is the address of the current primary

If the `db.isMaster()` command does not return a primary or there is some other error, you should
look at the mongo logs which will be found in the `/logs` folder which should provide additional
detail

## Troubleshooting

### `~/.mongorc.js`

```

rs.slaveOk();

```
