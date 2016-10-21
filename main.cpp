//#include "mainmokou.h"
//#include <QApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "qmlhandler.h"

int main(int argc, char *argv[])
{
/*
    QApplication a(argc, argv);
    MainMokou w;
    w.show();
*/
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/MokoQml.qml")));

    QObject *root = engine.rootObjects()[0];

    QmlHandler *qh = new QmlHandler(root);

    return app.exec();
}
