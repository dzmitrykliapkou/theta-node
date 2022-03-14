# Theta Guardian Node dockerized

This repository contains files to build and run a Docker image for Theta blockchain [Guardian Node](https://docs.thetatoken.org/docs/guardian-node-overview)

## How to use

1. Clone the repository and build the image:
    ```bash
    docker build .
    ```

2. Prepare a directory to store Theta blockchain data. Let's call it `/data`. Download [Theta configuration](https://mainnet-data.thetatoken.org/config?is_guardian=true) and [Theta snapshot](https://mainnet-data.thetatoken.org/snapshot) files and put them into the `/data` directory. You'll need to mount `/data` directory to the Theta container later

3. Modify any values in the Theta configuration file according to your needs

4. Run Theta node using Docker:
    ```bash
    docker run -d -v /data:/theta_mainnet/guardian_mainnet/node <IMAGE> theta start --config=/theta_mainnet/guardian_mainnet/node --password=<SOME_STRONG_PASSWORD>
    ```
    When the Theta node launches for the first time, you need to choose a password to encrypt the signing key of the guardian node. Please choose a secure password and keep it in a safe place. The next time when you restart the node, you will need the password to unlock it.

    It might take some time for the node to sync up with the network

## Running a node with docker-compose

To run a Theta node you can use the following `docker-compose.yaml` example:

```yaml
---
version: '3'
services:
  theta-node:
    image: <THETA_NODE_IMAGE>
    container_name: theta-node
    restart: unless-stopped
    command:
      - "theta"
      - "start"
      - "--config=/theta_mainnet/guardian_mainnet/node"
      - "--password"
      - "<SOME_STRONG_PASSWORD>"
    network_mode: host
    volumes:
      - /data:/theta_mainnet/guardian_mainnet/node
    ulimits:
      nofile: 4096
    stop_signal: SIGINT
    stop_grace_period: 2m
    logging:
      driver: "json-file"
      options:
        max-size: "2m"
        max-file: "10"
```

## TBD - rpc-adapter
