# openssl-android-build

Requirement
---
* `android-ndk-r16b`
* `openssl-1.0.1g`

Command
---
* set `ANDROID_NDK_ROOT`
* make toolchain

        $ANDROID_NDK_ROOT/build/tools/make-standalone-toolchain.sh --arch=arm --platform=android-14 --install-dir=/tmp/arm-android-toolchain
* set env
  
        rm -fR openssl-OpenSSL_1_0_1g
        chmod a+x setenv-android-xxx.sh
        tar xzf openssl-1.0.1g.tar.gz
        . ./setenv-android-xxx.sh
* make static lib
  
        cd openssl-OpenSSL_1_0_1g
        ./config no-shared no-ssl2 no-ssl3 no-hw no-engine no-asm --openssldir=/tmp/openssl-android-armv7-build
        make depend
        make all

* what you get

        rm -fR ../build
        mkdir -p ../build/libs
        cp libcrypto.a libssl.a ../build/libs
        mkdir -p ../build/include/openssl
        cp include/openssl/*.* ../build/include/openssl