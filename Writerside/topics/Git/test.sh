git config user.email "centforever@163.com"
git config user.name "forevermgg"
git ls-files '*.md' | xargs dirname | sort
git rev-parse --show-toplevel
GIT_ROOT=$(git rev-parse --show-toplevel)
git rev-parse --abbrev-ref HEAD
git rev-parse --verify HEAD

git ls-files -z
git clean -xdf
# Reset the submodules
git submodule foreach 'git reset --hard && git clean -fxd'
git log --since="2023-01-01" --before="2023-12-30" --author="$(git config --get user.name)" --pretty=tformat: --numstat | awk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }'
# 查询提交行数排名前三名
git log --pretty='%aN' | sort | uniq -c | sort -k1 -n -r | head -n 3
# 查询开发者人数
git log --pretty='%aN' | sort -u | wc -l
# 查询总提交次数
git log --oneline | wc -l
# 查询所以人代码行数 可以加指定时间，时间参数，--since：起始时间，--until：终止时间。如果不需要 可以去掉
git log --since="2023-01-01" --before="2023-12-31" --pretty='%aN' | sort -u | while read name; do echo -en "$name\t"; git log --author="$name" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s \n", add, subs, loc }' -; done
# 查看个人指定时期内代码行数，注意将 --author=“user.name” 替换成自己的用户名
git log --since="2023-01-01" --before="2023-12-31" --author="centforever" --pretty=tformat: --numstat | awk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }'
du -d 1 -h

git rev-list --objects --all | \
    grep "$(git verify-pack -v .git/objects/pack/*.idx | \
    sort -k 3 -n | tail -5 | awk '{print$1}')"

git reflog expire --expire=now --all
