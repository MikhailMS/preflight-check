#!/bin/bash

# COLOUR CONSTANTS
GREEN='\033[0;32m'
LIGHT_BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0;30m'

internet_connection() {
  printf "${LIGHT_BLUE}Checking internet connectivity${NC}\n"
  wget -q --tries=10 --timeout=20 --spider http://google.com
  if [[ $? -eq 0 ]]; then
    printf "${GREEN}Internet connectivity check\n --> Online${NC}\n"
  else
    printf "${RED}Internet connectivity check\n --> Offline${NC}\n"
  fi
}

get_var () {
    eval 'printf "%s\n" "${'"$1"'}"'
}
set_var () {
    eval "$1=\"\$2\""
}

deduplicate() {
    printf "${LIGHT_BLUE}PATH Deduplication${NC}\n"
    pathvar_name="$1"
    pathvar_value="$(get_var "$pathvar_name")"
    deduped_path="$(perl -e 'print join(":",grep { not $seen{$_}++ } split(/:/, $ARGV[0]))' "$pathvar_value")"
    set_var "$pathvar_name" "$deduped_path"
    printf "${GREEN} --> Completed${NC}\n"
}

verify_java_setup() {
  printf "${LIGHT_BLUE}Checking Java setup${NC}\n"
  if type -p java; then
    printf "${GREEN} --> Found Java executable in PATH${NC}\n"
    _java=java
  elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
    printf "${GREEN} --> Found Java executable in JAVA_HOME${NC}\n"
    _java="$JAVA_HOME/bin/java"
  else
    printf "${RED}Java is not available - Check JAVA_HOME or PATH${NC}\n"
  fi

  if [[ "$_java" ]]; then
    java_version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    printf "${GREEN} --> Java version $java_version is installed${NC}\n"
    if [[ "$java_version" < "1.7" ]]; then
      printf "${YELLOW}Please upgrade your Java to version 1.7 or above${NC}\n"
    fi
  fi
}

verify_python_setup() {
  printf "${LIGHT_BLUE}Checking Python setup${NC}\n"
  if type -p python; then
    printf "${GREEN} --> Found Python executable in PATH${NC}\n"
    python_version=`python --version 2>&1 | awk '{print $2}'`
    printf "${GREEN} --> Python version $python_version is installed${NC}\n"
  else
    printf "${RED} --> No Python executable is found${NC}\n"
  fi
}

verify_ruby_setup() {
  printf "${LIGHT_BLUE}Checking Ruby setup${NC}\n"
  if type -p ruby; then
    printf "${GREEN} --> Found Ruby executable in PATH${NC}\n"
    ruby_version=`ruby -v | awk '{print $2}'`
    printf "${GREEN} --> Ruby version $ruby_version is installed${NC}\n"
  else
    printf "${RED} --> No Ruby executable is found${NC}\n"
  fi
}

verify_docker_setup() {
  printf "${LIGHT_BLUE}Checking Docker setup${NC}\n"
  if type -p docker; then
    printf "${GREEN} --> Found Docker executable in PATH${NC}\n"
    docker_version=`docker --version | awk '{print $3}' | sed 's/,*$//g'`
    printf "${GREEN} --> Docker version $docker_version is installed${NC}\n"
  else
    printf "${RED} --> No Docker executable is found${NC}\n"
  fi
}

verify_vagrant_setup() {
  printf "${LIGHT_BLUE}Checking Vagrant setup${NC}\n"
  if type -p vagrant; then
    printf "${GREEN} --> Found Vagrant executable in PATH${NC}\n"
    vagrant_version=`vagrant --version | awk '{print $2}'`
    printf "${GREEN} --> Vagrant version $vagrant_version is installed${NC}\n"
  else
    printf "${RED} --> No Vagrant executable is found${NC}\n"
  fi
}

verify_chef_setup() {
  printf "${LIGHT_BLUE}Checking Chef setup${NC}\n"
  if type -p chef-client; then
    printf "${GREEN} --> Found Chef executable in PATH${NC}\n"
    chef_version=`chef-client -version | awk '{print $2}'`
    printf "${GREEN} --> Chef version $chef_version is installed${NC}\n"
  else
    printf "${RED} --> No Chef executable is found${NC}\n"
  fi
}

verify_git_setup() {
  printf "${LIGHT_BLUE}Checking Git setup${NC}\n"
  if type -p git; then
    printf "${GREEN} --> Git is installed${NC}"
    git_version=`git --version | awk '{print $3}'`
    printf "${GREEN} --> Git version $git_version is installed${NC}\n"
  else
    printf "${RED} --> No Git executable is found${RED}\n"
  fi
}

verify_vim_setup() {
  printf "${LIGHT_BLUE}Checking Vim setup${NC}\n"
  if type -p vim; then
    printf "${GREEN} --> Vim executable in PATH${NC}\n"
    vim_version=`vim --version | grep "VIM" | awk '{print $5}' | tr -d '\n'`
    printf "${GREEN} --> Vim version $vim_version is installed${NC}\n"

  else
    printf "${RED} --> No Vim executable is found${NC}\n"
  fi
}

run_preflight_check() {
  internet_connection
  deduplicate PATH
  verify_java_setup
  verify_python_setup
  verify_ruby_setup
  verify_git_setup
  verify_vim_setup
  verify_docker_setup
  verify_vagrant_setup
  verify_chef_setup
}

run_preflight_check
