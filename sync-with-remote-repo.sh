#!/usr/bin/env bash

echo "--> Synchonising with remote Git repository"
DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(cd $DIR && git pull)
