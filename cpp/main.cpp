#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    app.setOrganizationName  ("MrMG");
    app.setOrganizationDomain("MrMG");

    app.setApplicationName("DoDiet");
    app.setDesktopFileName("Do Diet");
    app.setApplicationDisplayName("Do Diet");

    app.setApplicationVersion(VERSION); // VERSION environment From .pro

    QQmlApplicationEngine engine;

    //**************** App Style ****************//

    QQuickStyle::setStyle("Material");

    //*******************************************//

    engine.addImportPath("qrc:/");
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
