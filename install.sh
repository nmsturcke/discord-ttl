#!/bin/bash

# =======
# Colors~
# =======
MOVE_UP=`tput cuu 1`
CLEAR_LINE=`tput el 1`
BOLD=`tput bold`
UNDERLINE=`tput smul`
RED_TEXT=`tput setaf 1`
GREEN_TEXT=`tput setaf 2`
YELLOW_TEXT=`tput setaf 3`
BLUE_TEXT=`tput setaf 4`
MAGENTA_TEXT=`tput setaf 5`
CYAN_TEXT=`tput setaf 6`
WHITE_TEXT=`tput setaf 7`
RESET=`tput sgr0`

# Flags logic
# Source: https://www.banjocode.com/post/bash/flags-bash
SKIP_CLONING=false
SKIP_DOCKER=false
SKIP_DOCKER_STRING=""
SKIP_DOCKER_COMPOSE=false
SKIP_DOCKER_COMPOSE_STRING=""
SKIP_AUTO_UPDATER=false
SKIP_AUTO_UPDATER_STRING=""
BASH_SUFFIX_STRING=""
while [ "$1" != "" ]; do
    case $1 in
    --skip-cloning || --skip-clone)
        SKIP_CLONING=true
        ;;
    --skip-docker)
        SKIP_DOCKER=true
        SKIP_DOCKER_STRING="--skip-docker "
        BASH_SUFFIX_STRING=" -s -- "
        ;;
    --skip-docker-compose)
        SKIP_DOCKER_COMPOSE=true
        SKIP_DOCKER_COMPOSE_STRING="--skip-docker-compose "
        BASH_SUFFIX_STRING=" -s -- "
        ;;
    --skip-auto-updater)
        SKIP_AUTO_UPDATER=true
        SKIP_AUTO_UPDATER_STRING="--skip-auto-updater "
        BASH_SUFFIX_STRING=" -s -- "
        ;;
    esac
    shift # remove the current value for `$1` and use the next
done


# OS check
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "${RESET}${RED_TEXT}[${BOLD}ERROR${RESET}${RED_TEXT}]${RESET}${BOLD}${YELLOW_TEXT} It looks like you are trying to run this script on a non-linux environment. Please note that this script is only designed for use on ${UNDERLINE}Ubuntu${RESET}${BOLD}${YELLOW_TEXT} servers.${RESET}" 
  exit 1
fi

# Clone logic
if ! test .git; then
  if [[ $SKIP_CLONING == false ]]; then
    echo "${RESET}${YELLOW_TEXT}[${BOLD}Cloning${RESET}${YELLOW_TEXT}]${RESET}${BOLD}${BLUE_TEXT} Cloning discord-ttl...${RESET}" 
    if [[ "$(pwd)" == *"/discord-ttl" ]]; then
      git clone https://github.com/ayubun/discord-ttl.git .
    else
      git clone https://github.com/ayubun/discord-ttl.git
      cd discord-ttl
    fi
    echo "${RESET}${YELLOW_TEXT}[${BOLD}Cloning${RESET}${YELLOW_TEXT}]${RESET}${BOLD}${GREEN_TEXT} Done!${RESET}" 
  else
    echo ""
    echo "${RESET}${RED_TEXT}[${BOLD}ERROR${RESET}${RED_TEXT}]${RESET}${BOLD}${YELLOW_TEXT} It looks like the repository was not cloned here. Navigate to your discord-ttl folder and re-run"
    echo "this command. Alternatively, you can run the following command to have it cloned for you:" 
    echo ""
    echo "${WHITE_TEXT}curl -o- https://raw.githubusercontent.com/ayubun/discord-ttl/main/install.sh | bash ${BASH_SUFFIX_STRING}${SKIP_DOCKER_STRING}${SKIP_DOCKER_COMPOSE_STRING}${SKIP_AUTO_UPDATER_STRING}${RESET}"
    echo ""
    exit 1
  fi
elif [[ "$(pwd)" == *"/discord-ttl" ]]; then
  if [[ $SKIP_CLONING == false ]]; then
    echo ""
    echo "${RESET}${RED_TEXT}[${BOLD}ERROR${RESET}${RED_TEXT}]${RESET}${BOLD}${YELLOW_TEXT} If you are running this script from inside the discord-ttl repository already, please use the following command:" 
    echo ""
    echo "${WHITE_TEXT}./install.sh --skip-cloning ${SKIP_DOCKER_STRING}${SKIP_DOCKER_COMPOSE_STRING}${SKIP_AUTO_UPDATER_STRING}${RESET}"
    echo ""
    exit 1
  fi
fi

if [[ $SKIP_DOCKER == false ]]; then
  # ==============
  # DOCKER INSTALL
  # Source: https://docs.docker.com/engine/install/ubuntu/
  # ==============
  # Remove any old files
  echo "${RESET}${YELLOW_TEXT}[${BOLD}Docker${RESET}${YELLOW_TEXT}]${RESET}${BOLD}${BLUE_TEXT} Preparing for Docker install...${RESET}" 
  sudo apt-get remove docker docker-engine docker.io containerd runc -y
  # Stable repository setup
  sudo apt-get update -y
  sudo apt autoremove -y
  sudo apt-get install \
      ca-certificates \
      curl \
      gnupg \
      lsb-release -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  # Install Docker Engine
  echo "${RESET}${YELLOW_TEXT}[${BOLD}Docker${RESET}${YELLOW_TEXT}]${RESET}${BOLD}${BLUE_TEXT} Installing Docker...${RESET}" 
  sudo apt-get update -y
  sudo apt-get install docker-ce docker-ce-cli containerd.io -y
  echo "${RESET}${YELLOW_TEXT}[${BOLD}Docker${RESET}${YELLOW_TEXT}]${RESET}${BOLD}${GREEN_TEXT} Done!${RESET}" 
else
  echo "${RESET}${YELLOW_TEXT}[${BOLD}Docker${RESET}${YELLOW_TEXT}]${RESET}${BOLD}${BLUE_TEXT} Skipping Docker installation!${RESET}" 
fi

if [[ $SKIP_DOCKER_COMPOSE == false ]]; then
  # ======================
  # DOCKER COMPOSE INSTALL
  # Source: https://docs.docker.com/compose/install/
  # ======================
  # Remove any old files
  echo "${RESET}${YELLOW_TEXT}[${BOLD}Docker Compose${RESET}${YELLOW_TEXT}]${RESET}${BOLD}${BLUE_TEXT} Preparing for Docker Compose install...${RESET}" 
  sudo rm /usr/local/bin/docker-compose
  sudo rm /usr/bin/docker-compose
  # Download
  echo "${RESET}${YELLOW_TEXT}[${BOLD}Docker Compose${RESET}${YELLOW_TEXT}]${RESET}${BOLD}${BLUE_TEXT} Installing Docker Compose...${RESET}" 
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
  echo "${RESET}${YELLOW_TEXT}[${BOLD}Docker Compose${RESET}${YELLOW_TEXT}]${RESET}${BOLD}${GREEN_TEXT} Done!${RESET}" 
else
  echo "${RESET}${YELLOW_TEXT}[${BOLD}Docker Compose${RESET}${YELLOW_TEXT}]${RESET}${BOLD}${BLUE_TEXT} Skipping Docker Compose installation!${RESET}" 
fi

