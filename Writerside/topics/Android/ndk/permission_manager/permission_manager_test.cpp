
#define LOG_TAG "PermissionManagerNativeTest"

#include <android/permission_manager.h>
#include <android-base/logging.h>
#include <gtest/gtest.h>


TEST_F(PermissionManagerNativeTest, testCheckPermission) {
    pid_t selfPid = ::getpid();
    uid_t selfUid = ::getuid();

    LOG(INFO) << "testCheckPermission: uid " << selfUid << ", pid" << selfPid;

    // Test is set up to force unroot by RootTargetPreparer, so we should be running as SHELL.
    // Check some permissions SHELL should definitely have or not have.
    int32_t result;
    EXPECT_EQ(APermissionManager_checkPermission("android.permission.DUMP",
                                                 selfPid, selfUid, &result),
              PERMISSION_MANAGER_STATUS_OK);
    EXPECT_EQ(result, PERMISSION_MANAGER_PERMISSION_GRANTED);

    EXPECT_EQ(APermissionManager_checkPermission("android.permission.MANAGE_USERS",
                                                 selfPid, selfUid, &result),
              PERMISSION_MANAGER_STATUS_OK);
    EXPECT_EQ(result, PERMISSION_MANAGER_PERMISSION_DENIED);

    EXPECT_EQ(APermissionManager_checkPermission("android.permission.NETWORK_STACK",
                                                 selfPid, selfUid, &result),
              PERMISSION_MANAGER_STATUS_OK);
    EXPECT_EQ(result, PERMISSION_MANAGER_PERMISSION_DENIED);
}
