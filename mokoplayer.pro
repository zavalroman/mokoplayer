#-------------------------------------------------
#
# Project created by QtCreator 2016-08-23T19:56:24
#
#-------------------------------------------------

#QT       += core gui webkitwidgets multimediawidgets
QT += qml quick webkitwidgets multimediawidgets

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = mokoplayer
TEMPLATE = app


SOURCES += main.cpp\
        mainmokou.cpp \
    ibpp/_dpb.cpp \
    ibpp/_ibpp.cpp \
    ibpp/_ibs.cpp \
    ibpp/_rb.cpp \
    ibpp/_spb.cpp \
    ibpp/_tpb.cpp \
    ibpp/array.cpp \
    ibpp/blob.cpp \
    ibpp/database.cpp \
    ibpp/date.cpp \
    ibpp/dbkey.cpp \
    ibpp/events.cpp \
    ibpp/exception.cpp \
    ibpp/row.cpp \
    ibpp/service.cpp \
    ibpp/statement.cpp \
    ibpp/time.cpp \
    ibpp/transaction.cpp \
    ibpp/user.cpp \
    firebird.cpp \
    login.cpp \
    qt-json-master/json.cpp \
    vkapi.cpp \
    qmlhandler.cpp \
    mokou.cpp

HEADERS  += mainmokou.h \
    ibpp/_ibpp.h \
    ibpp/ibase.h \
    ibpp/iberror.h \
    ibpp/ibpp.h \
    firebird.h \
    login.h \
    qt-json-master/json.h \
    vkapi.h \
    qmlhandler.h \
    mokou.h

FORMS    += mainmokou.ui \
    login.ui

DISTFILES += \
    ibpp/libibpp.so \
    MokoQml.qml \
    PlayListModel.qml

QMAKE_CXXOUTPUT = -o
QMAKE_CXXFLAGS += -DIBPP_LINUX
QMAKE_CXXFLAGS += -W -Wall -fPIC
QMAKE_CXXFLAGS += -g -DDEBUG

LIBS += -lfbclient -lcrypt -lm -ldl -lpthread # dependancies for shared library

RESOURCES += \
    qml.qrc

