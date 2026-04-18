#!/bin/bash
cd "$(dirname "$0")"

ssh -p33233 git@tcp.fiz.ovh "git init --bare test.git"

export GIT_SSH_COMMAND="ssh -p33233"
git clone git@tcp.fiz.ovh:test.git

git log --oneline
git restore --staged --worktree . --source=2754038
git clean -fd
