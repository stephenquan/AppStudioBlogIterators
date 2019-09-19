#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>

#ifdef Q_OS_WASM
#include "appstudio-framework/AppFrameworkPlugin/AppFrameworkPlugin.h"
#include "appstudio-framework/AppFrameworkScriptingPlugin/ScriptingPlugin.h"
#include "appstudio-framework/AppFrameworkLabsPlugin/LabsPlugin.h"
#endif

int main(int argc, char *argv[])
{
#ifdef Q_OS_WASM
    Q_IMPORT_PLUGIN(AppFrameworkPlugin);
    Q_IMPORT_PLUGIN(ScriptingPlugin);
    Q_IMPORT_PLUGIN(LabsPlugin);
#endif

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QFontDatabase::addApplicationFont(":/fonts/cour.ttf");
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
