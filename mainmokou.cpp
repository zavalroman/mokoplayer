#include "mainmokou.h"
#include "ui_mainmokou.h"

#include "firebird.h"
#include "login.h"
#include "vkapi.h"

#include <QDebug>
#include <QFile>

MainMokou::MainMokou(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainMokou)
{
    ui->setupUi(this);

    vkApi = new VkApi();
    fb = new Firebird();
    player = new QMediaPlayer(this, QMediaPlayer::StreamPlayback);
    playListModel = new QStringListModel(this);

    QPixmap pixmap;
    pixmap.load("200px-Mokou.png");
    ui->imageLabel->setPixmap(pixmap);

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

    connect(this, SIGNAL(newIdCouple(QString&)), vkApi, SLOT(requestAudio(QString&)));
    connect(vkApi, SIGNAL(urlReceived(QString&)), this, SLOT(playUrl(QString&)));
    connect(player, SIGNAL(positionChanged(qint64)), this, SLOT(setSongSlider(qint64)));
}

MainMokou::~MainMokou()
{
    delete ui;
}

void MainMokou::on_actionLogin_triggered()
{
    Login login;
    //if (!authorized)
        login.exec();

    if (login.authorized) {
        authorized = login.authorized;
        user_id = login.user_id;
        token = login.token;
        vkApi->setToken(token);
        QFile cache("cache");
        if(cache.open(QIODevice::WriteOnly)) {
            QTextStream writeStream(&cache);
            writeStream << token;
            cache.close();
        }
        qDebug() << "login ok";
    } else { qDebug() << "login ne ok"; }
}

void MainMokou::on_actionAll_tracks_triggered()
{
    QStringList textList;

    statement = "SELECT unicode FROM translit INNER JOIN track ON track.title_id = translit.id";
    //SELECT unicode,vk_id,to_id FROM translit INNER JOIN track ON track.title_id = translit.id INNER JOIN vktrackxtrack ON vktrackxtrack.track_id = track.id INNER JOIN vktrack ON vktrack.id = vktrackxtrack.vktrack_id
    fb->query(statement, &textList);
    playListModel->setStringList(textList);

    ui->playList->setModel(playListModel);

}

void MainMokou::on_playButton_clicked()
{
    QList<QStringList> idCouple;
    QList<int> duration;
    int row = ui->playList->currentIndex().row() + 1;

    if (savedRow==row) { //if pause
        player->play();
        return;
    }

    savedRow = row;
    statement = "SELECT duration FROM vktrack WHERE id = " + QString::number(row);
    fb->query(statement, &duration);
    qDebug() << "duration:" << duration.at(0);
    ui->songSlider->setMaximum(duration.at(0));

    statement = "SELECT vktrack.vk_id,vktrack.to_id FROM vktrack INNER JOIN vktrackxtrack ON vktrack.id = vktrackxtrack.vktrack_id WHERE vktrackxtrack.track_id = " + QString::number(row);
    fb->query(statement, &idCouple);
    qDebug() << idCouple[0].at(0) << idCouple[0].at(1);
    QString idCo = idCouple[0].at(1) + "_" + idCouple[0].at(0);

    emit newIdCouple(idCo);
}

void MainMokou::playUrl(QString &url)
{
    ui->artistLabel->setText(vkApi->getArtist());
    ui->songNameLabel->setText(vkApi->getSong());

    player->setMedia(QUrl(url));
    player->setVolume(80);
    player->play();
}

void MainMokou::on_pauseButton_clicked()
{
    player->pause();
}

void MainMokou::on_stopButton_clicked()
{
    player->stop();
}

void MainMokou::setSongSlider(qint64 songPosition)
{
    int secPos = songPosition / 1000;
    ui->songSlider->setValue(secPos);

    QString MM = QString::number(secPos/60);
    QString SS = QString::number(secPos%60);
    ui->songTimeLabel->setText(MM + ":" + SS);

}
