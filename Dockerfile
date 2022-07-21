FROM openjdk:11-jre-slim

ENV LIQUIBASE_VERSION 4.13.0

RUN apt update && \
    apt install curl -y && \
    mkdir /opt/liquibase && \
    cd /opt/liquibase && \
    curl -L https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz | tar -xzf-

ENV LIQUIBASE_HOME /opt/liquibase

WORKDIR /opt/liquibase

ENTRYPOINT ["/opt/liquibase/liquibase"]
