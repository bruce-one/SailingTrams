import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "pages"

ApplicationWindow
{
    id: app
    property string coverStop: qsTr('SailingTrams')
    property string coverTime: ""
    property int stopNo: 0
    property int routeNo: 0
    property bool active: Qt.application.active
    property var db
    property bool _paused: false
    property bool paused: _paused || (stopNo == 0)
    property var xhr
    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
}


