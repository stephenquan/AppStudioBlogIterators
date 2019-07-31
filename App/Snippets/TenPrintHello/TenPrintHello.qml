import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import ArcGIS.AppFramework 1.0

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Button {
            text: qsTr("Simulate BASIC")
            onClicked: simulateBASIC()
        }

        Rectangle {
            id: frame

            //Layout.preferredWidth: textMetrics.boundingRect.width + 20
            Layout.fillWidth: true
            Layout.preferredHeight: textMetrics.boundingRect.height * 20 + 20

            color: "black"

            Flickable {
                id: flickable
                anchors.fill: parent
                anchors.margins: 10

                contentWidth: textEdit.width
                contentHeight: textEdit.height
                clip: true

                TextEdit {
                    id: textEdit

                    color: "#00FF00"
                    font.family: "Courier New"
                    font.pointSize: 12
                    font.bold: true

                    function clear() {
                        text = ""
                    }

                    function reset() {
                        clear()
                        out("Simple Basic\nREADY\n>")
                    }

                    function out(str) {
                        text = text + str
                        cursorPosition = text.length
                        if (textEdit.cursorRectangle.y + textEdit.cursorRectangle.height > flickable.contentY + flickable.height) {
                            flickable.contentY = textEdit.cursorRectangle.y - flickable.height + textEdit.cursorRectangle.height;
                        }
                    }

                    Component.onCompleted: reset()
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }

    TextMetrics {
        id: textMetrics

        font: textEdit.font
        text: "0123456789012345678901234567890123456789012345678901234567890123456789"
    }

    Timer {
        id: timer
        property var func
        property var params
        repeat: false
        running: false
        onTriggered: func( ...params )
        function setTimeout( func, interval, ...params ) {
            timer.func = func
            timer.params = params
            timer.interval = interval
            start()
        }
    }

    function sleep( ms ) {
        return new Promise( (resolve) => timer.setTimeout( resolve, ms ) )
    }

    function simulateBASIC() {
        _asyncToGenerator(function*() {
            function* simulateTyping(str, delay) {
                for (let ch of str) {
                    textEdit.out(ch)
                    yield sleep(delay)
                }
            }

            try {
                textEdit.forceActiveFocus()
                textEdit.reset()
                yield* simulateTyping('10 PRINT "HELLO"\n', 200)
                yield sleep (200)
                yield* simulateTyping('>20 GOTO 10\n', 200)
                yield sleep (200)
                yield* simulateTyping('>RUN\n', 200)
                yield sleep (200)
                for (let i = 0; i < 25; i++)
                    yield* simulateTyping("HELLO\n", 50)
                yield* simulateTyping('CTRL-C\n', 100)
                yield* simulateTyping('>', 100)
            } catch (err) {
                console.log( "Caught Error: ", err.message )
                throw err
            }
        })()
    }

    function _asyncToGenerator(fn) {
        return function() {
            var self = this,
            args = arguments
            return new Promise(function(resolve, reject) {
                var gen = fn.apply(self, args)
                function _next(value) {
                    asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value)
                }
                function _throw(err) {
                    asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err)
                }
                _next(undefined)
            })
        }
    }

    function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) {
        try {
            var info = gen[key](arg)
            var value = info.value
        } catch (error) {
            reject(error)
            return
        }
        if (info.done) {
            resolve(value)
        } else {
            Promise.resolve(value).then(_next, _throw)
        }
    }
}

