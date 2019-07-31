import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import ArcGIS.AppFramework 1.0

Page {
    property string codeTitle: "codeTitle"
    property alias codeUrl: code.url
    property alias codeText: codeTextEdit.text

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
                    source: "images/back-200px.png"
                    fillMode: Image.PreserveAspectFit

                    MouseArea {
                        anchors.fill: parent
                        onClicked: stackView.pop()
                    }
                }

                Image {
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    source: "images/AppStudio.png"
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: codeTitle
                    font.pointSize: 16
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent

        Item {
            id: codeAndRunner

            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.left: parent.left
                anchors.right: splitter.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                color: "white"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10

                    Flickable {
                        id: flickable

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        contentWidth: codeTextEdit.width
                        contentHeight: codeTextEdit.height
                        clip: true
                        ScrollBar.vertical: ScrollBar { width: 20 }
                        ScrollBar.horizontal: ScrollBar { height: 20 }

                        TextEdit {
                            id: codeTextEdit

                            property CodeSyntaxHighlighter highlighter: CodeSyntaxHighlighter { textDocument: codeTextEdit.textDocument }

                            //width: flickable.width

                            text: code.folder.readTextFile(code.fileName)
                            font.family: "Courier New"
                            font.pointSize: 10
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        text: runner.errorString
                        color: "red"
                        visible: text !== ''
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }
                }
            }

            Rectangle {
                id: splitter

                x: Math.max( parent.width / 2, 100 )
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 10

                color: "#e0e0e0"
                border.color: "black"
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.DragMoveCursor
                    drag {
                        target: splitter
                        axis: Drag.XAxis
                        minimumX: 10
                        maximumX: codeAndRunner.width - 20

                    }
                }
            }

            Rectangle {
                anchors.left: splitter.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                color: "white"

                ColumnLayout {
                    anchors.fill: parent

                    Item {
                        id: wrapper

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Item {
                            id: runner

                            anchors.fill: parent
                            anchors.margins: 10

                            property string code: codeText
                            property string errorString
                            property var component

                            onCodeChanged: {
                                //consoleListView.clear()

                                try {
                                    errorString = ""

                                    _console.clear()

                                    if (component) {
                                        //runner.contentWidth = 10
                                        //runner.contentHeight = 10
                                        component.destroy()
                                        component = null
                                    }

                                    let cleanCode = codeText.replace( /console.(?:log|stop|start|)/g, s => s.replace(/console/g, "_console") )
                                    //let cleanCode = codeText

                                    component = Qt.createQmlObject(cleanCode, runner)
                                    if (!component) {
                                        return
                                    }
                                    component.width = Qt.binding( () => runner.width )
                                    component.height = Qt.binding( () => runner.height )
                                } catch (err) {
                                    console.log( "Caught Error: ", err.message )
                                    errorString = err.message + "\n" + err.stack
                                }
                            }
                        }

                    }

                    Rectangle {
                        id: consoleFrame

                        Layout.fillWidth: true
                        Layout.preferredHeight: _console.height + 20
                        //Layout.preferredHeight: parent.height / 2
                        //Layout.preferredHeight: consoleFlickable.height + 20
                        //Layout.maximumHeight: parent.height - 100
                        Layout.maximumHeight: parent.height / 2

                        color: "#c0c0c0"
                        visible: _console.text !== ''

                        Flickable {
                            id: consoleFlickable

                            anchors.fill: parent
                            anchors.margins: 10

                            contentWidth: _console.width
                            contentHeight: _console.height
                            clip: true

                            ScrollBar.vertical: ScrollBar {
                                width: 20
                            }

                            TextEdit {
                                id: _console

                                width: consoleFlickable.width
                                selectByMouse: true
                                readOnly: true
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                                function clear() {
                                    text = ""
                                }

                                function log( ...params ) {
                                    console.log( ...params )
                                    text += params.join(" " ) + "\n"
                                    cursorPosition = text.length
                                    if (_console.cursorRectangle.y + _console.cursorRectangle.height > consoleFlickable.contentY + consoleFlickable.height) {
                                        consoleFlickable.contentY = _console.cursorRectangle.y - consoleFlickable.height + _console.cursorRectangle.height;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

    }

    FileInfo {
        id: code
    }
}
