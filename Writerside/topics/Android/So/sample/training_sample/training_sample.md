
```Bash
file training_sample                                                                
training_sample: Mach-O 64-bit executable arm64

brew install arm-linux-gnueabihf-binutils
==> Downloading https://ghcr.io/v2/homebrew/core/arm-linux-gnueabihf-binutils/manifests/2.41
############################################################################################################################################ 100.0%
==> Fetching arm-linux-gnueabihf-binutils
==> Downloading https://ghcr.io/v2/homebrew/core/arm-linux-gnueabihf-binutils/blobs/sha256:3aba2d4a7f901272d7533b144e5dbeafcaf7d3cfc45d8d79fe890fa3
############################################################################################################################################ 100.0%
==> Pouring arm-linux-gnueabihf-binutils--2.41.arm64_sonoma.bottle.tar.gz
🍺  /opt/homebrew/Cellar/arm-linux-gnueabihf-binutils/2.41: 106 files, 43.2MB
==> Running `brew cleanup arm-linux-gnueabihf-binutils`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).


```
find . -type f -exec grep -Iq . {} \; -print 




.shstrtab 的内容在这个在文件中的偏移为 s_offset 所指示，也就是 0x196A 。我们随便找另外一个节来找该节的名字：

这个节的 sh_name 在 .shstrtab 中的偏移是 0xea , 故在文件中的偏移为 0x196A + 0xea = 0x1a54