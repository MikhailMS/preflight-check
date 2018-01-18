#!/bin/bash
internet_connection() {
  wget -q --tries=10 --timeout=20 --spider http://google.com
  if [[ $? -eq 0 ]]; then
    printf "Internet connectivity checek\n --> Online\n"
  else
    printf "Internet connectivity check\n --> Offline\n"
  fi
}

get_var () {
    eval 'printf "%s\n" "${'"$1"'}"'
}
set_var () {
    eval "$1=\"\$2\""
}

deduplicate() {
    printf "PATH Deduplication\n"
    pathvar_name="$1"
    pathvar_value="$(get_var "$pathvar_name")"
    deduped_path="$(perl -e 'print join(":",grep { not $seen{$_}++ } split(/:/, $ARGV[0]))' "$pathvar_value")"
    set_var "$pathvar_name" "$deduped_path"
    printf " --> Completed\n"
}

verify_java_setup() {
  printf "Checking Java setup\n"
  if type -p java; then
    printf " --> Found Java executable in PATH\n"
    _java=java
  elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
    printf " --> Found Java executable in JAVA_HOME\n"
    _java="$JAVA_HOME/bin/java"
  else
    printf "Java is not available - Check JAVA_HOME or PATH\n"
  fi

  if [[ "$_java" ]]; then
    java_version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    printf " --> Java version $java_version is installed\n"
    if [[ "$version" < "1.7" ]]; then
      printf "Please upgrade your Java to version 1.7 or above\n"
    fi
  fi
}

verify_python_setup() {
  printf "Checking Python setup\n"
  if type -p python; then
    printf " --> Found Python executable in PATH\n"
    python_version=`python --version 2>&1 | awk '{print $2}'`
    printf " --> Python version $python_version is installed\n"
  else
    printf " --> No Python executable is found\n"
  fi
}

verify_ruby_setup() {
  printf "Checking Ruby setup\n"
  if type -p ruby; then
    printf " --> Found Ruby executable in PATH\n"
    ruby_version=`ruby -v | awk '{print $2}'`
    printf " --> Ruby version $ruby_version is installed\n"
  else
    printf " --> No Ruby executable is found\n"
  fi
}

verify_docker_setup() {
  printf "Checking Docker setup\n"
  if type -p docker; then
    printf " --> Found Docker executable in PATH\n"
    docker_version=`docker --version | awk '{print $3}' | sed 's/,*$//g'`
    printf " --> Docker version $docker_version is installed\n"
  else
    printf " --> No Docker executable is found\n"
  fi
}

verify_vagrant_setup() {
  printf "Checking Vagrant setup\n"
  if type -p vagrant; then
    printf " --> Found Vagrant executable in PATH\n"
    vagrant_version=`vagrant --version | awk '{print $2}'`
    printf " --> Vagrant version $vagrant_version is installed\n"
  else
    printf " --> No Vagrant executable is found\n"
  fi
}

verify_chef_setup() {
  printf "Checking Chef setup\n"
  if type -p chef-client; then
    printf " --> Found Chef executable in PATH\n"
    chef_version=`chef-client -version | awk '{print $2}'`
    printf " --> Chef version $chef_version is installed\n"
  else
    printf " --> No Chef executable is found\n"
  fi
}

verify_git_setup() {
  printf "Checking Git setup\n"
  if type -p git; then
    printf " --> Git is installed"
    git_version=`git --version | awk '{print $3}'`
    printf " --> Git version $git_version is installed\n"
  else
    printf " --> No Git executable is found\n"
  fi
}

verify_vim_setup() {
  printf "Checking Vim setup\n"
  if type -p vim; then
    printf " --> Vim executable in PATH\n"
    vim_version=`vim --version | grep "VIM" | awk '{print $5}' | tr -d '\n'`
    printf " --> Vim version $vim_version is installed\n"

  else
    printf " --> No Vim executable is found\n"
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
