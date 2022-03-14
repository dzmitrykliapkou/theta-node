FROM ubuntu:bionic

RUN set -eux; \
    apt-get update; \
    apt-get install -y gosu curl; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    # Verify that gosu binary works
    gosu nobody true

RUN groupadd --gid 1234 theta; \
    useradd --uid 1234 --gid 1234 theta

RUN mkdir -p /theta_mainnet/bin /theta_mainnet/guardian_mainnet/node; \
    curl -k --output /theta_mainnet/bin/theta `curl -k 'https://mainnet-data.thetatoken.org/binary?os=linux&name=theta'`; \
    curl -k --output /theta_mainnet/guardian_mainnet/node/config.yaml `curl -k 'https://mainnet-data.thetatoken.org/config?is_guardian=true'`; \
    chmod +x /theta_mainnet/bin/theta

RUN curl -k --output /theta_mainnet/bin/thetacli `curl -k 'https://mainnet-data.thetatoken.org/binary?os=linux&name=thetacli'`; \
    chmod +x /theta_mainnet/bin/thetacli

ENV PATH="/theta_mainnet/bin/:${PATH}"

VOLUME ["/theta_mainnet/guardian_mainnet/node"]

EXPOSE 30001 16888

COPY docker-entrypoint.sh docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["theta", "--help"]
