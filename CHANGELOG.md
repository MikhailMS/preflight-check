## 22 January, 2018:
- [x] There were an error with deduplication, caused by the fact, that on Centos 7 there is no perl by default
- [x] Discovered, that the order of check for Linux/RedHat/Centos is important -> change it to work as it should

## 23 January, 2018:
- [x] Added checks for installation - if no wget, git or homebrew installed, then user cannot performe installation of missing packages
  - [x] Checks before downloading _Git_
  - [x] Checks before downloading _Miniconda_
  - [x] Checks before downloading _Java_
  - [x] Checks before downloading _Maven_
  - [x] Checks before downloading _jenv_
  - [x] Checks before downloading _Homebrew_
  - [x] Checks before downloading _Vim_
  - [x] Checks before downloading _wget_
  - [x] Checks before downloading _Adshell_
  - [x] Checks before downloading _Ruby-on-Rails_
  - [x] Checks before downloading _Bundler_
  - [ ] Checks before downloading _Python_
  - [x] Checks before downloading _Ruby_
  - [x] Checks before downloading _Docker_
  - [x] Checks before downloading _Vagrant_
  - [x] Checks before downloading _ChefSDK_
  - [x] Checks before downloading _Vim config with nice plugins_
- [x] Added extra info text for user, so user knows what script does
- [x] Updated README
- [x] Fixed an issue with Vim installation - I deleted vim after it's been installed :/
- [x] Spotted wrong method name to install Maven on Redhat/Centos systems
- [x] Fixed Maven installation
- [x] Fixed jenv installation
- [x] Fixed rbenv installation
- [x] Fixed Miniconda installation
- [x] Added source_bash_file method to complete setup after script finishes
- [x] Increased Ruby version to 2.4.2

## 24 January, 2018:
- [x] Added `sudo` to all required commands on MacOS/Linux/RedHat
- [x] Added source for Maven installation
- [x] Deleting downloaded files after installation completed

## 31 JANUARY, 2018:
- [x] Delted redundant functions
- [x] Jenv installation on MacOS is fixed (it's not added mandatory lines to .bashrc file)

## 16 FEBRUARY, 2018:
- [x] Added Gradle check

## 26 FEBRUARY, 2018:
- [x] Added Rust check
