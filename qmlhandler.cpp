#include "qmlhandler.h"
#include "mokou.h"

#include <QDebug>

QmlHandler::QmlHandler(QObject *parent)
{
    qml = parent;
    mokou = new Mokou();

    connect(qml, SIGNAL(playClicked(int)),            mokou, SLOT(buttonPlay(int)));                      //play button pressed
    connect(qml, SIGNAL(plDoubleClicked(int)),    mokou, SLOT(playFromPL(int)));    //playlist double clicked
    connect(qml, SIGNAL(pauseClicked()),              mokou, SLOT(buttonPause()));
    connect(qml, SIGNAL(stopClicked()),                 mokou, SLOT(buttonStop()));
    connect(qml, SIGNAL(sendLoginUrl(QString)), mokou, SLOT(tokenFromUrl(QString)));
    connect(qml, SIGNAL(selectOpened(QObject*)),              this, SLOT(createSelectRelations(QObject*)));

    connect(mokou, SIGNAL(newPlElement(QVariantMap)), this, SLOT(plAppend(QVariantMap)));
    connect(mokou, SIGNAL(newSongPos(int)),                       this, SLOT(setSongPos(int)));

    connect(mokou, SIGNAL(songStarted(int)),                       this, SLOT(changeSongStatusToPlay(int)));
    connect(mokou, SIGNAL(songPaused(int)),                       this, SLOT(changeSongStatusToPause(int)));
    connect(mokou, SIGNAL(songChanged(int)),                    this, SLOT(changeSongStatusToBlank(int)));

    connect(mokou, SIGNAL(newAlbumMap(QVariantMap)),      this, SLOT(alAppend(QVariantMap)));
    connect(mokou, SIGNAL(newTrackData(QVariantMap)), this, SLOT(fillPlayerData(QVariantMap)));

   // mokou->openAlbum(0); // 0 - select last added album
    //mokou->openAlbum(1); // 1 -select first added album
    //mokou->openAlbum(3);
    QString pic = "200px-Mokou.png";
    //QString pic = "prohodi.jpg";
    setCover(pic);
}

void QmlHandler::createSelectRelations(QObject* selectRoot)
{
    selectQml = selectRoot;
    mokou->selectAlbums();

    connect(selectQml, SIGNAL(needClearPlaylist()), this, SLOT(clearModel()));

    connect(selectQml, SIGNAL(wantOpenAlbum(int)), mokou, SLOT(openAlbum(int)));
    connect(selectQml, SIGNAL(needTrackList(int)), mokou, SLOT(addAlbumToTL(int)));
    connect(selectQml, SIGNAL(tlDoubleClicked(int)), mokou, SLOT(playFromTL(int)));
    connect(selectQml, SIGNAL(needPause()), mokou, SLOT(pausePlayer2()));

    connect(mokou, SIGNAL(newTrackListElement(QVariantMap)), this, SLOT(tlAppend(QVariantMap)));
}

void QmlHandler::clearModel()
{
    mokou->clearOrder();
    QMetaObject::invokeMethod(qml, "clearModel", Q_ARG(QVariant, QVariant::fromValue(0)));
}

void QmlHandler::alAppend(QVariantMap album)
{
    QMetaObject::invokeMethod(selectQml, "alAppend", Q_ARG(QVariant, QVariant::fromValue(album)));
}

void QmlHandler::plAppend(QVariantMap plElement)
{
    QMetaObject::invokeMethod(qml, "plAppend", Q_ARG(QVariant, QVariant::fromValue(plElement)));
}

void QmlHandler::tlAppend(QVariantMap tlElement)
{
    QMetaObject::invokeMethod(selectQml, "tlAppend", Q_ARG(QVariant, QVariant::fromValue(tlElement)));
}

void QmlHandler::fillPlayerData(QVariantMap newData)
{
    QMetaObject::invokeMethod(qml, "fillPlayerData", Q_ARG(QVariant, QVariant::fromValue(newData)));
}

void QmlHandler::setSongPos(int sPos)
{
    QMetaObject::invokeMethod(qml, "setSongPos", Q_ARG(QVariant, QVariant::fromValue(sPos)));
}

void QmlHandler::setCover(QString cover)
{
    QMetaObject::invokeMethod(qml, "setCover", Q_ARG(QVariant, QVariant::fromValue(cover)));
}

void QmlHandler::changeSongStatusToPlay(int id)
{
    QMetaObject::invokeMethod(qml, "changeSongStatusToPlay", Q_ARG(QVariant, QVariant::fromValue(id)));
}

void QmlHandler::changeSongStatusToPause(int id)
{
    QMetaObject::invokeMethod(qml, "changeSongStatusToPause", Q_ARG(QVariant, QVariant::fromValue(id)));
}

void QmlHandler::changeSongStatusToBlank(int id)
{
    QMetaObject::invokeMethod(qml, "changeSongStatusToBlank", Q_ARG(QVariant, QVariant::fromValue(id)));
}
