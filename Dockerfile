FROM alpine:latest
MAINTAINER iam@lowiehuyghe.com

# Setup source code
WORKDIR /opt/name-com-ddns
COPY ./src ./src/
COPY ./run.sh ./
RUN ls /opt/name-com-ddns/src
RUN ls /opt/name-com-ddns/run.sh

# Install dependencies
RUN apk add --no-cache \
  curl \
  jq

# Setup cron
RUN echo '*/15  *  *  *  *    cd /opt/name-com-ddns && ./run.sh > /dev/null' > /var/spool/cron/crontabs/root

# Run the command on container startup
CMD crond -f -l 9
