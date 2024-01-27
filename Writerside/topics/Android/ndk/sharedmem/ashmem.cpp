#include <errno.h>
#include <assert.h>
#include <stdio.h>



#ifdef __ANDROID__
#   include <sys/ioctl.h>
#   include <sys/stat.h>
#   include <memory.h>
#   include <dlfcn.h>
#   include <linux/ashmem.h>
#   include <android/api-level.h>
#   include <android/sharedmem.h>
#endif

#if __ANDROID_API__ >= 26

// Starting with API 26 (Oreo) we have ASharedMemory
int ashmem_create_region(const char *name, size_t size) {
    return ASharedMemory_create(name, size);
}

#else

static int __ashmem_open() {
    int ret;
    struct stat st;

    int fd = open("/dev/ashmem", O_RDWR);
    if (fd < 0) {
        return fd;
    }

    ret = fstat(fd, &st);
    if (ret < 0) {
        int save_errno = errno;
        close(fd);
        errno = save_errno;
        return ret;
    }
    if (!S_ISCHR(st.st_mode) || !st.st_rdev) {
        close(fd);
        errno = ENOTTY;
        return -1;
    }

    return fd;
}

int ashmem_create_region(const char *name, size_t size) {
    // Fetch the API level to avoid dlsym() on API 19
    if (api_level() >= 26) {
        // dynamically check if we have "ASharedMemory_create" (should be the case since 26 (Oreo))
        using TASharedMemory_create = int(*)(const char *name, size_t size);
        TASharedMemory_create pfnASharedMemory_create =
                (TASharedMemory_create)dlsym(RTLD_DEFAULT, "ASharedMemory_create");
        if (pfnASharedMemory_create) {
            return pfnASharedMemory_create(name, size);
        }
    }

    int ret, save_errno;
    int fd = __ashmem_open();
    if (fd < 0) {
        return fd;
    }

    if (name) {
        char buf[ASHMEM_NAME_LEN] = {0};

        strlcpy(buf, name, sizeof(buf));
        ret = ioctl(fd, ASHMEM_SET_NAME, buf);
        if (ret < 0) {
            goto error;
        }
    }

    ret = ioctl(fd, ASHMEM_SET_SIZE, size);
    if (ret < 0) {
        goto error;
    }

    return fd;

error:
    save_errno = errno;
    close(fd);
    errno = save_errno;
    return ret;
}

#endif // __ANDROID_API__ >= 26