#!/bin/bash

# -------------------- Mac OS ingredients -----------------------
install_jenv_macos() {
  printf "${LIGHT_BLUE} --> Installing jenv${NC}\n"
  brew install jenv
}

install_java_macos() {
  printf "${LIGHT_BLUE} --> Installing Java 8${NC}\n"
  brew tap caskroom/versions 2>/dev/null
  brew cask install java8
}

install_maven_macos() {
  printf "${LIGHT_BLUE} --> Installing Maven${NC}\n"
  brew update
  brew install maven
}

install_miniconda_macos() {
  printf "${LIGHT_BLUE} --> Installing Miniconda${NC}\n"
  wget http://repo.continuum.io/miniconda/Miniconda3-3.7.0-Linux-x86_64.sh -O ~/miniconda.sh
  bash ~/miniconda.sh -b -p $HOME/miniconda
  echo "export PATH=$HOME/miniconda/bin:$PATH" >> ~/.bash_profile
}

install_python_macos() {
  printf "${LIGHT_BLUE} --> Installing Python${NC}\n"
  brew update
  brew install python
}

install_rbenv_macos() {
  printf "${LIGHT_BLUE} --> Installing rbenv${NC}\n"
  brew update
  brew install rbenv
  rbenv init
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
}

install_ruby_macos() {
  printf "${LIGHT_BLUE} --> Installing Ruby${NC}\n"
  brew update
  brew install ruby
}

install_git_macos() {
  printf "${LIGHT_BLUE} --> Installing Git${NC}\n"
  brew update
  brew install git
}

install_wget_macos() {
  printf "${LIGHT_BLUE} --> Installing wget${NC}\n"
  brew update
  brew install wget --with-libressl
}

install_vim_macos() {
  printf "${LIGHT_BLUE} --> Installing Vim${NC}\n"
  brew update
  brew install vim
}

install_docker_macos() {
  printf "${LIGHT_BLUE} --> Loading Docker${NC}\n"
  wget https://download.docker.com/mac/stable/Docker.dmg 2>/dev/null &
  spinnerComplex
  printf "${YELLOW} ~~> To install Docker, manually run Docker.dmg file, which could be found in 'preflight-check' folder${NC}\n"
}

install_vagrant_macos() {
  printf "${LIGHT_BLUE} --> Installing Vagrant${NC}\n"
  brew cask install virtualbox
  brew cask install vagrant
}

install_chef_macos() {
  printf "${LIGHT_BLUE} --> Loading Chef-client${NC}\n"
  wget https://packages.chef.io/files/stable/chef/13.6.4/mac_os_x/10.13/chef-13.6.4-1.dmg 2>/dev/null &
  spinnerComplex
  printf "${YELLOW} ~~> To install ChefSDK, manually run chef-13.6.4-1.dmg file, which could be found in 'preflight-check' folder${NC}\n"
}

install_smcfancontrol_macos() {
  printf "${LIGHT_BLUE} --> Installing smcfancontrol${NC}\n"
  brew cask install smcfancontrol
}

install_iterm_macos() {
  printf "${LIGHT_BLUE} --> Downloading iTerm${NC}\n"
  wget https://iterm2.com/downloads/stable/iTerm2-3_1_5.zip 2>/dev/null &
  spinnerComplex
  printf "${YELLOW} ~~> To install iTerm, manually run iTerm2-3_1_5.zip file, which could be found in 'preflight-check' folder${NC}\n"
}

install_homebrew_macos() {
  printf "${LIGHT_BLUE} --> Installing Homebrew${NC}\n"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

install_adshell_macos() {
  printf "${LIGHT_BLUE} --> Installing Adshell${NC}\n"
  git clone https://github.com/AdamWhittingham/adshell --recursive ~/.adshell && ~/.adshell/install
  # Need to sort out ~/.bashrc ~/.bash_profile settings
}

# -------------------- GNU/Linux ingredients --------------------
install_jenv_linux() {
  printf "${LIGHT_BLUE} --> Installing jenv${NC}\n"
  git clone https://github.com/gcuisinier/jenv.git ~/.jenv
  echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(jenv init -)"' >> ~/.bash_profile
  printf "${GREEN} :: Configure JVM in jenv      --> 'jenv add /path/to/java/home'${NC}\n"
  printf "${GREEN} :: Configure which JVM to use --> 'jenv global oracle-1.7.0' or 'jenv local oracle-1.7.0' or 'jenv shell oracle-1.7.0'${NC}\n"
  source ~/.bash_profile
}

install_java_linux() {
  printf "${LIGHT_BLUE} --> Installing Java 8${NC}\n"
  apt-get update
  apt-get install openjdk-8-jre
  apt-get install openjdk-8-jdk
  echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk" >> ~/.bashrc
  echo "export PATH=$PATH:$JAVA_HOME" >> ~/.bashrc
}

install_maven_linux() {
  printf "${LIGHT_BLUE} --> Installing Maven${NC}\n"
  apt-get update
  apt-get install maven
  echo "export M2_HOME=/usr/local/apache-maven" >> ~/.bashrc
  echo "export M2=$M2_HOME/bin" >> ~/.bashrc
  echo "export PATH=$M2:$PATH" >> ~/.bashrc
}

install_git_linux() {
  printf "${LIGHT_BLUE} --> Installing Git${NC}\n"
  apt-get update
  apt-get upgrade
  apt-get install git
}

install_wget_linux() {
  printf "${LIGHT_BLUE} --> Installing wget${NC}\n"
  apt-get install wget
}

install_vim_linux() {
  printf "${LIGHT_BLUE} --> Installing Vim${NC}\n"
  add-apt-repository ppa:jonathonf/vim
  apt update
  apt install vim
}

install_rbenv_linux() {
  printf "${LIGHT_BLUE} --> Installing rbenv${NC}\n"
  sudo apt-get update
  sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  source ~/.bashrc

  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash

  if type -p ruby; then
    echo ""
  else
    printf "${YELLOW} --> As you installed rbenv, you can install Ruby right now${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {Ruby}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          rbenv install -v 2.3.1
          rbenv global 2.3.1
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

install_ruby_linux() {
  printf "${LIGHT_BLUE} --> Installing Ruby${NC}\n"
  apt-get install ruby-full
}

install_docker_linux() {
  printf "${LIGHT_BLUE} --> Installing Docker-CE${NC}\n"
  apt-get update
  apt-get install apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

  apt-get update
  apt-get install docker-ce
}

install_vagrant_linux() {
  printf "${LIGHT_BLUE} --> Installing Vagrant${NC}\n"
  apt-get install virtualbox
  apt-get install vagrant
}

# -------------------- RedHat/Centos ingredients -----------------------
install_jenv_redhat() {
  printf "${LIGHT_BLUE} --> Installing jenv${NC}\n"
  git clone https://github.com/gcuisinier/jenv.git ~/.jenv
  echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(jenv init -)"' >> ~/.bashrc
  printf "${GREEN} :: Configure JVM in jenv      --> 'jenv add /path/to/java/home'${NC}\n"
  printf "${GREEN} :: Configure which JVM to use --> 'jenv global oracle-1.7.0' or 'jenv local oracle-1.7.0' or 'jenv shell oracle-1.7.0'${NC}\n"
  source ~/.bashrc
}

install_java_redhat() {
  printf "${LIGHT_BLUE} --> Installing Java 8${NC}\n"
  yum update
  yum install java-1.8.0-openjdk-devel
}

install_maven_redhat() {
  printf "${LIGHT_BLUE} --> Installing Maven${NC}\n"
  wget http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz
  tar xvf apache-maven-3.5.2-bin.tar.gz
  sudo mv apache-maven-3.5.2  /usr/local/maven
  echo "export M2_HOME=/usr/local/maven" >> ~/.bashrc
  echo "export M2=${M2_HOME}/bin" >> ~/.bashrc
  echo "export PATH=${M2}:${PATH}" >> ~/.bashrc
  rm -r apache-maven-3.5.2-bin.tar.gz
  source ~/.bashrc
}

install_git_redhat() {
  printf "${LIGHT_BLUE} --> Installing Git${NC}\n"
  yum install git
}

install_wget_redhat() {
  printf "${LIGHT_BLUE} --> Installing wget${NC}\n"
  yum install wget
}

install_vim_redhat() {
  printf "${LIGHT_BLUE} --> Installing Vim${NC}\n"
  yum install gcc git ncurses-devel
  git clone https://github.com/vim/vim.git
  mv vim ~/.vim
  cd ~/.vim/src
  make
  make install
}

install_rbenv_redhat() {
  printf "${LIGHT_BLUE} --> Installing rbenv${NC}\n"
  sudo yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl sqlite-devel
  cd ~/
  git clone git://github.com/sstephenson/rbenv.git .rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc

  git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc

  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash

  if type -p ruby; then
    echo ""
  else
    printf "${YELLOW} --> As you installed rbenv, you can install Ruby right now${NC}\n"
    while true; do
      read -p " ~~> Do you wish to install {Ruby}? [Yes/No] " yn
      case $yn in
        [Yy]* )
          rbenv install -v 2.3.1
          rbenv global 2.3.1
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

install_ruby_redhat() {
  printf "${LIGHT_BLUE} --> Installing Ruby${NC}\n"
  sudo yum install ruby
}

install_docker_redhat() {
  printf "${LIGHT_BLUE} --> Installing Docker-CE${NC}\n"
  sudo yum install -y yum-utils device-mapper-persistent-data lvm2
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  sudo yum install docker-ce
}

install_vagrant_redhat() {
  printf "${LIGHT_BLUE} --> Installing Vagrant${NC}\n"
  sudo yum -y install gcc dkms make qt libgomp patch
  sudo yum -y install kernel-headers kernel-devel binutils glibc-headers glibc-devel font-forge
  sudo yum-config-manager --add-repo http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo
  sudo yum install -y VirtualBox-5.1

  sudo yum -y install https://releases.hashicorp.com/vagrant/1.9.6/vagrant_1.9.6_i686.rpm
}

# -------------------- Shared ingredients -----------------------
install_bundler() {
  printf "${LIGHT_BLUE} --> Installing Bundler${NC}\n"
  gem install bundler
}

install_rails() {
  printf "${LIGHT_BLUE} --> Installing Ruby-on-Rails${NC}\n"
  gem install rails -v 5.1.4
}

install_adshell() {
  printf "${LIGHT_BLUE} --> Installing Adshell${NC}\n"
  git clone https://github.com/AdamWhittingham/adshell --recursive ~/.adshell && ~/.adshell/install
}

install_nicer_vim_config() {
  printf "${LIGHT_BLUE} --> Installing nicer Vim config${NC}\n"
  git clone https://github.com/AdamWhittingham/vim-config.git ~/.vim && ~/.vim/install
}

install_miniconda() {
  if [ `getconf LONG_BIT` = "64"]; then
    printf "${LIGHT_BLUE} --> Installing Miniconda 64bit${NC}\n"
    wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && bash Miniconda2-latest-Linux-x86_64.sh
  else
    printf "${LIGHT_BLUE} --> Installing Miniconda 32bit${NC}\n"
    wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86.sh && bash Miniconda2-latest-Linux-x86.sh
  fi
}

install_chef() {
  printf "${LIGHT_BLUE} --> Installing Chef-client${NC}\n"
  curl -L https://www.opscode.com/chef/install.sh | sudo bash
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
