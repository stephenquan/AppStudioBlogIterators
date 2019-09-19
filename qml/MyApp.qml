import QtQuick 2.12
import QtQuick.Controls 2.5
import ArcGIS.AppFramework 1.0
import "App"

App {
    id: app

    width: 800 * AppFramework.displayScaleFactor
    height: 600 * AppFramework.displayScaleFactor

    Page {
        anchors.fill: parent

        StackView {
            id: stackView

            anchors.fill: parent

            initialItem: MainPage {
            }
        }
    }
}
