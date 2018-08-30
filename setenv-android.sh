#!/bin/bash

_ARM_ARCH_PREFIX="arm-linux-androideabi"
_ANDROID_ARCH="arch-arm"
_ANDROID_API="android-14"

#####################################################################
#standalone-toolchain
_STANDALONE_TOOLCHAIN_ROOT=/tmp/arm-android-toolchain
if [ -d $_STANDALONE_TOOLCHAIN_ROOT ]; then
    rm -fR $_STANDALONE_TOOLCHAIN_ROOT
fi

$ANDROID_NDK_ROOT/build/tools/make-standalone-toolchain.sh --arch=arm --platform=$_ANDROID_API --install-dir=$_STANDALONE_TOOLCHAIN_ROOT
# Error checking
if [ ! -d "${_STANDALONE_TOOLCHAIN_ROOT}" ]; then
  echo "Error: $_STANDALONE_TOOLCHAIN_ROOT is not a valid path. Please edit this script."
fi

#####################################################################
#toolchain
ANDROID_TOOLCHAIN="$_STANDALONE_TOOLCHAIN_ROOT/bin"
# Error checking
if [ -z "$ANDROID_TOOLCHAIN" ] || [ ! -d "$ANDROID_TOOLCHAIN" ]; then
  echo "Error: $ANDROID_TOOLCHAIN is not valid. Please edit this script."
fi

case $_ANDROID_ARCH in
	arch-arm)	  
      ANDROID_TOOLS="$_ARM_ARCH_PREFIX-gcc $_ARM_ARCH_PREFIX-ranlib $_ARM_ARCH_PREFIX-ld"
	  ;;
	arch-x86)	  
      ANDROID_TOOLS="$_ARM_ARCH_PREFIX-gcc $_ARM_ARCH_PREFIX-ranlib $_ARM_ARCH_PREFIX-ld"
	  ;;	  
	*)
	  echo "ERROR ERROR ERROR"
	  ;;
esac

for tool in $ANDROID_TOOLS
do
  # Error checking
  if [ ! -e "$ANDROID_TOOLCHAIN/$tool" ]; then
    echo "Error: Failed to find $tool. Please edit this script."
  fi
done

if [ ! -z "$ANDROID_TOOLCHAIN" ]; then
  export ANDROID_TOOLCHAIN="$ANDROID_TOOLCHAIN"
  export PATH="$ANDROID_TOOLCHAIN":"$PATH"
fi

#####################################################################
#sysroot
ANDROID_SYSROOT="$_STANDALONE_TOOLCHAIN_ROOT/sysroot"
# Error checking
if [ -z "$ANDROID_SYSROOT" ] || [ ! -d "$ANDROID_SYSROOT" ]; then
  echo "Error: ANDROID_SYSROOT is not valid. Please edit this script."
fi

export CROSS_SYSROOT="$ANDROID_SYSROOT"
#export ANDROID_DEV="$ANDROID_SYSROOT/usr"

#####################################################################
# Most of these should be OK (MACHINE, SYSTEM, ARCH). RELEASE is ignored.
export MACHINE=armv7
export RELEASE=2.6.37
export SYSTEM=android
export ARCH=arm
export CROSS_COMPILE="${_ARM_ARCH_PREFIX}-"

if [ "$_ANDROID_ARCH" == "arch-x86" ]; then
	export MACHINE=i686
	export RELEASE=2.6.37
	export SYSTEM=android
	export ARCH=x86
	# export CROSS_COMPILE="i686-linux-android-"
fi

export RANLIB=$ANDROID_TOOLCHAIN/${CROSS_COMPILE}ranlib

VERBOSE=1
if [ ! -z "$VERBOSE" ] && [ "$VERBOSE" != "0" ]; then
  echo "ANDROID_ARCH: $_ANDROID_ARCH"
  #echo "ANDROID_EABI: $_ANDROID_EABI"
  echo "ANDROID_API: $_ANDROID_API"
  echo "CROSS_SYSROOT: $CROSS_SYSROOT"
  echo "ANDROID_TOOLCHAIN: $ANDROID_TOOLCHAIN"
  #echo "FIPS_SIG: $FIPS_SIG"
  echo "CROSS_COMPILE: $CROSS_COMPILE"
  #echo "ANDROID_DEV: $ANDROID_DEV"
  echo "RANLIB: $RANLIB"
fi
