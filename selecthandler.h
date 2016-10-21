#ifndef SELECTHANDLER_H
#define SELECTHANDLER_H

#include <QObject>

class SelectHandler : public QObject
{
    Q_OBJECT
public:
    explicit SelectHandler(QObject *parent = 0);

signals:

public slots:
};

#endif // SELECTHANDLER_H