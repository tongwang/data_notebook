FROM jupyter/datascience-notebook

USER root

# install PostgreSQL 9.6
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y postgresql-9.6 && \
    /etc/init.d/postgresql start && \
    sudo -u postgres createuser jovyan -s

# install csvkit
RUN pip install csvkit ipython-sql psycopg2

# install nbstripout which strips outputs from Jupyter notebooks
RUN pip install nbstripout

# install nbgrader and its extensions
RUN pip install nbgrader
RUN jupyter nbextension install --sys-prefix --py nbgrader --overwrite
RUN jupyter nbextension enable --sys-prefix --py nbgrader
RUN jupyter serverextension enable --sys-prefix --py nbgrader

# install Spark
RUN echo 'deb http://ftp.de.debian.org/debian jessie-backports main' >> /etc/apt/sources.list && \
    apt-get update && \
    apt install -y -t jessie-backports  openjdk-8-jre-headless ca-certificates-java && \
    wget --directory-prefix /tmp https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz && \
    tar -xf /tmp/spark-2.2.0-bin-hadoop2.7.tgz -C /tmp && \
    rm /tmp/spark-2.2.0-bin-hadoop2.7.tgz && \
    mv /tmp/spark-2.2.0-bin-hadoop2.7 /opt/spark-2.2.0-bin-hadoop2.7 && \
    ln -s /opt/spark-2.2.0-bin-hadoop2.7 /opt/spark

RUN pip install findspark

RUN apt-get install -y less parallel

# Spark config
ENV SPARK_HOME /opt/spark