import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import ArcGIS.AppFramework 1.0
import "qml/App"

Window {
    id: app

    visible: true
    width: 640
    height: 480
    title: qsTr("Javascript Iterators and Generators")

    property FileFolder folder: FileFolder { url: "." }

    StackView {
        id: stackView

        anchors.fill: parent

        initialItem: MainPage {
        }
    }
}
