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
import '../sugar.js' as NA
import 'upcoming.js' as Upcoming

Page {
    id: page
    property int stopNo
    property int routeNo
    property bool active: (status == PageStatus.Active || status == PageStatus.Activating) && app.active
    ListModel {
        id: listModel
    }
    SilicaListView {
        id: listView
        model: listModel
        anchors.fill: parent
        spacing: Theme.paddingLarge
        header: PageHeader {
            title: qsTr("Stop: ") + stopNo + (routeNo ? ("\n" + qsTr("Route: ") + routeNo) : "" )
        }
        delegate: BackgroundItem {
            id: delegate
            contentHeight: Theme.itemSizeLarge
            Label {
                id: timeLabel
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeLarge
                text: name
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor

                anchors.verticalCenter: parent.verticalCenter
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





