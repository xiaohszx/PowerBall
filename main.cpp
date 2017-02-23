#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QObject>
#include <QQmlContext>
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQuickView *view = new QQuickView;
    view->rootContext()->setContextProperty("view", view);
    QObject::connect(view->engine(), SIGNAL(quit()), qApp, SLOT(quit()));
//    view->setFlags(Qt::FramelessWindowHint);
    view->setSource(QUrl(QLatin1String("qrc:/main.qml")));
    view->show();
//    QQmlApplicationEngine engine;
//    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
