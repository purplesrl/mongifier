FROM centos/mongodb-32-centos7

USER root

RUN sed -i 's/--auth//' /usr/bin/run-mongod

USER mongodb
