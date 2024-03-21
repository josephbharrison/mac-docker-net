#!/bin/bash

opt=$1

[[ -f ~/.provile ]] && source ~/.profile
[[ -f venv/bin/activate ]] && source venv/bin/activate

#project=${PWD##*/}
proj_home=$CODE_HOME/mac-docker-net

if [[ -d $proj_home && -z $opt ]];then
  cd $proj_home
  opt="-s"
fi

if [[ -z "$opt" || $opt == "-h" || $opt == "--help" ]];then
  echo "
Usage: docker-net.sh [OPTIONS]

Options:
    -i    Install
    -b    Build
    -s    Start
    -x    Stop
    -l    Update /etc/hosts entries and lo0 alias
    -H    Update /etc/hosts entries only
    -h    Help message
"
  exit 0
fi

# [[ $(uname -a | grep -c "arm64") -gt 0 ]] &&  export DOCKER_DEFAULT_PLATFORM=linux/amd64
[[ $(uname -a | grep -c "arm64") -gt 0 ]] &&  export DOCKER_DEFAULT_PLATFORM=linux/arm64

if [[ $opt == "-H" || $opt == "-l" ]];then

  ansible --version > /dev/null || brew install ansible
  echo '[defaults]' > ansible.cfg
  echo "interpreter_python=$(which python)" >> ansible.cfg

  echo '[containers]' > inventory
  for container_id in $(docker ps --format '{{.ID}}')
  do
    container_ip=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${container_id})
    container_name=$(docker inspect --format '{{.Name}}' ${container_id} | tr -d '/')
    container_network=`docker network inspect --format='{{.Name}}' $(docker inspect --format='{{range .NetworkSettings.Networks}}{{.NetworkID}}{{end}}'  ${container_id})`
    [[ -z $container_ip ]] && container_ip=127.0.0.1
    echo "${container_name} host=${container_name} ip=${container_ip}" >> inventory
    if [[ $opt == "-l" ]];then
      sudo ifconfig lo0 alias ${container_ip}/20
    fi
  done

  ## uncomment line below if '-b' does not execute as root
  #ansible-playbook -i inventory playbook.yml --sudo
  ansible-playbook -i inventory playbook.yml -b

fi

export PROJECT=mac-docker-net

# Setup Colima
if [[ $opt == "-i" ]];then
    colima stop &> /dev/null
    brew install colima || brew reinstall colima
    brew install docker
    brew install docker-buildx
    mkdir -p ~/.docker/cli-plugins
    ln -sfn $(which docker-buildx) ~/.docker/cli-plugins/docker-buildx
    colima stop &> /dev/null
    mkdir -p ~/.colima/default
    cp extras/colima.yaml ~/.colima/default/
    brew install colima
    colima start
fi

# Build openvpn and configure network
if [[ $opt == "-b" || $opt == "-i" ]];then
  (
    cd openvpn
    docker buildx build . -t openvpn
  )
  cd compose
  test=$(docker network inspect $PROJECT &> /dev/null)
  [[ $? -gt 0 ]] && docker network create --subnet "172.16.33.0/24" --gateway "172.16.33.1" $PROJECT
  docker compose -f docker-network.yml -f docker-compose.yml -p $PROJECT build
fi

# Start docker network
if [[ $opt == "-s" || $opt == "-i" ]];then
  cd compose
  docker compose -f docker-network.yml -f docker-compose.yml -p $PROJECT up -d
fi

# Stop docker network
if [[ $opt == "-x" ]];then
  cd compose
  docker compose -f docker-network.yml -f docker-compose.yml -p $PROJECT stop
fi

exit 0
