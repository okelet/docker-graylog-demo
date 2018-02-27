FROM ubuntu:artful

COPY docker-entrypoint.sh /

RUN set -ex \  
    && apt-get update -qq && \
    apt-get install -y -qq \
    netcat-openbsd curl

ENTRYPOINT ["bash", "/docker-entrypoint.sh"]
