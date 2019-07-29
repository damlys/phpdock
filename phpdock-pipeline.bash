#!/usr/bin/env bash
set -e

# Function displays "\n*** 23:59:59 *** Foo bar baz **********************************************...\n\n"
terminalColumnsCount="$(tput cols || echo 120)"
function printSeparator() {
  local row="*** $(date "+%T") *** $1 ***"
  while [[ "${#row}" -lt "$terminalColumnsCount" ]]
  do
    row="$row*"
  done
  printf "\n$row\n\n"
}

printSeparator "Deploying local Docker registry"
docker volume create --driver=local docker_registry_data
docker start docker_registry || docker run \
  --detach \
  --restart always \
  --publish 5000:5000 \
  --mount type=volume,source=docker_registry_data,destination=/var/lib/registry \
  --name docker_registry \
registry:latest

printSeparator "Creating Docker cache volumes"
docker volume create --driver=local global_composer_cache

export VERSION="0.0.1-example"
printSeparator "PHPdock: initialising v$VERSION"

for component in \
  'php-web-server-foundation' \
  'php-web-server-app' \
  'php-web-server-tester' \
  'php-web-server-compose'
do
  printSeparator "PHPdock: entering component $component"
  cd $component
  pwd

  if [[ -f .examples/.env ]]
  then
    printSeparator "$component *** use example deployment configuration"
    ln -sfv .examples/.env .
  fi

  if [[ -x scripts/build.bash ]]
  then
    printSeparator "$component/scripts/build.bash (unreleased)"
    VERSION="unreleased" scripts/build.bash
  fi
  for script in \
    'scripts/build.bash' \
    'scripts/test.bash' \
    'scripts/publish.bash' \
    'scripts/deploy.bash' \
    'scripts/bootstrap.bash' \
    'scripts/reset-files-permissions.bash' \
    'scripts/run-unit-tests.bash' \
    'scripts/run-target-tests.bash' \
    'scripts/destroy.bash'
  do
    if [[ -x "$script" ]]
    then
      printSeparator "$component/$script"
      $script
    fi
  done

  printSeparator "PHPdock: leaving component $component"
  cd ..
  pwd
done

printSeparator "PHPdock: project is ready to explore!"
