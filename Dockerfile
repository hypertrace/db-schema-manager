FROM eclipse-temurin:11-jre-jammy

ARG LIQUIBASE_VERSION=4.17.1

RUN apt update && \
    apt upgrade -y && \
    apt install curl -y && \
    mkdir /opt/liquibase && \
    cd /opt/liquibase && \
    curl -L https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz | tar -xzf- && \
    rm -rf /var/lib/apt/lists/*

# fix for CVE-2022-41853
# remove it after hsqldb library version is upgraded in liquibase
RUN rm /opt/liquibase/internal/lib/hsqldb.jar && \
    curl -Lo /opt/liquibase/internal/lib/hsqldb.jar https://repo1.maven.org/maven2/org/hsqldb/hsqldb/2.7.1/hsqldb-2.7.1.jar && \
    chown 1001:121 /opt/liquibase/internal/lib/hsqldb.jar

ENV LIQUIBASE_HOME /opt/liquibase

ENTRYPOINT ["/opt/liquibase/liquibase"]
