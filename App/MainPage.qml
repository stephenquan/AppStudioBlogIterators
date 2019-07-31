import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import ArcGIS.AppFramework 1.0

Page {
    id: main

    header: RectangularGlow {
        width: parent.width
        height: headerFrame.height + 2

        glowRadius: 2
        spread: 0.2
        color: "grey"

        Rectangle {
            id: headerFrame
            width: parent.width
            height: rowLayout.height + 20
            color: "white"

            RowLayout {
                id: rowLayout

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10
                y: 10

                Image {
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    source: "images/AppStudio.png"
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: qsTr( "AppStudio Iterator and Generator snippets" )
                    font.pointSize: 16
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    verticalAlignment: Qt.AlignVCenter
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "white"

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: [
                    "ForOfIter",
                    "WhileIter",
                    "HeadAndTails",
                    "Bidirectional",
                    "PromiseBabel",
                    "ArcGISOnlineSearch",
                    "MazeSolver",
                    "TenPrintHello",
                ]

                ScrollBar.vertical: ScrollBar {
                    active: true
                    width: 20
                }

                delegate: ColumnLayout {
                    width: listView.width

                    Item { Layout.preferredHeight: 20 }

                    Text {
                        text: "%1.qml".arg(modelData)
                        font.pointSize: 14
                        color: "#0080e0"
                    }

                    Item { Layout.preferredHeight: 20 }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: codeTextEdit.height + 20
                        color: "#3a4055"

                        TextEdit {
                            id: codeTextEdit

                            property FileInfo snippet: FileInfo { url: "Snippets/%1/snippet.txt".arg(modelData) }
                            property SnippetSyntaxHighlighter highlighter: SnippetSyntaxHighlighter { textDocument: codeTextEdit.textDocument }

                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            y: 10

                            text: snippet.folder.readTextFile(snippet.fileName)
                            font.family: "Courier New"
                            font.pointSize: 10
                            font.bold: true
                            color: "white"
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                            Button {
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.margins: 10

                                property string codeTitle: "%1.qml".arg(modelData)
                                property url codeUrl: "Snippets/%1/%1.qml".arg(modelData)

                                text: qsTr("Try It!")

                                onClicked: stackView.push( codePageComponent, { codeTitle, codeUrl } )
                            }
                        }
                    }

                    Item { Layout.preferredHeight: 20 }

                    Text {
                        property FileInfo desc: FileInfo { url: "Snippets/%1/desc.txt".arg(modelData) }

                        Layout.fillWidth: true

                        text: desc.folder.readTextFile(desc.fileName)
                        font.pointSize: 12
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }

                    Item { Layout.preferredHeight: 20 }
                }
            }
        }
    }

    Component {
        id: codePageComponent

        CodePage {

        }
    }

}
