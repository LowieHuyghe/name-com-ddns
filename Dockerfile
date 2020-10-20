FROM alpine:latest
MAINTAINER iam@lowiehuyghe.com

# Setup source code
WORKDIR /opt/ddns-name-com
COPY ./src ./src/
COPY ./run.sh ./
RUN ls /opt/ddns-name-com/src
RUN ls /opt/ddns-name-com/run.sh

# Install jq
RUN apk add --no-cache jq

# Setup cron
RUN echo '*/15  *  *  *  *    cd /opt/ddns-name-com && ./run.sh > /dev/null' > /var/spool/cron/crontabs/root

# Run the command on container startup
CMD crond -f -l 9
