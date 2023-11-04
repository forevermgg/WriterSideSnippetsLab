## Gradle管理Cmake
```Gradle
ext.cppFlags = [
        "-std=c++17",
        "-fno-stack-protector",
        "-fno-exceptions",
        "-fno-unwind-tables",
        "-fno-asynchronous-unwind-tables",
        "-fno-rtti",
        "-ffast-math",
        "-fno-finite-math-only",
        "-ffp-contract=fast",
        "-fvisibility-inlines-hidden",
        "-fvisibility=hidden",
        "-fomit-frame-pointer",
        "-ffunction-sections",
        "-fdata-sections",
        "-no-canonical-prefixes",
        "-Wformat",
        "-Werror=format-security",
        "-Wno-unused-command-line-argument",
        "-Wl,--gc-sections",
        "-Wl,-Bsymbolic-functions",
        "-Wl,--hash-style=both", // Required to support API levels below 23
    ]
    
    externalNativeBuild {
       cmake {
          cppFlags.addAll(rootProject.ext.cppFlags)
       }
    }
```