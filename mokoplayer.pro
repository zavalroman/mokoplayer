#-------------------------------------------------
#
# Project created by QtCreator 2016-08-23T19:56:24
#
#-------------------------------------------------


QT += qml quick multimediawidgets webengine

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = mokoplayer
TEMPLATE = app


SOURCES += main.cpp\
        mainmokou.cpp \
    firebird.cpp \
    login.cpp \
    vkapi.cpp \
    qmlhandler.cpp \
    mokou.cpp \
    ibpp/core/all_in_one.cpp \
    selecthandler.cpp \
    qt-json/json.cpp

HEADERS  += mainmokou.h \
    firebird.h \
    login.h \
    vkapi.h \
    qmlhandler.h \
    mokou.h \
    ibpp/core/ibpp.h \
    selecthandler.h \
    qt-json/json.h \
    userid.h

FORMS    += mainmokou.ui \
    login.ui

RESOURCES += \
    qml.qrc

QMAKE_CXXOUTPUT = -o
unix: {
    QMAKE_CXXFLAGS += -DIBPP_LINUX
    QMAKE_CXXFLAGS += -W -Wall -fPIC
    QMAKE_CXXFLAGS += -g -DDEBUG
    LIBS += -lfbclient -lcrypt -lm -ldl -lpthread # dependancies for shared library
}
win32: {
    QMAKE_CXXFLAGS += -DIBPP_WINDOWS
    DEFINES += IBPP_WINDOWS=value
    LIBS += Advapi32.lib #thanx for https://blog.cppse.nl/firebird-ibpp-non-unicode-project
}
