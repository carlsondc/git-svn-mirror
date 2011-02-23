#!/bin/sh
if [ $# -lt 1 ]
then
    echo "Usage: $0 mirrorDir"
    exit 1
fi
mirrorDir=$1

cd $mirrorDir

#grab commits
git svn fetch

#for each remote branch
for branchName in $(git branch -r | tr -d ' ' | grep -v '^svn/tags/')
do
    localBranchName=$(echo $branchName | cut -d '/' -f 1 --complement)

    #create new local branch if one doesn't already exist
    matched=$(git branch | tr -d ' ' | grep "^$localBranchName\$" | wc -l)
    if [ $matched -eq 0 ]
    then
        git branch $localBranchName $branchName
    fi

    #rebase remote changes onto local branch
    git rebase $branchName $localBranchName
done

#for each remote tag
for tagName in $(git branch -r | tr -d ' ' | grep '^svn/tags/')
do
    localTag=$(echo $tagName | cut -d '/' -f 1 --complement)
    #update/create local tag
    git update-ref refs/$localTag $tagName
done
