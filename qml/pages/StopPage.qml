import QtQuick 2.0
import Sailfish.Silica 1.0
import '../sugar.js' as NA
import 'upcoming.js' as Upcoming

Page {
    id: page
    property int stopNo
    property int routeNo
    property string nickname
    property real listOpacity: 1
    property bool active: (status === PageStatus.Active || status === PageStatus.Activating) && app.active
    ListModel {
        id: listModel
    }
    SilicaListView {
        id: listView
        model: listModel
        anchors.fill: parent
        spacing: Theme.paddingLarge
        header: PageHeader {
            title: (nickname ? nickname : qsTr("Stop: ") + stopNo) + (routeNo ? ("\n" + qsTr("Route: ") + routeNo) : "" )
        }
        delegate: BackgroundItem {
            id: delegate
            contentHeight: Theme.itemSizeLarge
            TouchBlocker {
                anchors.fill: parent
            }

            Label {
                id: timeLabel
                opacity: listOpacity
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeLarge
                text: name
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor

                anchors.verticalCenter: parent.verticalCenter
                Behavior on opacity {
                    FadeAnimation {}
                }
            }
            Label {
                id: routeLabel
                text: routeNo
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                anchors {
                    left: timeLabel.left
                    bottom: parent.bottom
                }
            }
        }
        PullDownMenu {
            MenuItem {
                text: qsTr("Update")
                onClicked: Upcoming.update(page.stopNo, page.routeNo)
            }
        }

        Connections {
            target: Qt.application
            onActiveChanged: Qt.application.active && Upcoming.update(page.stopNo, page.routeNo, true)
        }

        Timer {
            interval: 30000; running: true; repeat: true; triggeredOnStart: true
            onTriggered: {
                if(page.active) {
                    console.log('Updating')
                    Upcoming.update(page.stopNo, page.routeNo, true)
                } else {
                    console.log('Page not active, not updating')
                }
            }
        }
        Timer {
            interval: 15000; running: true; repeat: false
            onTriggered: {
                listModel.count == 0 && (viewPlaceholder.text = "Update failed :-(\nWill retry soon...")
                typeof(app.xhr) !== 'undefined' && app.xhr.abort()
            }
        }
        ViewPlaceholder {
            id: viewPlaceholder
            enabled: listView.count == 0
            text: "Updating..."
        }
        VerticalScrollDecorator {}
    }
}





