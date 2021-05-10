# Preflight-check bash script
Bash script to check if my workstation has everything I need for development

## Currently checks for:
- [ ] Applications / Languages
  - [x] HTTP and HTTPS proxies presence and whether or not they working
  - [x] Internet connectivity
  - [x] Java presence
  - [x] Python presence
  - [x] Ruby presence
  - [x] Vim presence
  - [x] Git presence
  - [ ] Git Flow presence
  - [x] Docker presence
  - [x] Vagrant presence
  - [x] Homebrew presence
  - [x] rbenv presence
  - [x] wget presence
  - [x] Maven presence
  - [x] Gradle presence
  - [x] Bundler presence
  - [x] Miniconda presence
  - [x] iTerm2 presence
  - [x] gem presence
  - [x] Ruby-on-Rails presence
  - [x] Adshell presence
  - [x] jenv presence
  - [x] bash_profile, bashrc files presence
  - [x] Chef client presence
  - [ ] Ansible presence
  - [ ] ChefDK presence
  - [x] Rust presence
- [x] Removes duplicates from PATH variable
- [x] Different checks, depending on OS:
  - [x] Mac OS
  - [x] GNU/Linux/RedHat/Centos
- [x] Downloads missing components:
  - [x] Mac OS
  - [x] GNU/Linux
  - [x] Red Hat/Centos


## Some improvements could be made in the future and extra functionality could be added
- [ ] Think about project structure, as at the moment it is not well build
- [ ] Erase duplicated code as much as possible


## Installation
  1. Download the code
  ```bash
  # If git command installed
  git clone https://github.com/MikhailMS/preflight-check

  # If git command is not found
  curl -LO https://github.com/MikhailMS/preflight-check/archive/master.zip
  unzip master.zip -d preflight-checkp

  # If you are working from behind the proxies, use following command
  curl -x http://your_proxy_server:8080 -LO https://github.com/MikhailMS/preflight-check/archive/master.zip
  unzip master.zip -d preflight-check
  ```
  2. Run scripts
  ``` bash
  cd preflight-check

  # Execute with sudo
  sudo bash preflight-check.sh

  # Or as sudo enabled user
  . preflight-check.sh
  ```
  4. To update, execute `git pull`, when in `preflight-check` folder


## Notes:
  1. Tested on MacOs 10.13 High Sierra, Centos 7
