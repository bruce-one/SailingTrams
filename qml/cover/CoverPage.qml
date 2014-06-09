import QtQuick 2.0
import Sailfish.Silica 1.0
import "../pages/upcoming.js" as Upcoming

CoverBackground {
    property bool active: status === Cover.Active
    Rectangle {
        height: 80
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -100
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            text: app._paused ? "" : app.coverStop
            font.bold: true
        }
        Label {
            id: coverLabel
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: app.paused ? '' : app.coverTime
            Behavior on opacity {
                FadeAnimation {}
            }

        }
    }
    CoverPlaceholder {
        text: app._paused && stopNo != 0 ? "Paused" : ""
        icon.source: app._paused && stopNo != 0 ? "image://theme/icon-cover-pause" : ""
    }

    Timer {
        interval: 30000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            if(status && app.stopNo) {
                console.log('Updating')
                Upcoming.update(app.stopNo, app.routeNo)
            } else {
                console.log('Not updating as we\'re inactive')
            }
        }
    }
    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: {
                console.log('Update requested')
                Upcoming.update(app.stopNo, app.routeNo)
            }
        }

        CoverAction {
            iconSource: app.paused ? "image://theme/icon-cover-play" : "image://theme/icon-cover-pause"
            onTriggered: {
                app._paused = app.stopNo === 0 ? false : !app._paused
            }
        }
    }
}


