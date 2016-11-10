#include "vkapi.h"

#include <QDebug>
#include <QNetworkReply>

VkApi::VkApi()
{

}

void VkApi::setToken(QString &newToken)
{
    token = newToken;
}

void VkApi::requestAudio(QString &idCouple)
{
    QUrl vkRequest("https://api.vk.com/method/audio.getById?audios=" + idCouple + "&v=5.53&access_token=" + token);
    qDebug() << vkRequest;
    QNetworkAccessManager * manager = new QNetworkAccessManager();
    vkReply = manager->get(QNetworkRequest(vkRequest));
    connect(vkReply, SIGNAL(finished()), this, SLOT(vkReplyParse()));
    qDebug() << "request done";
}

void VkApi::vkReplyParse()
{
    qDebug() << "parse start";
    bool ok;
    JsonObject result = QtJson::parse(QString(vkReply->readAll()),ok).toMap();

    QList<QString> resultkeys = result.keys();
    if (resultkeys[0] == "error") {
        qDebug() << "ERROR: access to vk is unsucsessful. return";
        return;
    }

    JsonArray jsonArray = result["response"].toList();
    JsonObject items = jsonArray[0].toMap();
    QString url = items["url"].toString();
    lastArtist = items["artist"].toString();
    lastSong = items["title"].toString();

    emit urlReceived(url);
    qDebug() << "parse end";
}

QString &VkApi::getArtist()
{
    return lastArtist;
}

QString &VkApi::getSong()
{
    return lastSong;
}
