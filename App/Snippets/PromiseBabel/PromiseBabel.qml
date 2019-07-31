import QtQuick 2.12
import QtQuick.Controls 2.5
import ArcGIS.AppFramework 1.0

Item {
    Button {
        text: qsTr( "Test Promise async/await (Babel)" )
        onClicked: testPromise()
    }

    function testPromise() {
        _asyncToGenerator( function* () {
            try {
                showUser( yield download( "GET", "https://www.arcgis.com/sharing/rest/community/users/squan888?f=pjson" ) )
                showUser( yield download( "GET", "https://www.arcgis.com/sharing/rest/community/users/appstudio_samples?f=pjson" ) )
                showUser( yield download( "GET", "https://www.arcgis.com/sharing/rest/community/users/appstudio_templates?f=pjson" ) )
            } catch (error) {
                console.log("Caught Exception: ", error.message)
                console.log("Stack: ", error.stack)
                throw error
            }
        } )()
    }

    /*
    function testPromise() {
        (async function () {
            try {
                showUser( await download( "GET", "https://www.arcgis.com/sharing/rest/community/users/squan888?f=pjson" ) )
                showUser( await download( "GET", "https://www.arcgis.com/sharing/rest/community/users/appstudio_samples?f=pjson" ) )
                showUser( await download( "GET", "https://www.arcgis.com/sharing/rest/community/users/appstudio_templates?f=pjson" ) )
            } catch (error) {
                console.log("Caught Exception: ", error.message)
                console.log("Stack: ", error.stack)
                throw error
            }
        } )()
    }
    */

    function showUser( networkRequest ) {
        let responseText = networkRequest.responseText
        console.log( responseText )
    }

    function download( method, url, ...form ) {
        networkRequestWithPromise.method = method
        networkRequestWithPromise.url = url
        return networkRequestWithPromise.sendWithPromise( ...form )
    }

    NetworkRequest {
        id: networkRequestWithPromise

        property var _resolve
        property var _reject

        uploadPrefix: "file://"

        onReadyStateChanged: {
            if (readyState !== 4) return
            if (status < 200 || status >= 299) {
                _reject( new Error( qsTr("Download failure %1: Status Code %2: %3").arg(url).arg(status).arg(statusText) ) )
                return
            }
            if (errorCode !== 0)
            {
                _reject( new Error( qsTr("Download failure %1: Error Code %2: %3").arg(url).arg(error).arg(errorText) ) )
                return
            }
            _resolve( networkRequestWithPromise )
        }

        function sendWithPromise( ...form ) {
            return new Promise( function (resolve, reject) {
                _resolve = resolve
                _reject = reject
                send( ...form )
            } )
        }
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
