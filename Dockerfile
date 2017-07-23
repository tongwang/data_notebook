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
