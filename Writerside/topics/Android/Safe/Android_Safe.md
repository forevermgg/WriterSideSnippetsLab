# 安全

## 检测你手机有没有锁屏密码

```Java
// 检测手机是否有锁屏密码
public static boolean isHasUnlockPassword(Context context) {
    KeyguardManager km = (KeyguardManager) context.getSystemService(Context.KEYGUARD_SERVICE);
    return km.isDeviceSecure() && km.isKeyguardSecure();
}
```

## 通过binder检测是否真的有SIM卡

## build.prop修改时间

```Java
// 检测build.prop是否安全
public static boolean isBuildPropSecure() {
    File file = new File("/system/build.prop");
    return file.lastModified() / 1000 % 1000 == 0;
}
```

## 检测手机上的应用商店包名

```Java
// 获取手机上的应用市场列表
public static String[] getAppMarketList(Context context) {
    PackageManager pm = context.getPackageManager();
    Intent intent = new Intent();
    intent.setAction("android.intent.action.MAIN");
    intent.addCategory("android.intent.category.APP_MARKET");
    List<ResolveInfo> list = pm.queryIntentActivities(intent);
    String res[] = new String[list.size()];
    for(int i = 0;i < list.size(); i++) {
        res[i] = list.get(i).activityInfo.packageName;
    }
    return res;
}
```
