### find javah
```cmake
# find javah
find_package(Java COMPONENTS Development)
if (NOT Java_Development_FOUND)
    if (DEFINED ENV{JAVA_HOME} AND EXISTS "$ENV{JAVA_HOME}/bin/javah")
        set(Java_JAVAH_EXECUTABLE "$ENV{JAVA_HOME}/bin/javah")
    elseif (EXISTS "/usr/bin/javah")
        set(Java_JAVAH_EXECUTABLE "/usr/bin/javah")
    else()
        message(FATAL_ERROR "Cannot find javah")
    endif()
endif()
```