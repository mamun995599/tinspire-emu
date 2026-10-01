Ti Nspire CX CAS Emulator (Android)
===================================

Android-only build of the Firebird TI-Nspire emulator (Qt 5 + qmake).
Licensed under GPLv3 (see LICENSE).

Before building
---------------
core/gif-h is a git submodule and is empty in this zip. Fetch it once:

    git clone https://github.com/jacobly0/gif-h core/gif-h

Requirements
------------
* JDK 17
* Android SDK (platform android-32 / build-tools) and NDK r21
* Qt 5.15.2 for Android (arm64_v8a + armv7)

Build (command line)
--------------------
    export ANDROID_SDK_ROOT=$HOME/Android/Sdk
    export ANDROID_NDK_ROOT=$HOME/android-ndk-r21e
    mkdir build && cd build
    /path/to/Qt/5.15.2/android/bin/qmake .. ANDROID_ABIS="arm64-v8a armeabi-v7a"
    make -j4 apk_install_target
    /path/to/Qt/5.15.2/android/bin/androiddeployqt --android-platform android-32 \
        --input android-tinspire-emu-deployment-settings.json \
        --output android-build --apk tinspire-emu.apk

Build (Qt Creator)
------------------
Open firebird.pro, choose the Android Qt 5.15.2 kit, Build > Run.

Branding files
--------------
* App name:  android/AndroidManifest.xml (android:label)
* Icon:      android/res/drawable-*/icon.png
* Splash:    android/res/drawable/splash.xml + drawable-nodpi/splash_logo.png
