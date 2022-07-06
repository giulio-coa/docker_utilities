# Guide to use these Docker utilities for MongoDB

# Contents
* [Files](#files)
  - [.env](#env)
  - [dump.sh](#dumpsh)
  - [restore.sh](#restoresh)

# Files
## .env
This file provides the enviroment variables to the Shell scripts.

## dump.sh
This file provides the Shell script to dump a database as `bzip2` file.

## restore.sh
This file provides the Shell script to restore a database from a `bzip2` file.
**N.B.**: If you want use a dump of the database that is on localhost, you must run this command before using the restore script.
```
docker cp "${LOCALHOST_PATH_TO_THE_BZIP}/dump.tar.bz2" "container-${NAME_OF_DB_SERVICE}:${DOCKER_PATH_TO_THE_BZIP}/dump.tar.bz2"
```
