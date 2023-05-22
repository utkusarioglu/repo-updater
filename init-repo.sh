#!/bin/bash

source ${0%/*}/adjustments.sh
source .repo.config

CONFIG_FILES=".repo.config .repo-template.config .parent-template.config"

check_repo_config() {
  if [ ! -f ".repo.config" ]; then
    echo "Error: .repo.config file needs to be defined for this script to work"

    echo "You need the following values set:"
    echo "REPO_CLASS: A Java style repo class that will be the used as the devcontainer name"
    echo "REPO_PATH: The path at which the repo will be mounted inside the devcontainer"
    echo "REPO_SERVICE: Docker service name that will be assigned to the repo"
    exit 10
  fi
}

check_vars() {
  for var in REPO_CLASS REPO_PATH REPO_SERVICE; do
    if [ -z "${!var}" ]; then
      echo "Error: .repo.config.$var is required for this script to work"
      exit 20
    fi
  done
}

copy_config_files_to_temp() {
  for config_file in $CONFIG_FILES; do
    cp "$config_file" "/tmp/$config_file" 2> /dev/null
  done
}

move_config_files_to_repo_path() {
  for config_file in $CONFIG_FILES; do
    cp "$config_file" "/tmp/$config_file" 2> /dev/null
  done
}

check_repo_config
check_vars
copy_config_files_to_temp

echo "Starting initialization…"
do_adjustments name $REPO_CLASS
do_adjustments workspaceFolder $REPO_PATH
do_adjustments service $REPO_SERVICE

move_config_files_to_repo_path
echo "Starting initialization finished"
