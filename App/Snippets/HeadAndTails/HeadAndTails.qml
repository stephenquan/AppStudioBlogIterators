import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    Button {
        text: qsTr("LA and NYC cities")

        onClicked: {
            function *cities() {
                yield { name: "Hawaii", distance: 4221.73 }
                yield { name: "Los Angeles", distance: 96.65 }
                yield { name: "New York City", distance: 3853.10 }
                yield { name: "Redlands", distance: 1.12 }
                yield { name: "Seattle", distance: 1566.70 }
            }

            function* cat( iter ) {
                yield* iter
            }

            function* head( iter, n ) {
                if (n <= 0) return
                for (let item of iter) {
                    yield item
                    if (--n <= 0) break
                }
           }

           function* tail( iter, n ) {
               let arr = [ ]
               for ( let item of iter ) {
                   arr.push(item)
                   if (arr.length > n) arr.shift()
               }
               yield* arr
           }

           for ( let city of tail( head( cat( cities() ), 3), 2) )
               console.log( JSON.stringify( city ) )
        }
    }
}
