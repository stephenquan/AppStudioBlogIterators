//==============================================================================
//
// COPYRIGHT 2013 ESRI
//
// TRADE SECRETS: ESRI PROPRIETARY AND CONFIDENTIAL
// Unpublished material - all rights reserved under the
// Copyright Laws of the United States and applicable international
// laws, treaties, and conventions.
//
// For additional information, contact:
// Environmental Systems Research Institute, Inc.
// Attn: Contracts and Legal Services Department
// 380 New York Street
// Redlands, California, 92373
// USA
//
// email: contracts@esri.com
//
//------------------------------------------------------------------------------

#ifndef AppFrameworkPlugin_H
#define AppFrameworkPlugin_H

#include <QQmlExtensionPlugin>

//------------------------------------------------------------------------------

class QJSValue;
class QJSEngine;
class AppFramework;

//------------------------------------------------------------------------------

class AppFrameworkPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    void initializeEngine(QQmlEngine *engine, const char *uri);
    void registerTypes(const char *uri);

private:
    void initializeNetwork();

    static QObject* appFrameworkProvider(QQmlEngine *engine, QJSEngine *scriptEngine);

private:
    static AppFramework*            m_AppFramework;
};

//------------------------------------------------------------------------------

#endif // AppFrameworkPlugin_H

