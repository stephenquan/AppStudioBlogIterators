import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    Button {
        text: qsTr("For Of ... Iterator")

        onClicked: {
            function *cities() {
                yield { name: "Hawaii", distance: 4221.73 }
                yield { name: "Los Angeles", distance: 96.65 }
                yield { name: "New York City", distance: 3853.10 }
                yield { name: "Redlands", distance: 1.12 }
                yield { name: "Seattle", distance: 1566.70 }
            }

            for ( let city of cities() )
                console.log( JSON.stringify( city ) )
        }
    }
}
