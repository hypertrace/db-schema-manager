plugins {
  id("org.hypertrace.ci-utils-plugin") version "0.3.0"
  id("org.hypertrace.docker-plugin") version "0.9.4"
  id("org.hypertrace.docker-publish-plugin") version "0.9.4"
}

hypertraceDocker {
  defaultImage {
    imageName.set("liquibase")
  }
}
