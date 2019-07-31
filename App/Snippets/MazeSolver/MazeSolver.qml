import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Labs 1.0

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Rectangle {
            id: textEditFrame

            //Layout.fillWidth: true
            Layout.preferredWidth: height
            Layout.fillHeight: true

            TextEdit {
                id: textEdit
                anchors.fill: parent
                anchors.margins: 10
                font.family: "Courier New"
                font.pointSize: 14
            }
        }

        Button {
            text: qsTr("Solve Maze")
            onClicked: solveMaze()
        }
    }

    function solveMaze() {
        const mazeWidth = 9
        const mazeHeight = 9
        let maze = [
                "# #######",
                "#   #   #",
                "# ### # #",
                "# #   # #",
                "# # # ###",
                "#   # # #",
                "# ### # #",
                "#   #   #",
                "####### #"
            ].map(line => line.split(""))
        const wall = "#"
        const free = " "
        const someDude = "*"
        const startingPoint = [1, 0]
        const endingPoint = [7, 8]

        function printDaMaze() {
            textEdit.text = maze.reduce((p, c) => (p += c.join("") + "\n"), "")
        }

        _asyncToGenerator( function*() {
            function solve(x, y) {
                return _asyncToGenerator(function*() {
                    maze[y][x] = someDude
                    printDaMaze()
                    yield timer.sleep(100)
                    if (x === endingPoint[0]
                            && y === endingPoint[1]) return true
                    if (x > 0 && maze[y][x - 1] === free
                            && (yield solve(x - 1, y))) return true
                    if (x < mazeWidth && maze[y][x + 1] === free
                            && (yield solve(x + 1, y))) return true
                    if (y > 0 && maze[y - 1][x] === free
                            && (yield solve(x, y - 1))) return true
                    if (y < mazeHeight && maze[y + 1][x] === free
                            && (yield solve(x, y + 1))) return true
                    maze[y][x] = free
                    printDaMaze()
                    yield timer.sleep(100)
                    return false
                } )()
            }

            if (yield solve(startingPoint[0], startingPoint[1])) {
                console.log( "Solved!" )
                printDaMaze()
            } else {
                console.log( "Cannot solve. :-(" )
            }

            yield timer.sleep(2000)
        } )()
    }

    Timer {
        id: timer
        property var func
        property var params
        repeat: false
        running: false
        onTriggered: func( ...params )
        function setTimeout( func, interval, ...params ) {
            stop()
            timer.func = func
            timer.interval = interval
            timer.params = params
            start()
        }
        function sleep( ms ) {
            return new Promise( resolve => timer.setTimeout( resolve, ms ) )
        }
    }

    SyntaxHighlighter {
        textDocument: textEdit.textDocument
        onHighlightBlock: {
            let rx = /\*/g
            for ( let m ; ( m = rx.exec( text ) ) ; ) {
                setFormat( m.index, m[0].length, someDudeFormat )
            }
        }
    }

    TextCharFormat {
        id: someDudeFormat
        foreground: "red"
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

    function _asyncToGenerator(fn) {
        return function() {
            var self = this,
            args = arguments
            return new Promise(function(resolve, reject) {
                var gen = fn.apply(self, args);
                function _next(value) {
                    asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value)
                }
                function _throw(err) {
                    asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err)
                }
                _next(undefined)
            } )
        }
    }
}
