# openssl-android-build

Requirement
---
* `clang`
* `android-ndk-r16b`
* `openssl-1.1.0i`

Command
---
* set `ANDROID_NDK_ROOT`

        export ANDROID_NDK_ROOT=...
* set env
  
        rm -fR openssl-1.1.0i
        tar xzf openssl-1.1.0i.tar.gz
        chmod a+x setenv-android.sh
        . ./setenv-android.sh
* make static lib
  
        cd openssl-1.1.0i
        ./config no-shared no-ssl2 no-ssl3 no-hw no-engine no-asm  --openssldir=/tmp/openssl-android-armv7-build
        make build_libs
* what you get

        rm -fR ../build
        mkdir -p ../build/libs
        cp libcrypto.a libssl.a ../build/libs
        mkdir -p ../build/include/openssl
        cp include/openssl/*.* ../build/include/openssl