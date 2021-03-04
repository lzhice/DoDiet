QT += quick quickcontrols2 svg printsupport
CONFIG += c++11


# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        cpp/main.cpp \
        cpp/pdfcreator.cpp

RESOURCES +=  \
        qml/qml.qrc \
        svg/svg.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += $$PWD/qml

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

VERSION = 1.0.0
DEFINES += VERSION=\\\"$$VERSION\\\"
DEFINES += VERSION_CODE=1 # DON'T add Space before and after =
android{
    DISTFILES += \
        app/android/AndroidManifest.xml \
        app/android/build.gradle \
        app/android/gradle/wrapper/gradle-wrapper.jar \
        app/android/gradle/wrapper/gradle-wrapper.properties \
        app/android/gradlew \
        app/android/gradlew.bat \
        app/android/res/values/libs.xml

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/app/android
    ANDROID_VERSION_CODE = $$VERSION_CODE
    ANDROID_VERSION_NAME = $$VERSION
    include(projects/openssl/openssl.pri)
}

win32{

}

HEADERS += \
    cpp/pdfcreator.h

