可以通过 adb devices 命令查看当前已经连接的设备：

```zsh
❯ adb devices
* daemon not running; starting now at tcp:5037
* daemon started successfully
List of devices attached
```

如果想指定 a38b2e8 设备来运行 adb 命令，可以采用 -s <deviceId> 的方式

```zsh
adb -s a38b2e8 install demo.apk
```
