import QtQuick 2.12
import ArcGIS.AppFramework 1.0

Item {
    property Item target
    property int startIndex: 1
    property int currentIndex: 1
    property bool running: false
    property alias interval: grabTimer.interval
    property string filenameTemplate: "~/Pictures/SnippingTool/Frame-%1.png"

    Timer {
        id: grabTimer
        running: false
        repeat: false
        interval: 100
        onTriggered: target.grabToImage(
                         notifyGrabToImage,
                         Qt.size(target.width, target.height))
    }

    function start() {
        running = true
        grabTimer.stop()
        currentIndex = startIndex - 1
        next()
    }

    function stop() {
        running = false
    }

    function next() {
        currentIndex++
        grabTimer.start()
    }

    function notifyGrabToImage(result) {
        if (!running) return
        var fileInfo = AppFramework.fileInfo(filenameTemplate.arg(currentIndex))
        console.log(fileInfo.filePath)
        fileInfo.folder.makeFolder()
        result.saveToFile(fileInfo.filePath)
        next()
    }
}
