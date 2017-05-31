#!/bin/bash

function printHelp {
    echo "The correct way to use this script is ./postbuilder.sh (path to orgfile) modifier"
    echo "This builds and commits the post for your pleasure"
    echo "Some modifiers worth knowing: a and u."
    echo "The former has to be used when you've made a small error"
    echo "The latter is when you need to update an older post."
}

if [[ ! -f "$1" ]]; then
    echo "File not found"
    printHelp
    exit 1
fi

cd "$BLOG_HOME/src"
bundle exec jekyll build
cd ..
git add .

filename=$(basename "$1")
switch=${2:-"d"}
commit_message="Creating post $filename"
force=""


if [ "$switch" == "u" ]; then
    commit_message="Updating post $filename"
fi

if [ "$switch" == "a" ]; then
    force="-f"
    git commit -m "$commit_message" --amend
else
    git commit -m "$commit_message"
fi

git push origin master "$force"
