#ifndef MAINMOKOU_H
#define MAINMOKOU_H

#include <QMainWindow>
#include <QMediaPlayer>
#include <QStringListModel>

class Firebird;
class VkApi;

namespace Ui {
class MainMokou;
}

class MainMokou : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainMokou(QWidget *parent = 0);
    ~MainMokou();

private slots:
    void playUrl(QString &);
    void setSongSlider(qint64);

    void on_actionAll_tracks_triggered();

    void on_playButton_clicked();

    void on_pauseButton_clicked();

    void on_stopButton_clicked();

    void on_actionLogin_triggered();
signals:
    void newIdCouple(QString &);

private:
    Ui::MainMokou *ui;

    bool authorized;
    QString user_id, token;

    VkApi * vkApi;
    Firebird * fb;
    QMediaPlayer * player;

    QString statement;
    QStringListModel * playListModel;

    int savedRow;

};

#endif // MAINMOKOU_H
