#ifndef MOKOU_H
#define MOKOU_H

#include <QObject>
#include <QMediaPlayer>

class QEventLoop;
class Firebird;
class VkApi;

class Mokou : public QObject
{
    Q_OBJECT
public:
    explicit Mokou(QObject *parent = 0);
    void selectCircles();
    void selectAlbums();
    void clearOrder();

signals:
    void newPlElement(QVariantMap);
    void newVkAudioId(QString&);
    void newSongPos(int);
    void songStarted(int);
    void songPaused(int);
    void songChanged(int);

    void newAlbumMap(QVariantMap);
    void newTrackListElement(QVariantMap);
    void newTrackData(QVariantMap);
    void newCircleMap(QVariantMap);

public slots:

    void saveUrl(QString&);
    void buttonPlay(int);
    void buttonPause();
    void buttonStop();
    void playNextInList(QMediaPlayer::MediaStatus);
    void tokenFromUrl(QString);
    void setSongPos(qint64);
    void moveAlbumIndex(int  pathIndex);
    void openAlbum(int);
    void addAlbumToTL(int album_id);
    void playFromPL(int plRow);
    void playFromTL(int tlRow);
    void pausePlayer2();

private:
    Firebird *fb;
    VkApi *vkApi;
    QMediaPlayer *player;

    bool authorized;
    QString user_id, token;

    QString statement;
    int currentRow;
    int plSize;
    //int currentAlbum, preIndex, albumsCount;

    QList<int> plOrder;
    QList<int> tlOrder;

    QString secToTime(int sec);
    QVariantMap trackData;

    QString audioUrl;
    QMediaPlayer *player2;

    void selectVkTrack(int plRow);
    void addAlbumToPL(int);
    void sendPlElement(QVariantMap);
    void playUrl(QString&);
    void fadeInStart(QMediaPlayer*);
    void fadeOut(QMediaPlayer*);
    void delay(int msec);
};

#endif // MOKOU_H
