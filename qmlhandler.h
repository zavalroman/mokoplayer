#ifndef QMLHANDLER_H
#define QMLHANDLER_H

#define MOKOU "/develop/mokou/"

#include <QObject>
#include <QVariant>

class Mokou;

class QmlHandler : public QObject
{
    Q_OBJECT
public:
    explicit QmlHandler(QObject *parent = 0);

private slots:
    void plAppend(QVariantMap);
    void setSongPos(int);
    void setCover(QString); //?
    void changeSongStatusToPlay(int);
    void changeSongStatusToPause(int);
    void changeSongStatusToBlank(int);

    void createSelectRelations(QObject *);
    void alAppend(QVariantMap);
    void clearModel();
    void tlAppend(QVariantMap);
    void fillPlayerData(QVariantMap);
    void clAppend(QVariantMap);

signals:

private:
    QObject *qml;
    Mokou *mokou;
    QString home;

    QObject * selectQml;

    void setHome(QString path);
};

#endif // QMLHANDLER_H
