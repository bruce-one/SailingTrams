import QtQuick 2.0
import Sailfish.Silica 1.0
import 'database.js' as Database
Page {
    id: page

    ListModel {
        id: listModel
    }

    SilicaListView {
        id: listView
        model: listModel
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Stops")
        }
        PullDownMenu {
            MenuItem {
                text: qsTr("Add stop")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("AddStopPage.qml"))
                    dialog.accepted.connect(function() {
                        if(typeof(app.db) !== 'undefined') {
                            app.db.transaction(function(tx) {
                                tx.executeSql('INSERT INTO UserStops(stopNo, routeNo) VALUES(?, ?);', [dialog.stopNo, dialog.routeNo])
                            })
                        }
                        Database.update()
                    })
                    dialog.rejected.connect(Database.update)
                }
            }
        }
        delegate: ListItem {
            id: delegate
            menu: contextMenu
            contentHeight: Theme.itemSizeLarge
            Label {
                id: nameLabel
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeLarge
                text: qsTr("Stop ") + name
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                anchors.verticalCenter: parent.verticalCenter
            }
            Label {
                id: routeLabel
                text: routeNo != 0 ? routeNo : 'All'
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                anchors {
                    left: nameLabel.left
                    bottom: parent.bottom
                }
            }
            onClicked: {
                pageStack.push(Qt.resolvedUrl("StopPage.qml"), {stopNo: stopNo, routeNo: routeNo})
            }
            function remove() {
                remorseAction("Deleting", function() {
                    if(typeof(app.db) !== 'undefined') {
                        app.db.transaction(function(tx) {
                            var result = tx.executeSql('DELETE FROM UserStops WHERE stopNo = ? and routeNo = ?;', [stopNo, routeNo])
                            console.log('Deleted ' + result.rowsAffected + ' rows')
                        })
                    }
                    animateRemoval()

                }, 3000)
            }

            Component {
                id: contextMenu
                ContextMenu {
                    MenuItem {
                        text: "Remove"
                        onClicked: remove()
                    }
                }
            }
        }
        ViewPlaceholder {
            enabled: listView.count == 0
            text: "No stops registered, use the pulley to add"
        }
        VerticalScrollDecorator {}
    }


    Component.onCompleted: Database.update()

}


