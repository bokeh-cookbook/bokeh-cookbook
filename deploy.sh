#!/usr/bin/env bash
BRANCH=master
TARGET_REPO=bokeh-cookbook/bokeh-cookbook.github.io.git
PELICAN_OUTPUT_FOLDER=output

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
    echo -e "Starting to deploy to Github Pages\n"
    if [ "$TRAVIS" == "true" ]; then
        git config --global user.email "travis@travis-ci.org"
        git config --global user.name "Travis"
    fi
    #using token clone gh-pages branch
    echo -e "git clone\n"
    git clone --quiet --branch=$BRANCH https://${GH_TOKEN}@github.com/$TARGET_REPO built_website > /dev/null
    #go into directory and copy data we're interested in to that directory
    cd built_website
    rsync -rv --exclude=.git  ../$PELICAN_OUTPUT_FOLDER/* .
    #add, commit and push files
    git add -f .
    echo -e "git commit\n"
    git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to Github Pages"
    echo -e "git push\n"
    git push -fq https://${GH_TOKEN}@github.com/$TARGET_REPO origin $BRANCH > /dev/null
    echo -e "Deploy completed\n"
fi
