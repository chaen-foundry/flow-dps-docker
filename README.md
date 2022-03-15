# Flow DPS Docker

`DOCKER_BUILDKIT=1 docker build --no-cache -t flow-mainnet16 .`

`docker run --mount type=bind,source=./data,target=/data -m 12g -p 8099:8099 flow-mainnet16`