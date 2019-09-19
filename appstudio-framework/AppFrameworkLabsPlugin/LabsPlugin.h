/*
 * COPYRIGHT 2019 ESRI
 *
 * TRADE SECRETS: ESRI PROPRIETARY AND CONFIDENTIAL
 * Unpublished material - all rights reserved under the
 * Copyright Laws of the United States and applicable international
 * laws, treaties, and conventions.
 *
 * For additional information, contact:
 * Environmental Systems Research Institute, Inc.
 * Attn: Contracts and Legal Services Department
 * 380 New York Street
 * Redlands, California, 92373
 * USA
 *
 * email: contracts@esri.com
 *
 */

#ifndef LabsPlugin_H
#define LabsPlugin_H

#include <QQmlEngine>
#include <QQmlExtensionPlugin>

class LabsSingleton;

//------------------------------------------------------------------------------

class LabsPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    void registerTypes(const char *uri);
    void initializeEngine(QQmlEngine *engine, const char *uri);

private:
    static QObject* singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine);

private:
    static LabsSingleton*        m_LabsSingleton;
};

//------------------------------------------------------------------------------
#endif // LabsPlugin_H
