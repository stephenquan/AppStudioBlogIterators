import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.0

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        RowLayout {
            Layout.fillWidth: true

            Button {
                text: qsTr("Run!")
                enabled: !helloWorldTimer.running

                onClicked: {
                    function* helloWorldGenerator() {
                        while (true)
                            yield "Hello World"
                    }

                    helloWorldTimer.iter = helloWorldGenerator()
                    helloWorldTimer.start()
                }
            }

            Button {
                text: qsTr("Abort")
                enabled: helloWorldTimer.running

                onClicked: {
                    if (!helloWorldTimer.running) return
                    helloWorldTimer.stop()
                    console.log("Aborted!")
                }
            }
        }

        Item { Layout.fillHeight: true }
    }

    Timer {
        id: helloWorldTimer
        property var iter
        running: false
        repeat: true
        interval: 100
        onTriggered: {
            let item = iter.next()
            if (item.done) {
                stop()
                return
            }
            console.log( item.value )
        }
    }
}
