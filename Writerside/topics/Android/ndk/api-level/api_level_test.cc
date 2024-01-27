
#include <android/api-level.h>

if (android_get_device_api_level() >= __ANDROID_API_Q__) {
} else {
}


int api_level = android_get_device_api_level();



#include <mutex>
#include <sys/system_properties.h>

#ifdef __ANDROID__

uint32_t sApiLevel = 0;
std::once_flag sApiLevelOnceFlag;

int api_level() {
    std::call_once(sApiLevelOnceFlag, []() {
        char sdkVersion[PROP_VALUE_MAX];
        __system_property_get("ro.build.version.sdk", sdkVersion);
        sApiLevel = atoi(sdkVersion);
    });
    return sApiLevel;
}

#else




#include <dlfcn.h>
#include <errno.h>
#include <pthread.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <sys/stat.h>  /* for fdstat() */
#include <fcntl.h>

#include <sys/system_properties.h>

/* Technical note regarding reading system properties.
 *
 * Try to use the new __system_property_read_callback API that appeared in
 * Android O / API level 26 when available. Otherwise use the deprecated
 * __system_property_get function.
 *
 * For more technical details from an NDK maintainer, see:
 * https://bugs.chromium.org/p/chromium/issues/detail?id=392191#c17
 */

/* Weak symbol import */
void __system_property_read_callback(
    const prop_info* info,
    void (*callback)(
        void* cookie, const char* name, const char* value, uint32_t serial),
    void* cookie) __attribute__((weak));

/* Callback used with __system_property_read_callback. */
static void prop_read_int(void* cookie,
                          const char* name,
                          const char* value,
                          uint32_t serial) {
  *(int *)cookie = atoi(value);
  (void)name;
  (void)serial;
}

static int system_property_get_int(const char* name) {
  int result = 0;
  if (__system_property_read_callback) {
    const prop_info* info = __system_property_find(name);
    if (info)
      __system_property_read_callback(info, &prop_read_int, &result);
  } else {
    char value[PROP_VALUE_MAX] = {};
    if (__system_property_get(name, value) >= 1)
      result = atoi(value);
  }
  return result;
}

static int device_api_level() {
  static int s_api_level = -1;
  if (s_api_level < 0)
    s_api_level = system_property_get_int("ro.build.version.sdk");
  return s_api_level;
}