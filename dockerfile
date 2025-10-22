FROM adobecoldfusion/coldfusion:latest-2023

COPY mysql-connector-j-8.0.32.jar /opt/coldfusion/cfusion/lib/mysql-connector-j-8.0.32.jar

# Expose MySQL port
EXPOSE 3333


# Install MySQL server and client
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install mysql-server mysql-client


# Create testdb database
RUN service mysql start


