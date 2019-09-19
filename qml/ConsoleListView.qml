import QtQuick 2.12
import QtQuick.Controls 2.5

ListView {
    id: consoleListView

    clip: true
    model: ListModel { id: listModel }

    delegate: Rectangle {
        id: consoleLine
        width: consoleListView.width
        height: Math.max(messageText.height, timeText.height) + 10
        color: "#e0e0e0"

        Text {
            id: messageText
            x: 2
            y: 2
            width: seperator.x - x - 4
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: txt
        }

        Rectangle {
            id: seperator
            x: timeText.x - 4
            y: 0
            width: 1
            height: parent.height
            color: "black"
        }

        Text {
            id: timeText
            x: parent.width - timeMetrics.boundingRect.width - 4 - 20
            y: 2
            text: time

            TextMetrics {
                id: timeMetrics
                text: "88:88:88.8888"
            }
        }

    }

    function clear() {
        listModel.clear()
    }

    function log(...params) {
        console.log(...params)
        var txt = params.join(" ")
        var time = ( new Date() ).toTimeString()
        listModel.append( { txt, time } )
        consoleListView.positionViewAtEnd()
    }

    function object() {
        return {
            assert: console.assert,
            clear: clear,
            count: console.count,
            error: console.error,
            group: console.group,
            groupCollapsed: console.groupCollapsed,
            groupEnd: console.groupEnd,
            info: log,
            log: log,
            table: console.table,
            time: console.time,
            timeEnd: console.timeEnd,
            trace: console.trace,
            warn: log
        }
    }
}
