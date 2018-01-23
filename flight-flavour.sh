#!/bin/bash

source check-list.sh
source ingredient-list.sh

macos_flavour() {
  printf "${YELLOW} -->${LIGHT_BLUE} Preflight Checks for Mac OS systems ${YELLOW}<--${NC}\n"
  verify_proxies_setup
  internet_connection
  deduplicate PATH
  verify_bash_files_existence

  verify_homebrew_setup
  verify_git_setup
  verify_wget_setup

  verify_jenv_setup_macos
  verify_java_setup
  verify_maven_setup
  verify_miniconda_setup
  verify_python_setup
  verify_rbenv_setup
  verify_ruby_setup
  verify_bundler_setup
  verify_gem_setup
  verify_rails_setup

  verify_vim_setup
  improve_vim
  verify_docker_setup
  verify_vagrant_setup
  verify_chef_setup
  verify_smcfancontrol_setup
  verify_iterm_setup
  verify_adshell_setup
}

linux_flavour() {
  printf "${YELLOW} -->${LIGHT_BLUE} Preflight Checks for Linux systems ${YELLOW}<--${NC}\n"
  verify_proxies_setup
  internet_connection
  deduplicate PATH
  verify_bash_files_existence

  verify_git_setup
  verify_wget_setup

  verify_jenv_setup_linux_redhat
  verify_java_setup
  verify_maven_setup
  verify_miniconda_setup
  verify_python_setup
  verify_rbenv_setup
  verify_ruby_setup
  verify_bundler_setup
  verify_gem_setup
  verify_rails_setup

  verify_vim_setup
  improve_vim
  verify_docker_setup
  verify_vagrant_setup
  verify_chef_setup
  verify_adshell_setup
}

redhat_flavour() {
  printf "${YELLOW} -->${LIGHT_BLUE} Preflight Checks for Redhat systems ${YELLOW}<--${NC}\n"
  verify_proxies_setup
  internet_connection
  deduplicate PATH
  verify_bash_files_existence

  verify_git_setup
  verify_wget_setup

  verify_jenv_setup_linux_redhat
  verify_java_setup
  verify_maven_setup
  verify_miniconda_setup
  verify_python_setup
  verify_rbenv_setup
  verify_ruby_setup
  verify_bundler_setup
  verify_gem_setup
  verify_rails_setup

  verify_vim_setup
  improve_vim
  verify_docker_setup
  verify_vagrant_setup
  verify_chef_setup
  verify_adshell_setup
}
