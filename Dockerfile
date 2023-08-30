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

ENV DOCKERIZE_VERSION v0.7.0

RUN apt-get update \
    && apt-get install -y wget \
    && wget -O - https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz | tar xzf - -C /usr/local/bin \
    && apt-get autoremove -yqq --purge wget && rm -rf /var/lib/apt/lists/*
