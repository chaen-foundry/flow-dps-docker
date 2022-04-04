FROM golang:1.17-buster AS build-setup

RUN apt-get update
RUN apt-get -y install cmake zip sudo git

ENV FLOW_DPS_REPO="https://github.com/foundryservices/flow-dps"
ENV FLOW_DPS_BRANCH=v0.23

ENV FLOW_DPS_DOCKER_REPO="https://github.com/chaen-foundry/flow-dps-docker"
ENV FLOW_DPS_DOCKER_BRANCH=mainnet-15

ENV FLOW_GO_REPO="https://github.com/onflow/flow-go"
ENV FLOW_GO_BRANCH=v0.23.3

RUN mkdir /dps /docker /flow-go

WORKDIR /dps

# clone repos and create links
RUN git clone --branch $FLOW_DPS_BRANCH $FLOW_DPS_REPO /dps
RUN git clone --branch $FLOW_DPS_DOCKER_BRANCH $FLOW_DPS_DOCKER_REPO /docker
RUN git clone --branch $FLOW_GO_BRANCH $FLOW_GO_REPO /flow-go

RUN ln -s /flow-go /dps/flow-go

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build  \
    make -C /flow-go crypto/relic/build #prebuild crypto dependency

FROM build-setup AS build-restore-index

WORKDIR /dps
RUN  --mount=type=cache,target=/go/pkg/mod \
     --mount=type=cache,target=/root/.cache/go-build  \
     go build -o /restore-index-snapshot -ldflags "-extldflags -static" ./cmd/restore-index-snapshot && \
     chmod a+x /restore-index-snapshot

FROM build-setup AS build-server

WORKDIR /dps
RUN  --mount=type=cache,target=/go/pkg/mod \
     --mount=type=cache,target=/root/.cache/go-build  \
     go build -o /dps-server -ldflags "-extldflags -static" ./cmd/flow-dps-server && \
     chmod a+x /dps-server

## Add the statically linked binary to a distroless image
FROM ubuntu:latest AS production

RUN apt-get update
RUN apt-get -y install supervisor wget curl jq

COPY --from=build-restore-index /restore-index-snapshot /bin/restore-index-snapshot
COPY --from=build-server /dps-server /bin/dps-server

COPY --from=build-setup /docker/supervisord.conf /supervisord.conf
COPY --from=build-setup /docker/common.sh /common.sh
COPY --from=build-setup /docker/run.sh /run.sh

RUN chmod a+x /run.sh

EXPOSE 8080

CMD ["bash", "-x", "/run.sh"]