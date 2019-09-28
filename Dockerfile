FROM node:10-alpine
MAINTAINER iam@lowiehuyghe.com

# Setup source code
WORKDIR /opt/ddns-name-com
COPY . .
RUN npm ci --only=production

# Setup cron
RUN echo '*/15  *  *  *  *    cd /opt/ddns-name-com && npm start' > /var/spool/cron/crontabs/root

# Data
ENV CONFIG /data/config.js
ENV TOKEN mytoken1234567890
VOLUME ["/data"]

# Run the command on container startup
CMD crond -l 2 -f
