#ifndef VKAPI_H
#define VKAPI_H

#include "qt-json-master/json.h"

#include <QNetworkAccessManager>

using QtJson::JsonObject;
using QtJson::JsonArray;

class VkApi : public QObject
{
    Q_OBJECT

public:
    VkApi();

    void setToken(QString &);
    QString &getArtist();
    QString &getSong();

private slots:
    void vkReplyParse();
    void requestAudio(QString &);

signals:
    void urlReceived(QString &);

private:
    QNetworkReply * vkReply;
    QString token;
    QString lastArtist;
    QString lastSong;
};

#endif // VKAPI_H
