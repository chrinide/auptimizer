#!/usr/bin/env bash
# Publish documentation on github.io
# Copyright (c) 2018 LG Electronics Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
set -e 

flag=$(python -c 'import platform; major, minor, patch = platform.python_version_tuple();print(major=="3" and minor=="7")')

if [ $flag == "False" ]; then
  echo "Only publish with python3.7"
  exit 0
fi


COMMIT=$(git show --format="%h" --no-patch)

cd docs
make html

cd ../..
git clone -b gh-pages "https://$GH_TOKEN@github.com/$ORG/$REPO.git" gh-pages
cd gh-pages


git config user.name "Travis Builder"
git config user.email "$EMAIL"


sed 's/docs\/images\/demo.gif/_images\/demo.gif/g' ../$REPO/README.md > ./README.md

cp ../$REPO/AuptimizerBlackLong.png .
cp -R ../$REPO/docs/_build/html/* ./
git add -A .
git commit -m "[ci skip] Autodoc commit for $COMMIT."
git push -q origin gh-pages
