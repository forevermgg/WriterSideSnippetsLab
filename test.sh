#!/bin/sh

# 执行 du -d 1 -h 命令
du_output=$(du -d 1 -h)
echo "Output of 'du -d 1 -h':"
echo "$du_output"

# 执行 git rev-list 相关命令
git_objects=$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -50 | awk '{print$1}')
git_rev_list_output=$(git rev-list --objects --all | grep "$git_objects")
echo "Output of 'git rev-list' command:"
echo "$git_rev_list_output"