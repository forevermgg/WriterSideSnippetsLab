## $ANDROID_HOME/tools/bin/sdkmanager --list 报错

```Bash
❯ $ANDROID_HOME/tools/bin/sdkmanager --list
Exception in thread "main" java.lang.NoClassDefFoundError: javax/xml/bind/annotation/XmlSchema
	at com.android.repository.api.SchemaModule$SchemaModuleVersion.<init>(SchemaModule.java:156)
	at com.android.repository.api.SchemaModule.<init>(SchemaModule.java:75)
	at com.android.sdklib.repository.AndroidSdkHandler.<clinit>(AndroidSdkHandler.java:81)
	at com.android.sdklib.tool.sdkmanager.SdkManagerCli.main(SdkManagerCli.java:73)
	at com.android.sdklib.tool.sdkmanager.SdkManagerCli.main(SdkManagerCli.java:48)
Caused by: java.lang.ClassNotFoundException: javax.xml.bind.annotation.XmlSchema
	at java.base/jdk.internal.loader.BuiltinClassLoader.loadClass(BuiltinClassLoader.java:581)
	at java.base/jdk.internal.loader.ClassLoaders$AppClassLoader.loadClass(ClassLoaders.java:178)
	at java.base/java.lang.ClassLoader.loadClass(ClassLoader.java:521)
	... 5 more
```
sdkmanager 使用的lib目录
```Bash
❯ pwd
/Users/centforever/Library/Android/sdk/tools/lib
❯ ls
android.el                           jcommander-1.64.jar
animal-sniffer-annotations-1.14.jar  jcommon-1.0.12.jar
annotations-12.0.jar                 jfreechart-1.0.9.jar
annotations-13.0.jar                 jfreechart-swt-1.0.9.jar
annotations-26.0.0-dev.jar           jimfs-1.1.jar
apkanalyzer-cli.jar                  jobb-26.0.0-dev.jar
apkanalyzer.jar                      jopt-simple-4.9.jar
archquery-26.0.0-dev.jar             jsilver-1.0.0.jar
asm-5.1.jar                          jsr305-1.3.9.jar
asm-analysis-5.1.jar                 jsr305-3.0.0.jar
asm-tree-5.1.jar                     jython-standalone-2.5.3.jar
asset-studio-26.0.0-dev.jar          kotlin-reflect-1.1.3-2.jar
baksmali-2.2.1.jar                   kotlin-stdlib-1.1.3-2.jar
bcpkix-jdk15on-1.56.jar              kxml2-2.3.0.jar
bcprov-jdk15on-1.56.jar              layoutlib-api-26.0.0-dev.jar
binary-resources.jar                 lint-26.0.0-dev.jar
builder-model-3.0.0-dev.jar          lint-api-26.0.0-dev.jar
chimpchat-26.0.0-dev.jar             lint-checks-26.0.0-dev.jar
common-26.0.0-dev.jar                lombok-ast-0.2.3.jar
commons-codec-1.6.jar                manifest-merger-26.0.0-dev.jar
commons-compress-1.12.jar            monitor-x86_64
commons-logging-1.1.1.jar            monkeyrunner-26.0.0-dev.jar
ddmlib-26.0.0-dev.jar                org-eclipse-core-commands-3.6.0.jar
ddms-26.0.0-dev.jar                  org-eclipse-equinox-common-3.6.0.jar
ddmuilib-26.0.0-dev.jar              org-eclipse-jface-3.6.2.jar
devices.xml                          osgi-4.0.0.jar
dexlib2-2.2.1.jar                    proguard-project.txt
dvlib-26.0.0-dev.jar                 protobuf-java-3.0.0.jar
ecj-4.6.1.jar                        repository-26.0.0-dev.jar
error_prone_annotations-2.0.18.jar   screenshot2-26.0.0-dev.jar
explainer.jar                        sdk-common-26.0.0-dev.jar
fakeadbserver-26.0.0-dev.jar         sdklib-26.0.0-dev.jar
fat32lib.jar                         shared.jar
generator.jar                        swtmenubar-26.0.0-dev.jar
gson-2.3.jar                         traceview-26.0.0-dev.jar
guava-22.0.jar                       trove4j-20160824.jar
hierarchyviewer2lib-26.0.0-dev.jar   uast-26.0.0-dev.jar
httpclient-4.2.6.jar                 uiautomatorviewer-26.0.0-dev.jar
httpcore-4.2.5.jar                   util-2.2.1.jar
httpmime-4.1.jar                     x86
intellij-core-26.0.0-dev.jar         x86_64
j2objc-annotations-1.1.jar
```
在 /Users/centforever/Library/Android/sdk/tools/lib 添加
activation-1.1.1.jar
jaxb-api-2.3.1.jar
jaxb-core-2.3.0.1.jar
jaxb-impl-2.3.2.jar
```Bash
❯ ls -lta
total 110520
drwxr-xr-x  90 centforever  staff      2880 11  4 11:27 .
-rw-r--r--@  1 centforever  staff      6148 11  4 11:27 .DS_Store
-rw-r--r--@  1 centforever  staff   1017695 11  4 11:27 jaxb-impl-2.3.2.jar
-rw-r--r--@  1 centforever  staff    254858 11  4 11:26 jaxb-core-2.3.0.1.jar
-rw-r--r--@  1 centforever  staff    128076 11  4 11:25 jaxb-api-2.3.1.jar
-rw-r--r--@  1 centforever  staff     69409 11  4 11:20 activation-1.1.1.jar
```
原来
CLASSPATH=$APP_HOME/lib/dvlib-26.0.0-dev.jar:$APP_HOME/lib/jimfs-1.1.jar:$APP_HOME/lib/jsr305-1.3.9.jar:$APP_HOME/lib/repository-26.0.0-dev.jar:$APP_HOME/lib/j2objc-annotations-1.1.jar:$APP_HOME/lib/layoutlib-api-26.0.0-dev.jar:$APP_HOME/lib/gson-2.3.jar:$APP_HOME/lib/httpcore-4.2.5.jar:$APP_HOME/lib/commons-logging-1.1.1.jar:$APP_HOME/lib/commons-compress-1.12.jar:$APP_HOME/lib/annotations-26.0.0-dev.jar:$APP_HOME/lib/error_prone_annotations-2.0.18.jar:$APP_HOME/lib/animal-sniffer-annotations-1.14.jar:$APP_HOME/lib/httpclient-4.2.6.jar:$APP_HOME/lib/commons-codec-1.6.jar:$APP_HOME/lib/common-26.0.0-dev.jar:$APP_HOME/lib/kxml2-2.3.0.jar:$APP_HOME/lib/httpmime-4.1.jar:$APP_HOME/lib/annotations-12.0.jar:$APP_HOME/lib/sdklib-26.0.0-dev.jar:$APP_HOME/lib/guava-22.0.jar
后面新增
:$APP_HOME/lib/activation-1.1.1.jar:$APP_HOME/lib/jaxb-api-2.3.1.jar:$APP_HOME/lib/jaxb-core-2.3.0.1.jar:$APP_HOME/lib/jaxb-impl-2.3.2.jar
保存 
执行
```Bash
Available Updates:
  ID                                             | Installed | Available
  -------                                        | -------   | -------
  cmdline-tools;latest                           | 9.0       | 11.0
  emulator                                       | 32.1.12   | 32.1.15
  platform-tools                                 | 34.0.1    | 34.0.5
  platforms;android-33                           | 2         | 3
  system-images;android-26;default;arm64-v8a     | 1         | 2
  system-images;android-32;google_apis;arm64-v8a | 6         | 7

~ ❯ $ANDROID_HOME/tools/bin/sdkmanager --list
```



