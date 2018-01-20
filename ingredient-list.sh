#!/bin/bash

# -------------------- Mac OS ingredients -----------------------
install_java_macos() {
  printf "${LIGHT_BLUE}Installing Java 8${NC}\n"
  brew tap caskroom/versions 2>/dev/null
  brew cask install java8
}

install_maven_macos() {
  printf "${LIGHT_BLUE}Installing Maven${NC}\n"
  brew update
  brew install maven
}

install_miniconda_macos() {
  printf "${LIGHT_BLUE}Installing Miniconda${NC}\n"
  wget http://repo.continuum.io/miniconda/Miniconda3-3.7.0-Linux-x86_64.sh -O ~/miniconda.sh
  bash ~/miniconda.sh -b -p $HOME/miniconda
  echo "export PATH=$HOME/miniconda/bin:$PATH" >> ~/.bash_profile
}

install_python_macos() {
  printf "${LIGHT_BLUE}Installing Python${NC}\n"
  brew update
  brew install python
}

install_rbenv_macos() {
  printf "${LIGHT_BLUE}Installing rbenv${NC}\n"
  brew update
  brew install rbenv
  rbenv init
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
}

install_ruby_macos() {
  printf "${LIGHT_BLUE}Installing Ruby${NC}\n"
  brew update
  brew install ruby
}

install_git_macos() {
  printf "${LIGHT_BLUE}Installing Git${NC}\n"
  brew update
  brew install git
}

install_wget_macos() {
  printf "${LIGHT_BLUE}Installing wget${NC}\n"
  brew update
  brew install wget --with-libressl
}

install_vim_macos() {
  printf "${LIGHT_BLUE}Installing Vim${NC}\n"
  brew update
  brew install vim
}

install_docker_macos() {
  printf "${LIGHT_BLUE}Loading Docker${NC}\n"
  wget https://download.docker.com/mac/stable/Docker.dmg 2>/dev/null &
  spinnerComplex
  printf "${YELLOW} ~~> To install Docker, manually run Docker.dmg file, which could be found in 'preflight-check' folder${NC}\n"
}

install_vagrant_macos() {
  printf "${LIGHT_BLUE}Installing Vagrant${NC}\n"
  brew cask install virtualbox
  brew cask install vagrant
}

install_chef_macos() {
  printf "${LIGHT_BLUE}Loading ChefSDK${NC}\n"
  wget https://packages.chef.io/files/stable/chef/13.6.4/mac_os_x/10.13/chef-13.6.4-1.dmg 2>/dev/null &
  spinnerComplex
  printf "${YELLOW} ~~> To install ChefSDK, manually run chef-13.6.4-1.dmg file, which could be found in 'preflight-check' folder${NC}\n"
}

install_smcfancontrol_macos() {
  printf "${LIGHT_BLUE}Installing smcfancontrol${NC}\n"
  brew cask install smcfancontrol
}

install_iterm_macos() {
  printf "${LIGHT_BLUE}Loading iTerm${NC}\n"
  wget https://iterm2.com/downloads/stable/iTerm2-3_1_5.zip 2>/dev/null &
  spinnerComplex
  printf "${YELLOW} ~~> To install iTerm, manually run iTerm2-3_1_5.zip file, which could be found in 'preflight-check' folder${NC}\n"
}

install_homebrew_macos() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

# -------------------- GNU/Linux ingredients --------------------
install_java_linux() {
  apt-get update
  apt-get install openjdk-8-jre
  apt-get install openjdk-8-jdk
  echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk" >> ~/.bashrc
  echo "export PATH=$PATH:$JAVA_HOME" >> ~/.bashrc
}

install_maven_linux() {
  apt-get update
  apt-get install maven
  echo "export M2_HOME=/usr/local/apache-maven" >> ~/.bashrc
  echo "export M2=$M2_HOME/bin" >> ~/.bashrc
  echo "export PATH=$M2:$PATH" >> ~/.bashrc
}

# -------------------- Centos ingredients -----------------------
install_java_centos() {
  yum update
  yum install java-1.8.0-openjdk-devel
}

install_maven_centos() {
  wget http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz
  tar xvf apache-maven-3.5.2-bin.tar.gz
  mv apache-maven-3.5.2  /usr/local/maven
  echo "export M2_HOME=/usr/local/apache-maven" >> ~/.bashrc
  echo "export M2=$M2_HOME/bin" >> ~/.bashrc
  echo "export PATH=$M2:$PATH" >> ~/.bashrc
  rm -r apache-maven-3.5.2-bin.tar.gz
}

# -------------------- Shared ingredients -----------------------
install_bundler() {
  gem install bundler
}

install_rails() {
  gem install rails -v 5.1.4
}

# -------------------- Sugar ------------------------------------
spinnerComplex() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}
