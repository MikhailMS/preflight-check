#!/bin/bash

verify_proxies_setup() {
  printf "${LIGHT_BLUE}Checking proxies${NC}\n"
  if [[ ! -z "${HTTP_PROXY// }" ]];then
    curl -s --max-time 10 -x "${HTTP_PROXY}" ip-api.com/json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g'| sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w "city" | sed -e "s/^city|//"
    _country_code=$!
    if [[ ! -z "$_country_code// " ]];then
      printf "${GREEN} --> HTTP_PROXY is set : ${HTTP_PROXY} and working${NC}\n"
    else
      printf "${YELLOW} --> HTTP_PROXY is set : ${HTTP_PROXY} but doesn't work${NC}\n"
    fi
  else
    printf "${RED} --> HTTP_PROXY is not set${NC}\n"
  fi

  if [[ ! -z "${http_proxy// }" ]];then
    curl -s --max-time 10 -x "${http_proxy}" ip-api.com/json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g'| sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w "city" | sed -e "s/^city|//"
    _country_code=$!
    if [[ ! -z "$_country_code// " ]];then
      printf "${GREEN} --> http_proxy is set : ${http_proxy} and working${NC}\n"
    else
      printf "${YELLOW} --> http_proxy is set : ${http_proxy} but doesn't work${NC}\n"
    fi
  else
    printf "${RED} --> http_proxy is not set${NC}\n"
  fi

  if [[ ! -z "${HTTPS_PROXY// }" ]];then
    curl -s --max-time 10 -x "${HTTPS_PROXY}" ip-api.com/json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g'| sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w "city" | sed -e "s/^city|//"
    _country_code=$!
    if [[ ! -z "$_country_code// " ]];then
      printf "${GREEN} --> HTTPS_PROXY is set : ${HTTPS_PROXY} and working${NC}\n"
    else
      printf "${YELLOW} --> HTTPS_PROXY is set : ${HTTPS_PROXY} but doesn't work${NC}\n"
    fi
  else
    printf "${RED} --> HTTPS_PROXY is not set${NC}\n"
  fi

  if [[ ! -z "${https_proxy// }" ]];then
    curl -s --max-time 10 -x "${https_proxy}" ip-api.com/json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g'| sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w "city" | sed -e "s/^city|//"
    _country_code=$!
    if [[ ! -z "$_country_code// " ]];then
      printf "${GREEN} --> https_proxy is set : ${https_proxy} and working${NC}\n"
    else
      printf "${YELLOW} --> https_proxy is set : ${https_proxy} but doesn't work${NC}\n"
    fi
  else
    printf "${RED} --> https_proxy is not set${NC}\n"
  fi
}

internet_connection() {
  printf "${LIGHT_BLUE}Checking internet connectivity${NC}\n"
  if [[ `curl --silent --max-time 10 http://google.com` ]]; then
    printf "${GREEN} --> Online${NC}\n"
  else
    printf "${RED} --> Offline${NC}\n"
  fi
}

verify_wget_setup() {
  printf "${LIGHT_BLUE}Checking wget setup${NC}\n"
  if type -p wget; then
    printf "${GREEN} --> Found wget executable in PATH${NC}\n"
    wget_version=`wget --version | sed 's/[^0-9.]*\([0-9.]*\).*/\1/' | sed -n 1p`
    printf "${GREEN} --> wget version $wget_version is installed${NC}\n"
  else
    printf "${RED} --> No wget executable is found${NC}\n"
    printf "${YELLOW} ~~> It would be used to install some of the required ingredients${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {wget}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          if [ "$(uname -s)" == "Darwin" ]; then
              # Mac OS X
              if type -p brew; then
                install_wget_macos
              else
                printf "${RED} ~~> You need to install Homebrew before you can install {wget}${NC}\n"
              fi
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # Red Hat dist, Centos
              install_wget_redhat
          elif [ "$(uname -s)" == "Linux" ]; then
              # GNU/Linux
              install_wget_linux
          fi
          break
          ;;
        [Nn]* )
          printf "${RED} ~~> Be aware, some installation procedures relies on wget & will fail w/o {wget}${NC}\n"
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi
}

verify_bash_files_existence() {
  printf "${LIGHT_BLUE}Checking if .bash files exists${NC}\n"
  if [[ -f ~/.bash_profile ]]; then
    printf "${GREEN} --> ~/.bash_profile exists, nice${NC}\n"
  else
    printf "${RED} --> ~/.bash_profile is missing${NC}\n"
    while true; do
      read -p " ~~> Do you wish to create {~/.bash_profile}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          touch ~/.bash_profile
          break
          ;;
        [Nn]* )
          printf "${RED} ~~> Make sure to create {~/.bash_profile} later${NC}\n"
          printf "${YELLOW} ~~> Skipping creation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi

  if [[ -f ~/.bashrc ]]; then
    printf "${GREEN} --> ~/.bashrc exists, nice${NC}\n"
  else
    printf "${RED} --> ~/.bashrc is missing${NC}\n"
    while true; do
      read -p " ~~> Do you wish to create {~/.bashrc}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          touch ~/.bashrc
          break
          ;;
        [Nn]* )
          printf "${RED} ~~> Make sure to create {~/.bashrc} later${NC}\n"
          printf "${YELLOW} ~~> Skipping creation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi
}

get_var () {
    eval 'printf "%s\n" "${'"$1"'}"'
}
set_var () {
    eval "$1=\"\$2\""
}

deduplicate_with_perl() {
  printf "${LIGHT_BLUE}PATH Deduplication (Advanced)${NC}\n"
  pathvar_name="$1"
  pathvar_value="$(get_var "$pathvar_name")"
  deduped_path="$(perl -e 'print join(":",grep { not $seen{$_}++ } split(/:/, $ARGV[0]))' "$pathvar_value")"
  set_var "$pathvar_name" "$deduped_path"
  printf "${GREEN} --> Completed${NC}\n"
}

deduplicate_simple() {
  printf "${LIGHT_BLUE}PATH Deduplication (Simple)${NC}\n"

  if [ -n "$PATH" ]; then
    old_PATH=$PATH:; PATH=
    while [ -n "$old_PATH" ]; do
      x=${old_PATH%%:*}
      case $PATH: in
        *:"$x":*) ;;
        *) PATH=$PATH:$x;;
      esac
      old_PATH=${old_PATH#*:}
    done
    PATH=${PATH#:}
    unset old_PATH x
  fi

  printf "${GREEN} --> Completed${NC}\n"
}

deduplicate() {
  if type -p perl; then
    deduplicate_with_perl $1
  else
    deduplicate_simple
  fi
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
    while true; do
      read -p " ~~> Do you wish to install {Java}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          if [ "$(uname -s)" == "Darwin" ]; then
              # Mac OS X
              if type -p brew; then
                install_java_macos
              else
                printf "${RED} ~~> You need to install Homebrew before you can install {Java}${NC}\n"
              fi
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_java_redhat
          elif [ "$(uname -s)" == "Linux" ]; then
              # GNU/Linux
              install_java_linux
          fi
          break
          ;;
        [Nn]* )
          printf "${RED} ~~> Make sure to install Java later${NC}\n"
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi

  if [[ "$_java" ]]; then
    java_version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    printf "${GREEN} --> Java version $java_version is installed${NC}\n"
    if [[ "$java_version" < "1.7" ]]; then
      printf "${YELLOW}Please upgrade your Java to version 1.7 or above${NC}\n"
    fi
  fi
}

verify_miniconda_setup() {
  printf "${LIGHT_BLUE}Checking Miniconda setup${NC}\n"
  if type -p conda; then
    printf "${GREEN} --> Found Miniconda executable in PATH${NC}\n"
    conda_version=`conda --version 2>&1 | awk '{print $2}'`
    printf "${GREEN} --> Miniconda version $conda_version is installed${NC}\n"
  else
    printf "${RED} --> No Miniconda executable is found${NC}\n"
    printf "${YELLOW} ~~> It is optional to install Miniconda, but makes work with Python nicer & easier${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {Miniconda}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          if [ "$(uname -s)" == "Darwin" ]; then
            # Mac OS X
            if type -p wget; then
              install_miniconda_macos
            else
              printf "${RED} ~~> You need to install wget before you can install {Miniconda}${NC}\n"
            fi
          else
            if type -p wget; then
              install_miniconda
            else
              printf "${RED} ~~> You need to install wget before you can install {Miniconda}${NC}\n"
            fi
          fi
          break
          ;;
        [Nn]* )
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
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
    printf "${YELLOW} ~~> Please double check Python presence, since it usually comes with OS distribution by default${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {Python}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          if [ "$(uname -s)" == "Darwin" ]; then
              # Mac OS X
              install_python_macos
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_python_redhat
          elif [ "$(uname -s)" == "Linux" ]; then
              # GNU/Linux
              install_python_linux
          fi
          break
          ;;
        [Nn]* )
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi
}

verify_rbenv_setup() {
  printf "${LIGHT_BLUE}Checking rbenv setup${NC}\n"
  if type -p rbenv; then
    printf "${GREEN} --> Found rbenv executable in PATH${NC}\n"
    rbenv_version=`rbenv --version | awk '{print $2}'`
    printf "${GREEN} --> rbenv version $rbenv_version is installed${NC}\n"
  else
    printf "${RED} --> No rbenv executable is found${NC}\n"
    printf "${YELLOW} ~~> It is optional to install rbenv, but makes work with Ruby nicer & easier${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {rbenv}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          if [ "$(uname -s)" == "Darwin" ]; then
              # Mac OS X
              if type -p brew; then
                install_rbenv_macos
              else
                printf "${RED} ~~> You need to install Homebrew before you can install {rbenv}${NC}\n"
              fi
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              if type -p git; then
                install_rbenv_redhat
              else
                printf "${RED} ~~> You need to install Git before you can install {rbenv}${NC}\n"
              fi
          elif [ "$(uname -s)" == "Linux" ]; then
              # GNU/Linux
              if type -p git; then
                install_rbenv_linux
              else
                printf "${RED} ~~> You need to install Git before you can install {rbenv}${NC}\n"
              fi
          fi
          break
          ;;
        [Nn]* )
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi
}

verify_ruby_setup() {
  printf "${LIGHT_BLUE}Checking Ruby setup${NC}\n"
  if type -p ruby; then
    printf "${GREEN} --> Found Ruby executable in PATH${NC}\n"
    ruby_version=`ruby -v | awk '{print $2}' || echo ""`
    if [[ ! -z "$ruby_version// " ]];then
      printf "${GREEN} --> Ruby version $ruby_version is installed${NC}\n"
    else
      printf "${YELLOW} --> Ruby version is not recognized, possibly you did not set it. Try run 'rbenv global [version]' if you have rbenv installed${NC}\n"
    fi
  else
    printf "${RED} --> No Ruby executable is found${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {Ruby}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          if [ "$(uname -s)" == "Darwin" ]; then
              # Mac OS X
              if type -p brew; then
                install_ruby_macos
              else
                printf "${RED} ~~> You need to install Homebrew before you can install {Ruby}${NC}\n"
              fi
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_ruby_redhat
          elif [ "$(uname -s)" == "Linux" ]; then
              # GNU/Linux
              install_ruby_linux
          fi
          break
          ;;
        [Nn]* )
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi
}

verify_bundler_setup() {
  printf "${LIGHT_BLUE}Checking Bundler setup${NC}\n"
  if type -p bundler; then
    printf "${GREEN} --> Found Bundler executable in PATH${NC}\n"
    bundler_version=`bundler -v | awk '{print $3}'`
    printf "${GREEN} --> Bundler version $bundler_version is installed${NC}\n"
  else
    printf "${RED} --> No Bundler executable is found${NC}\n"
    printf "${YELLOW} ~~> It is optional to install bundler, but it takes care of managing ruby gems${NC}\n"
    if type -p gem; then
      while true; do
        read -p " ~~> Do you wish to install {bundler}? [Yes/No] " yn
        case $yn in
          [Yy]* )
            install_bundler
            break
            ;;
          [Nn]* )
            printf "${YELLOW} ~~> Skipping installation${NC}\n"
            break
            ;;
          * )
            echo "Please answer yes or no\n"
            ;;
        esac
      done
    else
      printf "${RED} ~~> You need to install gem before you can install {Bundler}${NC}\n"
    fi
  fi
}

verify_gem_setup() {
  printf "${LIGHT_BLUE}Checking gem setup${NC}\n"
  if type -p gem; then
    printf "${GREEN} --> Found gem executable in PATH${NC}\n"
    gem_version=`gem --version`
    printf "${GREEN} --> gem version $gem_version is installed${NC}\n"
  else
    printf "${RED} --> No gem executable is found${NC}\n"
  fi
}

verify_rails_setup() {
  printf "${LIGHT_BLUE}Checking Ruby-on-Rails setup${NC}\n"
  if type -p gem; then
    rails_version=`gem list | grep  '^rails ' | awk '{print $2}' | tr -d '()'`
    if [[ ! -z "$rails_version" ]]; then
      if [[ "$rails_version" < "5.1.4" ]]; then
        printf "${YELLOW} --> Current rails version $rails_version, when recommended is 5.1.4${NC}\n"
      else
        printf "${GREEN} --> Ruby-on-Rails version $rails_version is installed${NC}\n"
      fi
    else
      printf "${RED} --> Ruby-on-Rails is not installed${NC}\n"
      printf "${YELLOW} ~~> Ruby-on-Rails is optional, unless you're aiming to develop web apps${NC}\n"
      if type -p gem; then
        while true; do
          read -p " ~~> Do you wish to install {Ruby-on-Rails}? [Yes/No] " yn
          case $yn in
            [Yy]* )
              install_rails
              break
              ;;
            [Nn]* )
              printf "${YELLOW} ~~> Skipping installation${NC}\n"
              break
              ;;
            * )
              echo "Please answer yes or no\n"
              ;;
          esac
        done
      else
        printf "${RED} ~~> You need to install gem before you can install {Ruby-on-Rails}${NC}\n"
      fi
    fi
  else
    printf "${YELLOW} ~~> There is no gem installed, so you probably don't have Rails installed${NC}\n"
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
    printf "${YELLOW} ~~> It is a nice tool to manage applications and stuff rather than using VMs${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {Docker}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          if [ "$(uname -s)" == "Darwin" ]; then
              # Mac OS X
              if type -p wget; then
                install_docker_macos
              else
                printf "${RED} ~~> You need to install wget before you can install {Docker}${NC}\n"
              fi
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_docker_redhat
          elif [ "$(uname -s)" == "Linux" ]; then
              # GNU/Linux
              install_docker_linux
          fi
          break
          ;;
        [Nn]* )
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
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
    printf "${YELLOW} ~~> It is sad to live without VMs and Vagrant :(${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {Vagrant}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          if [ "$(uname -s)" == "Darwin" ]; then
              # Mac OS X
              if type -p brew; then
                install_vagrant_macos
              else
                printf "${RED} ~~> You need to install Homebrew before you can install {Vagrant}${NC}\n"
              fi
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_vagrant_redhat
          elif [ "$(uname -s)" == "Linux" ]; then
              # GNU/Linux
              install_vagrant_linux
          fi
          break
          ;;
        [Nn]* )
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi
}

verify_chef_setup() {
  printf "${LIGHT_BLUE}Checking Chef setup${NC}\n"
  if type -p chef-client; then
    printf "${GREEN} --> Found chef-client executable in PATH${NC}\n"
    chef_version=`chef-client -version 2>/dev/null | awk '{print $2}'`
    if [[ ! -z "$chef_version// " ]];then
      printf "${GREEN} --> chef-client version $chef_version is installed${NC}\n"
    else
      printf "${YELLOW} --> chef-client is found in PATH, but seems not being completely setup. Run 'chef-client' or 'chef-client -version' to see error message${NC}\n"
    fi
  else
    printf "${RED} --> No chef-client executable is found${NC}\n"
    printf "${YELLOW} ~~> chef-client is optional installation${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {chef-client}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          if [ "$(uname -s)" == "Darwin" ]; then
              # Mac OS X
              if type -p wget; then
                install_chef_macos
              else
                printf "${RED} ~~> You need to install wget before you can install {chef-client}${NC}\n"
              fi
          else
              install_chef
          fi
          break
          ;;
        [Nn]* )
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi
}

verify_git_setup() {
  printf "${LIGHT_BLUE}Checking Git setup${NC}\n"
  if type -p git; then
    printf "${GREEN} --> Found Git executable in PATH${NC}\n"
    git_version=`git --version | awk '{print $3}'`
    printf "${GREEN} --> Git version $git_version is installed${NC}\n"
  else
    printf "${RED} --> No Git executable is found${RED}\n"
    printf "${RED} ~~> It is important to have Git installed, if you want to do real development${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {Git}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          if [ "$(uname -s)" == "Darwin" ]; then
              # Mac OS X
              if type -p brew; then
                install_git_macos
              else
                printf "${RED} ~~> You need to install Homebrew before you can install {Git}${NC}\n"
              fi
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_git_redhat
          elif [ "$(uname -s)" == "Linux" ]; then
              # GNU/Linux
              install_git_linux
          fi
          break
          ;;
        [Nn]* )
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi
}

verify_vim_setup() {
  printf "${LIGHT_BLUE}Checking Vim setup${NC}\n"
  if type -p vim; then
    printf "${GREEN} --> Found Vim executable in PATH${NC}\n"
    vim_version=`vim --version | grep "VIM" | awk '{print $5}' | tr -d '\n'`
    printf "${GREEN} --> Vim version $vim_version is installed${NC}\n"
  else
    printf "${RED} --> No Vim executable is found${NC}\n"
    printf "${YELLOW} ~~> Only install it, if you are either crazy or know what's Vim about${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {Vim}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          if [ "$(uname -s)" == "Darwin" ]; then
              # Mac OS X
              if type -p brew; then
                install_vim_macos
              else
                printf "${RED} ~~> You need to install Homebrew before you can install {Vim}${NC}\n"
              fi
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              if type -p git; then
                install_vim_redhat
              else
                printf "${RED} ~~> You need to install Git before you can install {Vim}${NC}\n"
              fi
          elif [ "$(uname -s)" == "Linux" ]; then
              # GNU/Linux
              install_vim_linux
          fi
          break
          ;;
        [Nn]* )
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi
}

verify_homebrew_setup() {
  printf "${LIGHT_BLUE}Checking Homebrew setup${NC}\n"
  if type -p brew; then
    printf "${GREEN} --> Found Homebrew executable in PATH${NC}\n"
    brew_version=`brew --version | awk '{print $2}' | tr -d '(git' | tr -d '\n'`
    printf "${GREEN} --> Homebrew version $brew_version is installed${NC}\n"
  else
    printf "${RED} --> No Homebrew executable is found${NC}\n"
    printf "${RED} ~~> This ingredient is mandatory to install. Make sure you got it on machine${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {Homebrew}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          install_homebrew_macos
          break
          ;;
        [Nn]* )
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi
}

verify_smcfancontrol_setup() {
  printf "${LIGHT_BLUE}Checking if smcfancontrol installed${NC}\n"
  _smcfancontrol=`brew cask list | grep smcfancontrol | awk '{print $1}'`
  if [[ "$_smcfancontrol// " ]]; then
    printf "${GREEN} --> smcfancontrol installed${NC}\n"
  else
    printf "${RED} --> smcfancontrol is not installed${NC}\n"
    printf "${YELLOW} ~~> Optional utility to monitor fan speed and computer temperature${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {smcfancontrol}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          install_smcfancontrol_macos
          break
          ;;
        [Nn]* )
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi
}

verify_maven_setup() {
  printf "${LIGHT_BLUE}Checking Maven setup${NC}\n"
  if type -p mvn; then
    printf "${GREEN} --> Found Maven executable in PATH${NC}\n"
    maven_version=`mvn -v | grep "Apache Maven" | awk '{print $3}'`
    printf "${GREEN} --> Maven version $maven_version is installed${NC}\n"
  else
    printf "${RED} --> No Maven executable is found${NC}\n"
    printf "${YELLOW} ~~> It is optional, but makes managing Java dependencies nicer & easier${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {Maven}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          if [ "$(uname -s)" == "Darwin" ]; then
              # Mac OS X
              if type -p brew; then
                install_maven_macos
              else
                printf "${RED} ~~> You need to install Homebrew before you can install {Maven}${NC}\n"
              fi
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              if type -p wget; then
                install_maven_redhat
              else
                printf "${RED} ~~> You need to install wget before you can install {Maven}${NC}\n"
              fi
          elif [ "$(uname -s)" == "Linux" ]; then
              # GNU/Linux
              install_maven_linux
          fi
          break
          ;;
        [Nn]* )
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi
}

verify_rust_setup() {
  printf "${LIGHT_BLUE}Checking Rust setup${NC}\n"
  if type -p rustc; then
    printf "${GREEN} --> Rust is found on the machine${NC}\n"
    rust_version=`rustc --version | awk '{print $2}'`
    printf "${GREEN} --> Rust version $rust_version is installed${NC}\n"
  else
    printf "${RED} --> No Rust executable is found${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {Rust}? [Yes/No]" yn
      case $yn in
        [Yy]* )
          install_rust
          break
          ;;
        [Nn]* )
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi
}

verify_gradle_setup() {
  printf "${LIGHT_BLUE}Checking Gradle setup${NC}\n"
  if type -p gradle; then
    printf "${GREEN} --> Found Maven executable in PATH${NC}\n"
    gradle_version=`gradle -v 2>/dev/null | grep "Gradle" | awk '{print $2}' | tr -d '(WARNING' | tr -d '\n' | sed 's/[[:digit:]]\+\.//g' | cut -d 't' -f1`
    printf "${GREEN} --> Gradle version $gradle_version is installed${NC}\n"
  else
    printf "${RED} --> No Gradle executable is found${NC}\n"
    printf "${YELLOW} ~~> It is optional, but makes building Java projects nicer & easier${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {Gradle}? [Yes/No]" yn
      case $yn in
        [Yy]* )
          if [ "$(uname -s)" == "Darwin" ]; then
            # Mac OS X
            if type -p brew; then
              install_gradle_macos
            else
              printf "${RED} ~~> You need to install Homebrew before you can install {Gradle}${NC}\n"
            fi
          else    
            # RedHat/Centos
            if type -p wget; then
              if type -p unzip; then
                install_gradle_linux_redhat
              else
                printf "${RED} ~~> You need to install unzip before you can install {Gradle}${NC}\n"
              fi
            else
              printf "${RED} ~~> You need to install wget before you can install {Gradle}${NC}\n"
            fi
          fi
          break
          ;;
        [Nn]* )
          printf "${YELLOW} ~~> Skipping installation${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  fi
}

verify_jenv_setup_linux_redhat() {
  printf "${LIGHT_BLUE}Checking jenv setup${NC}\n"
  if [[ -d ~/.jenv ]]; then
    printf "${GREEN} --> jenv is found${NC}\n"
  else
    printf "${RED} --> jenv is not installed${NC}\n"
    printf "${YELLOW} ~~> It is optional, but allows having multiple Java versions installed${NC}\n"
    printf "${YELLOW} ~~> Checkout https://github.com/gcuisinier/jenv for details${NC}\n"
    if type -p git; then
      while true; do
        read -p " ~~> Do you wish to install {jenv}? [Yes/No] " yn
        case $yn in
          [Yy]* )
            if [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
                # RedHat/Centos
                if type -p git; then
                  install_jenv_redhat
                else
                  printf "${RED} ~~> You need to install Git before you can install {jenv}${NC}\n"
                fi
            elif [ "$(uname -s)" == "Linux" ]; then
                # GNU/Linux
                if type -p git; then
                  install_jenv_linux
                else
                  printf "${RED} ~~> You need to install Git before you can install {jenv}${NC}\n"
                fi
            fi
            break
            ;;
          [Nn]* )
            printf "${YELLOW} ~~> Skipping installation${NC}\n"
            break
            ;;
          * )
            echo "Please answer yes or no\n"
            ;;
        esac
      done
    else
      printf "${RED} ~~> You need to install Git before you can install {jenv}${NC}\n"
    fi
  fi
}

verify_jenv_setup_macos() {
  printf "${LIGHT_BLUE}Checking jenv setup${NC}\n"
  if type -p brew; then
    if [[ "$(brew list | grep jenv)" == "jenv" ]]; then
      printf "${GREEN} --> jenv is found${NC}\n"
    else
      printf "${RED} --> jenv is not installed${NC}\n"
      printf "${YELLOW} ~~> It is optional, but allows having multiple Java versions installed${NC}\n"
      printf "${YELLOW} ~~> Checkout https://github.com/gcuisinier/jenv for details${NC}\n"
      while true; do
        read -p " ~~> Do you wish to install {jenv}? [Yes/No] " yn
        case $yn in
          [Yy]* )
            install_jenv_macos
            break
            ;;
          [Nn]* )
            printf "${YELLOW} ~~> Skipping installation${NC}\n"
            break
            ;;
          * )
            echo "Please answer yes or no\n"
            ;;
        esac
      done
    fi
  else
    printf "${RED} ~~> {jenv} is managed by Homebrew on Mac OS. Install Homebrew first${NC}\n"
  fi
}

verify_iterm_setup() {
  printf "${LIGHT_BLUE}Checking iTerm2 setup${NC}\n"
  if [[ ! -z "${TERM_PROGRAM// }" ]]; then
    if [ "${TERM_PROGRAM}" == "iTerm.app" ]; then
      printf "${GREEN} --> iTerm2 is set and ready to go${NC}\n"
    elif [ "${TERM_PROGRAM}" == "Apple_Terminal" ]; then
      printf "${YELLOW} --> Default terminal detected. Recommended to switch to iTerm${NC}\n"
      printf "${YELLOW} ~~> Optional: Improved version of default Mac OS terminal${NC}\n"
      while true; do
        read -p " ~~> Do you wish to install {iTerm}? [Yes/No] " yn
        case $yn in
          [Yy]* )
            install_iterm_macos
            break
            ;;
          [Nn]* )
            printf "${YELLOW} ~~> Skipping installation${NC}\n"
            break
            ;;
          * )
            echo "Please answer yes or no\n"
            ;;
        esac
      done
    fi
  else
    printf "${RED} No terminal has been set! Fix it ASAP${NC}\n"
  fi
}

verify_adshell_setup() {
  printf "${LIGHT_BLUE}Checking adshell setup${NC}\n"
  if [[ -d ~/.adshell ]]; then
    printf "${GREEN} --> Adshell is found on the machine${NC}\n"
    while true; do
      read -p " ~~> If you did not yet install {adshell}, would you like to do it now? [Yes/No] " yn
      case $yn in
        [Yy]* )
          ~/.adshell/install
          break
          ;;
        [Nn]* )
          printf "${YELLOW} ~~> Make sure to install it later${NC}\n"
          break
          ;;
        * )
          echo "Please answer yes or no\n"
          ;;
      esac
    done
  else
    printf "${RED} --> Adshell is not found${NC}\n"
    printf "${YELLOW} ~~> Optional: Brings sugar to your terminal${NC}\n"
    printf "${YELLOW} ~~> Checkout https://github.com/AdamWhittingham/adshell for details${NC}\n"
    if type -p git; then
      while true; do
        read -p " ~~> Do you wish to install {adshell}? [Yes/No] " yn
        case $yn in
          [Yy]* )
            if [ "$(uname)" == "Darwin" ]; then
              # Mac OS X
              install_adshell_macos
            else
              # RedHat/Centos7/Linux
              install_adshell
            fi
            break
            ;;
          [Nn]* )
            printf "${YELLOW} ~~> Skipping installation${NC}\n"
            break
            ;;
          * )
            echo "Please answer yes or no\n"
            ;;
        esac
      done
    else
      printf "${RED} ~~> You need to install Git before you can install {Adshell}${NC}\n"
    fi
  fi
}

improve_vim() {
  if type -p vim; then
    printf "${LIGHT_BLUE}Would you love to bring nice plugins to your Vim?${NC}\n"
    printf "${YELLOW} ~~> Checkout https://github.com/AdamWhittingham/vim-config before using this Vim configuration${NC}\n"
    printf "${YELLOW} ~~> Optional: Brings nice plugins to your Vim${NC}\n"
    if type -p git; then
      while true; do
        read -p " ~~> Do you wish to improve your {Vim}? [Yes/No] " yn
        case $yn in
          [Yy]* )
            install_nicer_vim_config
            break
            ;;
          [Nn]* )
            printf "${YELLOW} ~~> Skipping installation${NC}\n"
            break
            ;;
          * )
            echo "Please answer yes or no\n"
            ;;
        esac
      done
    else
      printf "${RED} ~~> You need to install Git before you can install {Vim config with nice plugins}${NC}\n"
    fi
  else
    printf "${RED} ~~> You need to have Vim before you can install {Vim config with nice plugins}${NC}\n"
  fi
}

