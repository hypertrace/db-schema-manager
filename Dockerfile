FROM eclipse-temurin:11-jre-jammy

ARG LIQUIBASE_VERSION=4.17.0

RUN apt update && \
    apt upgrade -y && \
    apt install curl -y && \
    mkdir /opt/liquibase && \
    cd /opt/liquibase && \
    curl -L https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz | tar -xzf-

# fix for CVE-2022-42889
# remove it after commons-text library version is upgraded in liquibase
RUN rm /opt/liquibase/internal/lib/opencsv.jar && \
    rm /opt/liquibase/internal/lib/commons-text.jar && \
    curl -Lo /opt/liquibase/internal/lib/opencsv.jar https://repo1.maven.org/maven2/com/opencsv/opencsv/5.7.0/opencsv-5.7.0.jar && \
    curl -Lo /opt/liquibase/internal/lib/commons-text.jar https://repo1.maven.org/maven2/org/apache/commons/commons-text/1.10.0/commons-text-1.10.0.jar && \
    chown 1001:121 /opt/liquibase/internal/lib/opencsv.jar /opt/liquibase/internal/lib/commons-text.jar

ENV LIQUIBASE_HOME /opt/liquibase

ENTRYPOINT ["/opt/liquibase/liquibase"]
