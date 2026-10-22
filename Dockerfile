FROM ubuntu:24.04@sha256:68ee22004a9109b44973313b02ff7b1de250f1de0f5ecb628d73f579aaff33ac

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        iproute2 \
        iputils-ping \
    && rm -rf /var/lib/apt/lists/*

CMD ["sleep", "infinity"]
