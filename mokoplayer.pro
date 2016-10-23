#-------------------------------------------------
#
# Project created by QtCreator 2016-08-23T19:56:24
#
#-------------------------------------------------

#QT       += core gui webkitwidgets multimediawidgets
QT += qml quick multimediawidgets #webkitwidgets

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
    ibpp/core/_dpb.cpp \
    ibpp/core/_ibpp.cpp \
    ibpp/core/_ibs.cpp \
    ibpp/core/_rb.cpp \
    ibpp/core/_spb.cpp \
    ibpp/core/_tpb.cpp \
    ibpp/core/all_in_one.cpp \
    ibpp/core/array.cpp \
    ibpp/core/blob.cpp \
    ibpp/core/database.cpp \
    ibpp/core/date.cpp \
    ibpp/core/dbkey.cpp \
    ibpp/core/events.cpp \
    ibpp/core/exception.cpp \
    ibpp/core/row.cpp \
    ibpp/core/service.cpp \
    ibpp/core/statement.cpp \
    ibpp/core/time.cpp \
    ibpp/core/transaction.cpp \
    ibpp/core/user.cpp \
    selecthandler.cpp \
    qt-json/json.cpp

HEADERS  += mainmokou.h \
    firebird.h \
    login.h \
    vkapi.h \
    qmlhandler.h \
    mokou.h \
    ibpp/core/_ibpp.h \
    ibpp/core/ibase.h \
    ibpp/core/iberror.h \
    ibpp/core/ibpp.h \
    selecthandler.h \
    qt-json/json.h \
    userid.h

FORMS    += mainmokou.ui \
    login.ui

DISTFILES += \
    #ibpp/core/libibpp.so \
    MokoQml.qml \
    PlayListModel.qml

QMAKE_CXXOUTPUT = -o
QMAKE_CXXFLAGS += -DIBPP_LINUX
QMAKE_CXXFLAGS += -W -Wall -fPIC
QMAKE_CXXFLAGS += -g -DDEBUG

LIBS += -lfbclient -lcrypt -lm -ldl -lpthread # dependancies for shared library

RESOURCES += \
    qml.qrc

