git config user.email "centforever@163.com"
git config user.name "forevermgg"
git ls-files '*.md' | xargs dirname | sort
git rev-parse --show-toplevel
GIT_ROOT=$(git rev-parse --show-toplevel)
git rev-parse --abbrev-ref HEAD
git rev-parse --verify HEAD
