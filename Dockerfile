FROM tomcat:9.0-jdk11-temurin

RUN mkdir -p \
	/data/collectory/config \
	/data/collectory/data/taxa \
	/data/collectory/upload/tmp

COPY sbdi/data/config/charts.json /data/collectory/config/charts.json
COPY sbdi/data/config/connection-profiles.json /data/collectory/config/connection-profiles.json
COPY sbdi/data/config/default-gbif-licence-mapping.json /data/collectory/config/default-gbif-licence-mapping.json
COPY sbdi/data/data/taxa/taxa.json /data/collectory/data/taxa/taxa.json

COPY build/libs/collectory-4.0.0-plain.war $CATALINA_HOME/webapps/ROOT.war

# This is to install envsubst
RUN \
    apt-get update && \
    apt-get install -y gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
