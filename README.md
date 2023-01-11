# Overview

Discord TTL is a simple Discord bot that protects privacy by deleting all server messages older than a given TTL (time-to-live). You can
find a live version of this bot running at https://discord.gg/ayu

Currently, Discord TTL is meant to be self-hosted. If you would like to set it up for your server, follow the steps below!


# Steps to self-host

## If you know what you're doing
To get started, clone this repository and install [Docker](https://docs.docker.com/engine/install/ubuntu/) 
& [Docker Compose](https://docs.docker.com/compose/install/). Then, populate a new `.env` file with a `DISCORD_BOT_TOKEN` 
from the [Discord Dev Portal](https://discord.com/developers/applications). You can find an example of this in the 
[`.env.example` on GitHub](https://github.com/ayubun/discord-ttl/blob/main/.env.example). Finally, you can start Discord TTL with Docker Compose:
```
docker-compose up -d
```

## If you are new to self-hosting
Firsly, I am happy that you are looking to expand your knowledge into this domain! To get started, you'll want a server to host your bot on.
If you already have one, that's great! For my own sanity, this tutorial will only cover the steps to setting up an Ubuntu
server, but it is possible to get Discord TTL running on any OS, so long as you can install 
[Docker](https://docs.docker.com/engine/install/ubuntu/) & [Docker Compose](https://docs.docker.com/compose/install/).

If you don't have a VPS yet, you can find them all over the internet :D If you need a recommendation, GalaxyGate's Standard 1GB offers a 
perfectly-capable $3/month option that might be within budget for most: https://galaxygate.net/hosting/vps/

Once you have a VPS, you have the option of running the one-line install command made specifically for Discord TTL. This command **will only
work on Ubuntu**. It will install Docker & Docker Compose, setup your `.env` file (you'll need to put your own Discord bot token from the
[Discord Dev Portal](https://discord.com/developers/applications) still), and setup an auto-updater script:
```
curl -o- https://raw.githubusercontent.com/ayubun/discord-ttl/main/install.sh | bash
```
If you do not want the auto-updater, you can run the following command instead:
```
curl -o- https://raw.githubusercontent.com/ayubun/discord-ttl/main/install.sh | bash -s -- --skip-auto-updater
```
**Note:** This script will clean any Docker / Docker Compose installations already on your system to install fresh ones. If you
already have Docker / Docker Compose and would like to avoid this, you can run the install script with the following flags:
```
curl -o- https://raw.githubusercontent.com/ayubun/discord-ttl/main/install.sh | bash -s -- --skip-docker --skip-docker-compose
```



