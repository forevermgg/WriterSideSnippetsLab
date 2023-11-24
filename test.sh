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

# pdf文档
find ./ -name "*.pdf" | wc -l

# 说明文档
find ./ -name "*.md" | wc -l

# video
grep showterm.io -ur ./0* | wc -l

# demo
# cloc（Count Lines of Code）是一个用于统计源代码行数的命令行工具。您需要先安装cloc才能在终端中使用它。
# 如果您已经安装了Homebrew（macOS上的包管理器），您可以通过以下命令安装cloc：
# brew install cloc
cloc ./

# 详细目录结构
# tree 是一个用于以树状图形式显示目录结构的命令行工具。要在 macOS 上安装 tree，您需要先安装 Homebrew（macOS 上的包管理器），然后使用它来安装 tree。
# 如果您已经安装了 Homebrew，您可以通过以下命令安装 tree：
# brew install tree
tree -L 3 -d ./