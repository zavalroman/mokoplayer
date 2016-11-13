#include "mokou.h"
#include "firebird.h"
#include "vkapi.h"

#include <QRegularExpression>
#include <QFile>
#include <QDebug>
#include <QEventLoop>
#include <QTimer>

Mokou::Mokou(QObject *parent) : QObject(parent)
{
    fb = new Firebird();
    vkApi = new VkApi();
    player = new QMediaPlayer(this, QMediaPlayer::StreamPlayback);
    player2 = new QMediaPlayer(this, QMediaPlayer::StreamPlayback);

    QFile cache;
    cache.setFileName("cache");
    if (cache.exists()) {
        if(cache.open(QIODevice::ReadOnly)) {
            token = cache.readLine();
            vkApi->setToken(token);
            authorized = true;
            cache.close();
        }
    }

    plSize = 0;
    /*-------------fill model with all tracks-------------*
    QString artist, song, duration;
    QList<QStringList> nameList;
    QList<int> durations;

    statement = "SELECT artist,title FROM vktrack";
    fb->query(statement, &nameList);
    statement = "SELECT duration FROM vktrack";
    fb->query(statement, &durations);

    for ( int i = 0; i < nameList.size(); i++) {
        artist = nameList[i].at(0);
        song = nameList[i].at(1);
        duration = secToTime(durations[i]);
        addPlElement(artist, song, duration);
    }
    /*------------------------end fill------------------------*/

    connect(this,    SIGNAL(newVkAudioId(QString&)), vkApi, SLOT(requestAudio(QString&)));
    connect(vkApi, SIGNAL(urlReceived(QString&)), this, SLOT(saveUrl(QString&)));
    connect(player, SIGNAL(mediaStatusChanged(QMediaPlayer::MediaStatus)), this, SLOT(playNextInList(QMediaPlayer::MediaStatus)));
    connect(player, SIGNAL(positionChanged(qint64)), this, SLOT(setSongPos(qint64)));
    //conneect(player, SIGNAL())
}

void Mokou::pausePlayer2()
{
    if (player2->state() == QMediaPlayer::PausedState) {
        fadeInStart(player2);
    } else {
        fadeOut(player2);
        player2->pause();
    }
}

void Mokou::saveUrl(QString &url)
{
    audioUrl = url;
}

void Mokou::playUrl(QString &url)
{
    trackData.insert("artist",vkApi->getArtist());
    trackData.insert("title",vkApi->getSong());

    emit newTrackData(trackData);

    player->setMedia(QUrl(url));
    player->setVolume(80);
    fadeInStart(player);
    //emit songStarted(currentRow);
}

void Mokou::buttonPlay(int plRow)
{
    if (player2->state() == QMediaPlayer::PlayingState) {
        fadeOut(player2);
        player2->pause();
    }
    if (player->state() == QMediaPlayer::PausedState) {
        fadeInStart(player);
        emit songStarted(currentRow);
    }
    if (player->state() == QMediaPlayer::StoppedState) {
        selectVkTrack( plOrder.at(plRow) );
    }
}

void Mokou::buttonPause()
{
    fadeOut(player);
    player->pause();
    emit songPaused(currentRow);
}

void Mokou::buttonStop()
{
    fadeOut(player);
    player->stop();
    emit songChanged(currentRow);
}

void Mokou::setSongPos(qint64 msPos)
{
    int sPos = int(msPos / 1000);
    emit newSongPos(sPos);
}

void Mokou::playNextInList(QMediaPlayer::MediaStatus status)
{
    qDebug() << status;

    if (status == QMediaPlayer::EndOfMedia) {
        emit songChanged(currentRow);
        if (currentRow + 2 > plSize) { // заменить на plOrder.size?
            fadeOut(player);
            player->stop();
            currentRow = 0;
            qDebug() << "reach end of the playlist";
            return;
        }
        currentRow++;
        selectVkTrack( plOrder.at(currentRow) );
        emit songStarted(currentRow);
        playUrl(audioUrl);
    }
}

void Mokou::playFromPL(int plRow) // main window's playlist
{
    if (player->state() == QMediaPlayer::PlayingState) { // iru ka
        fadeOut(player);
        player->stop();
        //emit songPaused(currentRow);
    }

    if (player2->state() == QMediaPlayer::PlayingState) {
        fadeOut(player2);
        player2->stop();
    }

    if (currentRow != plRow) {
        emit songChanged(currentRow);
        currentRow = plRow;
    }

    selectVkTrack( plOrder.at(plRow) );
    emit songStarted(currentRow);
    playUrl(audioUrl);
}

void Mokou::playFromTL(int tlRow) // select window's tracklist
{
    if (player->state() == QMediaPlayer::PlayingState) {
        fadeOut(player);
        player->pause();
        emit songPaused(currentRow);
    }
    /*
    if (player2->state() == QMediaPlayer::PlayingState) {
        player2->stop();
    }
    */
    //emit songChanged(currentRow);

    selectVkTrack( tlOrder.at(tlRow) );
    player2->setMedia(QUrl(audioUrl));
    player2->setVolume(80);
    fadeInStart(player2);

}

void Mokou::selectVkTrack(int track_id)
{   
    QList<QStringList> idCouple;
    QList<int> intList;
    QVariantMap newMusic;

    trackData.clear();
    intList.clear();
    statement = "SELECT duration FROM track WHERE id = " + QString::number(track_id);
    fb->query(statement, &intList);
    trackData.insert("posbar",intList.at(0));

    intList.clear();
    statement = "SELECT album_id FROM track WHERE id = " + QString::number(track_id);
    fb->query(statement, &intList);
    QString pic = QString::number(intList.at(0));
    trackData.insert("cover", pic);

    statement = "SELECT vk_id,to_id FROM vktrack INNER JOIN track ON track.vktrack_id = vktrack.id WHERE track.id = " + QString::number(track_id);
    fb->query(statement, &idCouple);
    QString vkAudioId = idCouple[0].at(1) + "_" + idCouple[0].at(0);
    emit newVkAudioId(vkAudioId);

    QEventLoop loop;
    connect(vkApi, SIGNAL(urlReceived(QString&)), &loop, SLOT(quit()));
    loop.exec(); // wait for url
}

QString Mokou::secToTime(int sec)
{
    QString ssStr;
    QString mm = QString::number(sec/60);
    int ssInt = sec%60;
    if (ssInt<10) {
        ssStr = "0" + QString::number(ssInt);
    } else {
        ssStr = QString::number(ssInt);
    }
    QString mmss = mm + ":" + ssStr;
    return mmss;
}

void Mokou::sendPlElement(QVariantMap plElement)
{
    plSize++;
    emit newPlElement(plElement);
}

void Mokou::tokenFromUrl(QString url)
{
    QRegularExpression re;
    re.setPattern("access_token");
    QRegularExpressionMatch match = re.match(url);
    if (match.hasMatch()) {
        QStringList urlSplitList = url.split("#");

        if (urlSplitList.size()>1) {
            if (strcmp(&urlSplitList[1].toStdString().c_str()[0],"a")) {

               token = urlSplitList[1].split("&")[0].split("=")[1];
               user_id = urlSplitList[1].split("=")[3];
               authorized = true;
                qDebug() << token << user_id;
                vkApi->setToken(token);

                QFile cache("cache");
                if(cache.open(QIODevice::WriteOnly)) {
                    QTextStream writeStream(&cache);
                    writeStream << token;
                    cache.close();
                }
                qDebug() << "login ok";
                return;
            }
        }
        qDebug() << "login ne ok";
        authorized = false;
    }
}

void Mokou::addAlbumToTL(int album_id) // for track list from select album window
{
    QList<int> intList;
    QList<QStringList> stringArray;
    QString artist, song, duration;

    statement = "SELECT id FROM track WHERE album_id = " + QString::number(album_id);
    fb->query(statement, &intList);
    tlOrder = intList;
    statement = "SELECT vktrack.duration FROM vktrack INNER JOIN track ON track.vktrack_id = vktrack.id WHERE track.album_id = " + QString::number(album_id);
    fb->query(statement, &intList);
    statement = "SELECT vktrack.artist,vktrack.title FROM vktrack INNER JOIN track ON track.vktrack_id = vktrack.id WHERE track.album_id = " + QString::number(album_id);
    fb->query(statement, &stringArray);

    for ( int i = 0; i < stringArray.size(); i++ ) {
        QVariantMap tlElement;
        tlElement.insert("artist", stringArray[i].at(0));
        tlElement.insert("song", stringArray[i].at(1));
        tlElement.insert("duration", secToTime(intList[i]));
        tlElement.insert("status", "");
        emit newTrackListElement(tlElement);
    }
}

void Mokou::addAlbumToPL(int album_id)
{
    QList<int> intList;
    QList<QStringList> stringArray;
    QString artist, song, duration;

    if (album_id == 0) {
        statement = "SELECT MAX(id) FROM album";
        fb->query(statement, &intList);
        album_id = intList.at(0);
    }
    statement = "SELECT id FROM track WHERE album_id = " + QString::number(album_id);
    fb->query(statement, &intList);
    plOrder.append(intList);
    statement = "SELECT vktrack.duration FROM vktrack INNER JOIN track ON track.vktrack_id = vktrack.id WHERE track.album_id = " + QString::number(album_id);
    fb->query(statement, &intList);
    statement = "SELECT vktrack.artist,vktrack.title FROM vktrack INNER JOIN track ON track.vktrack_id = vktrack.id WHERE track.album_id = " + QString::number(album_id);
    fb->query(statement, &stringArray);
    for ( int i = 0; i < stringArray.size(); i++ ) {
        QVariantMap plElement;
        plElement.insert("artist", stringArray[i].at(0));
        plElement.insert("song", stringArray[i].at(1));
        plElement.insert("duration", secToTime(intList[i]));
        plElement.insert("status", "");
        //sendPlElement(plElement);
        plSize++;
        emit newPlElement(plElement);
    }
}

void Mokou::openAlbum(int id)
{
    qDebug() << id;
    addAlbumToPL(id);
}

void Mokou::selectCircles()
{
    QVariantMap circleMap;
    QStringList circleList;
    circleMap.insert("circle", "All");
    emit newCircleMap(circleMap);
    statement = "SELECT circle.name_unic FROM circle";
    fb->query(statement, &circleList);
    for (int i = 0; i < circleList.size(); i++) {
        circleMap.clear();
        circleMap.insert("circle", circleList.at(i));
        emit newCircleMap(circleMap);
    }
}

void Mokou::selectAlbums()
{
    QVariantMap albumMap;
    QList<QStringList> albumList;
    statement = "SELECT album.title_unic,circle.name_unic FROM album INNER JOIN circle ON circle.id = album.circle_id";
    fb->query(statement, &albumList);
    //albumsCount = albumList.size();
    for (int i = 0; i < albumList.size(); i++) {
        albumMap.insert("album", albumList[i].at(0));
        albumMap.insert("coverPath", QString::number(i+1));
        albumMap.insert("circle", albumList[i].at(1));
        emit newAlbumMap(albumMap);
    }
    //currentAlbum = 0;
    //preIndex = 0;
}

void Mokou::moveAlbumIndex(int pathIndex)
{
    qDebug() << pathIndex;

    qDebug() << "hi";
}

void Mokou::clearOrder()
{
    plSize = 0;
    plOrder.clear();

}

void Mokou::fadeInStart(QMediaPlayer *pr)
{
    pr->setVolume(10);
    delay(80);
    pr->play();
    for (int i=20; i<=100; i+=10) {
        delay(80);
        pr->setVolume(i);
    }
}

void Mokou::fadeOut(QMediaPlayer *pr)
{
    for (int i=pr->volume(); i>0; i-=10) {
        delay(110-(i*i/100));
        pr->setVolume(i);
    }
}


void Mokou::delay(int msec)
{
    QEventLoop loop;
    QTimer::singleShot(msec, &loop, SLOT(quit()));
    loop.exec();
}

