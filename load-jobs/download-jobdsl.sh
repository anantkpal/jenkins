#!/bin/bash

set -euo pipefail

###########################################################################
# Defaults
JENKINS_HOME="/var/jenkins_home"
JOBDSL_DIR="${JENKINS_HOME}/jobdsl"
REPOS_FILE="${JENKINS_HOME}/repo-configurations/${ENV_NAME}.txt"
TEMP_REPOS_DIR="/tmp/repos"

cd "${JENKINS_HOME}"
rm -rf repo-configurations
git clone ${REPO_LIST_GIT_URI} repo-configurations

get_job_dslfiles() {

  echo "$(date) START JENKINS SETUP"

  if [ -d "${TEMP_REPOS_DIR}" ]; then
    rm -rf "${TEMP_REPOS_DIR}" && echo "Cleaned TEMP_REPOS_DIR"
    mkdir -vp "${TEMP_REPOS_DIR}"
  else
    mkdir -vp "${TEMP_REPOS_DIR}"
  fi

  echo "Get JOB DSL files from git repos - ${REPOS_FILE}"

  # Get job dsl files from git repos
  if [ -f ${REPOS_FILE} ]; then
    echo "${REPOS_FILE} found!"
    if [ -d "${JOBDSL_DIR}" ]; then
      rm -rf "${JOBDSL_DIR}" && echo "Cleaned JOBDSL_DIR"
      mkdir -vp "${JOBDSL_DIR}"
    else
      mkdir -vp "${JOBDSL_DIR}"
    fi
    while IFS='' read -r repo || [[ -n "$repo" ]]; do

        # To speed up grabbing of jobdsl files in bitbucket (github doesnt support archive!!)
        git clone -n --depth 1 "${repo}.git" "${TEMP_REPOS_DIR}/${repo##*/}"
        (cd "${TEMP_REPOS_DIR}/${repo##*/}" && git checkout HEAD "${repo##*/}.jobdsl")
        mv -v "${TEMP_REPOS_DIR}/${repo##*/}/${repo##*/}.jobdsl" "${JOBDSL_DIR}"
    done < "${REPOS_FILE}"
  else
    echo "${REPOS_FILE} does not exist, this should be mounted in"
  fi

  rm -rf "${TEMP_REPOS_DIR}" && echo "Cleaned TEMP_REPOS_DIR" &

}

main() {
  get_job_dslfiles
}

main "$@"
