#!/usr/bin/env bash

# set -x
set -e
set -u

unset i

# goes out and checks for latest git commits
ORG=emacs-mirror
REPO=emacs
BRANCH=emacs-28
TEMPOUT=$(mktemp)

curl -s https://api.github.com/repos/$ORG/$REPO/commits/$BRANCH > "${TEMPOUT}"

E_DATE=$(cat "${TEMPOUT}" | jq -r '.commit.author.date')
E_CDATE=$(date --date="${E_DATE}" +%Y%m%d)
export E_CDATE

E_COMMIT=$(cat "${TEMPOUT}" | jq -r '.commit.tree.sha')
export E_COMMIT

cat ./templates/emacs.spec | sed "s/E_COMMIT/${E_COMMIT}/" | sed "s/E_CDATE/${E_CDATE}/"  > emacs.spec
