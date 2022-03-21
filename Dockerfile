FROM golang:1.17-buster AS build-setup

RUN apt-get update
RUN apt-get -y install cmake zip sudo git

ENV FLOW_DPS_REPO="https://github.com/dapperlabs/flow-dps"
ENV FLOW_DPS_BRANCH=v0.24

ENV FLOW_DPS_DOCKER_REPO="https://github.com/chaen-foundry/flow-dps-docker"
ENV FLOW_DPS_ROSETTA_DOCKER_BRANCH=master

ENV FLOW_GO_REPO="https://github.com/onflow/flow-go"
ENV FLOW_GO_BRANCH=v0.24.7

RUN mkdir /dps /docker /flow-go

WORKDIR /dps

# clone repos and create links
RUN git clone --branch $FLOW_DPS_BRANCH $FLOW_DPS_REPO /dps
RUN git clone --branch $FLOW_DPS_ROSETTA_DOCKER_BRANCH $FLOW_DPS_DOCKER_REPO /docker
RUN git clone --branch $FLOW_GO_BRANCH $FLOW_GO_REPO /flow-go

RUN ln -s /flow-go /dps/flow-go

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build  \
    make -C /flow-go crypto/relic/build #prebuild crypto dependency

FROM build-setup AS build-live

WORKDIR /dps
RUN  --mount=type=cache,target=/go/pkg/mod \
     --mount=type=cache,target=/root/.cache/go-build  \
     go build -o /dps-live-index -tags relic -ldflags "-extldflags -static" ./cmd/flow-dps-live && \
     chmod a+x /dps-live-index

## Add the statically linked binary to a distroless image
FROM ubuntu:latest AS production

RUN apt-get update
RUN apt-get -y install supervisor wget

COPY --from=build-live /dps-live-index /bin/dps-live-index

COPY --from=build-setup /docker/supervisord.conf /supervisord.conf
COPY --from=build-setup /docker/common.sh /common.sh
COPY --from=build-setup /docker/run.sh /run.sh

RUN chmod a+x /run.sh

EXPOSE 8099

CMD ["bash", "-x", "/run.sh"]