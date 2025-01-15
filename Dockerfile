ARG ACME_VERSION=latest
FROM neilpang/acme.sh:${ACME_VERSION}

RUN apk --no-cache add bash && sed -i 's|/bin/ash|/bin/bash|' /etc/passwd
SHELL ["/bin/bash", "-c"]

COPY scripts /myacme

ENV PATH="${PATH}:/myacme/bin" 
RUN mv /myacme/entrypoint.sh /entrypoint.sh && chmod +x /entrypoint.sh && \
    mv /myacme/healthcheck.sh /healthcheck.sh && chmod +x /healthcheck.sh

WORKDIR /myacme/issues
ENTRYPOINT ["/entrypoint.sh"]
HEALTHCHECK --interval=60s --timeout=30s --start-period=5s --retries=3 CMD [ "/healthcheck.sh" ]
