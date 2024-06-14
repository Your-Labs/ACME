ARG BASE=neilpang/acme.sh:latest

FROM $BASE

RUN apk --no-cache add -f bash

ENV ACME_CERTS=/certs \
    DNS_PROVIDER=dns_cf \
    INCLUDE_WILDCARD=true \
    FUNCTIONS_DIR=/functions \
    SOURCES_FILE="/sources.sh"

RUN mkdir -p $ACME_CERTS && \
    mkdir -p /reload

ADD scripts /

WORKDIR /reload
ENTRYPOINT ["/entrypoint.sh"]
HEALTHCHECK --interval=60s --timeout=30s --start-period=5s --retries=3 CMD [ "/healthcheck.sh" ]
