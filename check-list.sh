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
          if [ "$(uname)" == "Darwin" ]; then
              # Mac OS X
              install_wget_macos
          elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
              # GNU/Linux
              install_wget_linux
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # Red Hat dist, Centos
              install_wget_redhat
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
    while true; do
      read -p " ~~> Do you wish to install {Java}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          if [ "$(uname)" == "Darwin" ]; then
              # Mac OS X
              install_java_macos
          elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
              # GNU/Linux
              install_java_linux
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_java_redhat
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
          if [ "$(uname)" == "Darwin" ]; then
              # Mac OS X
              install_miniconda_macos
          elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
              # GNU/Linux
              install_miniconda_linux
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # Red Hat dist, Centos
              install_miniconda_redhat
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
          if [ "$(uname)" == "Darwin" ]; then
              # Mac OS X
              install_python_macos
          elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
              # GNU/Linux
              install_python_linux
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_python_redhat
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
          if [ "$(uname)" == "Darwin" ]; then
              # Mac OS X
              install_rbenv_macos
          elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
              # GNU/Linux
              install_rbenv_linux
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_rbenv_redhat
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
          if [ "$(uname)" == "Darwin" ]; then
              # Mac OS X
              install_ruby_macos
          elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
              # GNU/Linux
              install_ruby_linux
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_ruby_redhat
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
          if [ "$(uname)" == "Darwin" ]; then
              # Mac OS X
              install_docker_macos
          elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
              # GNU/Linux
              install_docker_linux
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_docker_redhat
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
          if [ "$(uname)" == "Darwin" ]; then
              # Mac OS X
              install_vagrant_macos
          elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
              # GNU/Linux
              install_vagrant_linux
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_vagrant_redhat
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
    printf "${GREEN} --> Found Chef executable in PATH${NC}\n"
    chef_version=`chef-client -version 2>/dev/null | awk '{print $2}'`
    if [[ ! -z "$chef_version// " ]];then
      printf "${GREEN} --> Chef version $chef_version is installed${NC}\n"
    else
      printf "${YELLOW} --> Chef is found in PATH, but seems not being completely setup. Run 'chef-client' or 'chef-client -version' to see error message${NC}\n"
    fi
  else
    printf "${RED} --> No Chef executable is found${NC}\n"
    printf "${YELLOW} ~~> Chef is optional installation${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {Chef}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          if [ "$(uname)" == "Darwin" ]; then
              # Mac OS X
              install_chef_macos
          elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
              # GNU/Linux
              install_chef_linux
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_chef_redhat
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
          if [ "$(uname)" == "Darwin" ]; then
              # Mac OS X
              install_git_macos
          elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
              # GNU/Linux
              install_git_linux
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_git_redhat
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
          if [ "$(uname)" == "Darwin" ]; then
              # Mac OS X
              install_vim_macos
          elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
              # GNU/Linux
              install_vim_linux
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_vim_redhat
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
          if [ "$(uname)" == "Darwin" ]; then
              # Mac OS X
              install_maven_macos
          elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
              # GNU/Linux
              install_maven_linux
          elif [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "centos" ] || [ "$(rpm -qa \*elease\* | grep -Ei 'redhat|centos' | cut -d '-' -f1)" == "redhat" ]; then
              # RedHat/Centos
              install_maven_centos
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
    while true; do
      read -p " ~~> Do you wish to install {jenv}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          install_jenv_linux
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

verify_jenv_setup_macos() {
  printf "${LIGHT_BLUE}Checking jenv setup${NC}\n"
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
    while true; do
      read -p " ~~> Do you wish to install {adshell}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          if [ "$(uname)" == "Darwin" ]; then
            # Mac OS X
            install_adshell_macos
          else
            # Other OS
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
  fi
}

improve_vim() {
  printf "${LIGHT_BLUE}Would you love to bring nice plugins to your Vim?${NC}\n"
  printf "${YELLOW} ~~> Checkout https://github.com/AdamWhittingham/vim-config before using this Vim configuration${NC}\n"
  printf "${YELLOW} ~~> Optional: Brings nice plugins to your Vim${NC}\n"
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
}
