# Collectory

## Setup

### Config and data directory
Create data directory at `/data/collectory` and populate as below (it is easiest to symlink the config files to the ones in this repo):
```
mats@xps-13:/data/collectory$ tree 
.
├── config
│   ├── charts.json -> /home/mats/src/biodiversitydata-se/collectory/sbdi/data/config/charts.json
│   ├── collectory-config.properties -> /home/mats/src/biodiversitydata-se/collectory/sbdi/data/config/collectory-config.properties
│   ├── connection-profiles.json -> /home/mats/src/biodiversitydata-se/collectory/sbdi/data/config/connection-profiles.json
│   └── default-gbif-licence-mapping.json -> /home/mats/src/biodiversitydata-se/collectory/sbdi/data/config/default-gbif-licence-mapping.json
└── data
    ├── images
    │   ├── dataResource
    │   └── institution
    ├── sitemap
    └── upload
        └── tmp
```

### Database
An empty database will be created the first time the application starts. You can then export the database from production using `mysqldump` and import it.

To get uploaded images you also need to copy some data directories.
```
cd /data/collectory
rsync live-manager-1:/docker_nfs/var/volumes/data_collectory/data/institution data/ -r
rsync live-manager-1:/docker_nfs/var/volumes/data_collectory/data/dataResource data/ -r
rsync live-manager-1:/docker_nfs/var/volumes/data_collectory/upload . -r
```

## Usage
Run locally:
```
make run
```

Build and run in Docker (using Tomcat). This requires a small change in the config file to work. See comment in Makefile.
```
make run-docker
```

Make a release. This will create a new tag and push it. A new Docker container will be built on Github.
```
mats@xps-13:~/src/biodiversitydata-se/collectory (master *)$ make release

Current version: 1.0.1. Enter the new version (or press Enter for 1.0.2): 
Updating to version 1.0.2
Tag 1.0.2 created and pushed.
```
