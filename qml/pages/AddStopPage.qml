import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

Dialog {
    property string stopNo
    property string routeNo
    Column {
        spacing: 10
        anchors.fill: parent
        DialogHeader {
            acceptText: qsTr("Add")
        }

        TextField {
            id: stopNoField
            width: 480
            placeholderText: qsTr("Stop number")
            label: qsTr("Stop number")
            inputMethodHints: Qt.ImhDigitsOnly
            validator: IntValidator { bottom: 0; top: 9999 }
        }
        TextField {
            id: routeNoField
            width: 480
            placeholderText: qsTr("Route number - optional")
            label: qsTr("Route number")
            inputMethodHints: Qt.ImhDigitsOnly
            validator: IntValidator { bottom: 0; top: 200 }
        }
    }
    onDone: {
        if (result == DialogResult.Accepted) {
            stopNo = stopNoField.text
            routeNo = routeNoField.text || '0'
        }
    }
}
