import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    property alias lineNumberFont: textMetrics.font
    property color lineNumberBackground: "#e0e0e0"
    property color lineNumberColor: "black"
    property alias font: textEdit.font
    property alias text: textEdit.text
    property color textBackground: "white"
    property color textColor: "black"
    property alias textDocument: textEdit.textDocument

    TextMetrics {
        id: textMetrics
        text: "99999"
        font: textEdit.font
    }

    Rectangle {
        anchors.fill: parent

        color: textBackground

        ListView {
            id: lineNumbers
            model: textEdit.text.split(/\n/g)
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 10
            width: textMetrics.boundingRect.width
            clip: true

            delegate: Rectangle {
                width: lineNumbers.width
                height: lineText.height
                color: lineNumberBackground

                Text {
                    id: lineNumber
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: index + 1
                    color: lineNumberColor
                    font: textMetrics.font
                }

                Text {
                    id: lineText
                    width: flickable.width
                    text: modelData
                    font: textEdit.font
                    visible: false
                    wrapMode: Text.WordWrap
                }
            }

            onContentYChanged: {
                if (!moving) return;
                flickable.contentY = contentY;
            }
        }

        Item {
            anchors.left: lineNumbers.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 10

            Flickable {
                id: flickable
                anchors.fill: parent
                clip: true
                contentWidth: textEdit.width
                contentHeight: textEdit.height

                TextEdit {
                    id: textEdit
                    width: flickable.width
                    color: textColor
                    wrapMode: Text.WordWrap
                }

                onContentYChanged: {
                    if (lineNumbers.moving) return;
                    lineNumbers.contentY = contentY;
                }
            }
        }
    }
}
