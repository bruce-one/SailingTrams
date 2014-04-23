/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import 'database.js' as Database
Page {
    id: page

    ListModel {
        id: listModel
        ListElement {
            name: "Unknown"
        }
    }

    SilicaListView {
        id: listView
        model: listModel
        //anchors.topMargin: 100
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
                        if(app.db) {
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
            property int stopNo: stopNo
            property int routeNo: routeNo
            menu: contextMenu
            Label {
                x: Theme.paddingLarge
                text: name
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: {
                var index = model.index
                    , ourModel = listModel.get(model.index)
                pageStack.push(Qt.resolvedUrl("StopPage.qml"), {stopNo: ourModel.stopNo, routeNo: ourModel.routeNo})
            }
            function remove() {
                remorseAction("Deleting", function() {
                    var index = model.index
                        , ourModel = listModel.get(model.index)
                    if(app.db) {
                        app.db.transaction(function(tx) {
                            var result = tx.executeSql('DELETE FROM UserStops WHERE stopNo = ? and routeNo = ?;', [ourModel.stopNo, ourModel.routeNo])
                            console.log('Deleted ' + result.rowsAffected + ' rows')
                        })
                        Database.update()
                    }
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
        VerticalScrollDecorator {}
    }


    Component.onCompleted: Database.update()

}


