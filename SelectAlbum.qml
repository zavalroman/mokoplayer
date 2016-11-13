import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1

Window {
    id: selectWindow
    property int itemSize: 100

    visible: true
    width: 1024
    height: 700
    color: "#ffffff"
    title: qsTr("Select Album")

    property var home
    property var sizeFactor
    property var opacityFactor

    signal newCurrentIndex(int index)
    signal wantOpenAlbum(int index)
    signal needClearPlaylist()
    signal needTrackList(int index)
    signal tlDoubleClicked(int index)
    signal needPause()
    signal circleSelected(int index)

    onActiveChanged: {
        trackModel.clear()
        needTrackList( currentAlbumId() )
    }

    function setHome(path) {
        home = path;
    }
    function clAppend(newCircle) {
        circleModel.append(newCircle)
    }
    function alAppend(newAlbum) {
        albumModel.append(newAlbum)
    }
    function tlAppend(newTrack) {
        trackModel.append(newTrack)
    }
    function currentAlbumId() {
        return albumPath.model.get(albumPath.currentIndex)["coverPath"]
    }
    function changeButtonMark() {
        if (pausePlayMark.text == "||") {
            pausePlayMark.text = ">"
        } else {
            pausePlayMark.text = "||"
        }
    }

    Rectangle {
        id: pathRectangle
        width: parent.width
        height: 400
        anchors.horizontalCenter: parent.horizontalCenter
        PathView {
            id: albumPath
            anchors.fill: parent
/*
            onMovementEnded:  {
                albumInfo.currentIndex = currentIndex + 2
            }
*/
            onCurrentIndexChanged: {
                albumInfo.currentIndex = currentIndex
            }

            pathItemCount: 8
            model: albumModel
            //hightlightRangeMode: PathView.StrictlyEnforceRange
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            path: Path {
                startX: 0
                startY: albumPath.height

                PathAttribute { name: "size"; value: itemSize }
                PathAttribute { name: "opacity"; value: 0.5 }
                PathCurve {
                    x: albumPath.width / 5
                    y: albumPath.height / 2
                }
                PathCurve {
                    x: albumPath.width / 5 * 2
                    y: albumPath.height / 4
                }
                PathPercent { value: 0.49 }
                PathAttribute { name: "size"; value: itemSize * 2.7 }
                PathAttribute { name: "opacity"; value: 1 }
                PathLine {
                    x: albumPath.width / 5 * 3
                    y: albumPath.height / 4
                }
                PathAttribute { name: "size"; value: itemSize * 2.7 }
                PathAttribute { name: "opacity"; value: 1 }
                PathPercent { value: 0.51 }
                PathCurve {
                    x: albumPath.width / 5 * 4
                    y: albumPath.height / 2
                }
                PathCurve {
                    x: albumPath.width
                    y: albumPath.height
                }
                PathPercent { value: 1 }
                PathAttribute { name: "size"; value: itemSize }
                PathAttribute { name: "opacity"; value: 0.5 }
            }
            delegate: Rectangle {
                id: albumDelegate
                width: PathView.size
                height: PathView.size
                //color: "orchid"
                opacity: PathView.opacity
/*
                border {
                    color: "black"
                    width: 1
                }
*/
                Image {
                    id: listCover
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: home + "album-covers/" + coverPath
                }
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        if (mouse.button === Qt.LeftButton) {
                            albumPath.currentIndex = index
                        }
                        if (mouse.button === Qt.RightButton) {
                            albumPath.currentIndex = 0
                        }
                    }
                    onWheel: {
                        if( wheel.angleDelta.y > 0 ) albumPath.decrementCurrentIndex();
                        else albumPath.incrementCurrentIndex();
                    }
                }
            } //delegate
        }//PathView
    }

/********************LIST_MODELS*******************/
    ListModel {
        id: circleModel
    }
    ListModel {
        id: albumModel
    }
    ListModel {
        id: filteredAlbumModel
    }
    ListModel {
        id: trackModel
    }

/*********************TIMER**********************/
    Timer {
        id: albumInfoTimer
        interval: 1000
        onTriggered: {
            trackModel.clear()
            needTrackList( currentAlbumId() )
        }
    }

/********************ALBUMS_LIST******************/
    Rectangle {
        id: albumRectangle
        //x: parent.width / 3.2
        //y: 300
        anchors.top: parent.top
        anchors.topMargin: 328
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 28
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 3
        anchors.right: parent.right
        anchors.rightMargin: parent.width / 3
        //width: 400
        //height: 400
        color: "transparent"
        PathView {
            id: albumInfo
            anchors.fill: parent
            //currentIndex: 2

            onCurrentIndexChanged: {
                albumInfoTimer.restart()
                albumPath.currentIndex = currentIndex
            }

            pathItemCount: 8
            model: albumModel

            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5

            path: Path {
                startX: albumInfo.width / 2
                startY: 0
                PathAttribute { name: "opacity"; value: 0.5 }
                PathLine {
                    x: albumInfo.width / 2
                    y: albumInfo.height / 2
                }
                PathAttribute { name: "opacity"; value: 1 }
                PathLine {
                    x: albumInfo.width / 2
                    y: albumInfo.height
                }
                PathAttribute { name: "opacity"; value: 0.5 }
            }
            delegate: Rectangle {
                id: infoDelegate
                width: 300
                height: 43
                opacity: PathView.opacity
                ColumnLayout {
                    Text {
                        //Layout.alignment: Qt.AlignRight
                        text: album
                    }
                    Text {
                        //Layout.alignment: Qt.AlignRight
                        text: circle
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        if (mouse.button === Qt.LeftButton) {
                            albumInfo.currentIndex = index
                        }
                        if (mouse.button === Qt.RightButton) {
                            albumInfo.currentIndex = 0
                        }
                    }
                    onWheel: {
                        if( wheel.angleDelta.y > 0 ) albumInfo.decrementCurrentIndex();
                        else albumInfo.incrementCurrentIndex();
                    }
                }
            } //delegate
        }//PathView
        Rectangle {
            //x: 10
            //y: 10
            //width: 200
            //height: 200
            anchors.top: parent.top
            anchors.topMargin: 145
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 152
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            color: "transparent"
            radius: 5
            border {
                color: "black"
                width: 2
            }

        }
    }

/*********************TIMER**********************/
    Timer {
        id: circeFilterTimer
        interval: 1000
        onTriggered: {

            filteredAlbumModel.clear()
            var cId = circleView.currentIndex
            var filter = new String ( circleModel.get(cId)["circle"] )
            if (filter.localeCompare("All")===0) {
                albumInfo.model = albumModel
                albumPath.model = albumModel
                return
            }
            for (var i=0; i<albumModel.count; i++) {
                var str = new String ( albumModel.get(i)["circle"] )
                if (str.localeCompare(filter)===0) {
                    filteredAlbumModel.append(albumModel.get(i))
                }
            }

           /*
           var fC = filteredAlbumModel.count
           if (fC < 8) {
               albumPath.pathItemCount = fC
               albumInfo.pathItemCount = fC
               pathRectangle.width = 512//1024 - (8 - fC)*10
               pathRectangle.height = 200//400 - (8 - fC)*5

           } else {
               albumPath.pathItemCount = 8
               albumInfo.pathItemCount = 8

           }
            */
            albumInfo.model = filteredAlbumModel
            albumPath.model = filteredAlbumModel

           //trackModel.clear()
           //needTrackList( currentAlbumId() )


        }
    }

/*******************CIRCLES_LIST****************/
    Rectangle { // CIRCLES
        x: albumRectangle.x - 270
        y: 388
        //anchors.top: parent.top
        //anchors.topMargin: 400
        //anchors.bottom: parent.bottom
        //anchors.bottomMargin: 28
        //anchors.left: parent.left
        //anchors.leftMargin: 150
        //anchors.right: albumInfo.left
        //anchors.rightMargin: 10//(parent.width * 2) / 3
        width: 300
        height: 240
        color: "transparent"

        PathView {
            id: circleView
            anchors.fill: parent
            //currentIndex: 2
      /*
            onMovementEnded: {
                albumPath.currentIndex = currentIndex
            }
    */
            onCurrentIndexChanged: {
                circeFilterTimer.restart()
            }

            pathItemCount: 8
            model: circleModel

            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5

            path: Path {
                startX: circleView.width / 2
                startY: 0
                PathAttribute { name: "opacity"; value: 0.5 }
                PathLine {
                    x: circleView.width / 2
                    y: circleView.height / 2
                }
                PathAttribute { name: "opacity"; value: 1 }
                PathLine {
                    x: circleView.width / 2
                    y: circleView.height
                }
                PathAttribute { name: "opacity"; value: 0.5 }
            }
            delegate: Rectangle {
                id: circleDelegate
                width: 200
                height: 30
                opacity: PathView.opacity
                color: "transparent"
                ColumnLayout {
                    Text {
                        text: circle
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        if (mouse.button === Qt.LeftButton) {
                            circleView.currentIndex = index
                        }
                        if (mouse.button === Qt.RightButton) {
                            circleView.currentIndex = 0
                        }
                    }
                    onWheel: {
                        if( wheel.angleDelta.y > 0 ) circleView.decrementCurrentIndex();
                        else circleView.incrementCurrentIndex();
                    }
                }
            } //delegate
        }//PathView
        Rectangle {
            //x: 10
            //y: 10
            //width: 200
            //height: 200
            anchors.top: parent.top
            anchors.topMargin: 95
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 113
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.right: parent.right
            anchors.rightMargin: 40
            color: "transparent"
            radius: 5
            border {
                color: "black"
                width: 2
            }

        }
    } // CIRCLES

/************************TRACK_LIST*******************/
    Rectangle {
        //x: parent.width / 1.43
        //y: 400
        //width: 300
        //height: 300
        anchors.top: parent.top
        anchors.topMargin: 400
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 28
        anchors.left: albumRectangle.right
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 20
        color: "transparent"
        Component {
            id: songDelegate
            Rectangle {
                width: parent.width
                height: 40
                color: "transparent"
                Column {
                    width: parent.width
                    RowLayout {
                        width: parent.width-10
                        Text { text: "    " + artist }
                        Text { text: status }
                        Text {
                            Layout.alignment: Qt.AlignRight
                            text: duration
                        }
                    }
                    Text { text:  "    " + song }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: tlView.currentIndex = index
                    onDoubleClicked: {
                        tlDoubleClicked(index)
                        pausePlayMark.text = "||"
                    }
                }
            }
        }
        ListView {
            id: tlView
            anchors.fill: parent
            model: trackModel
            delegate: songDelegate
            //highlight: Rectangle { color: "#eA6060"; radius: 5; opacity: 0.4 }//#f2ebeb #eaeaea
            //highlightMoveVelocity: 1500.0
            focus: true
        }
/*        ScrollBar {
            flickable: tlView
        }*/
    }

/********************BUTTON_ADD_TO_PL**************/
    NiceButton {
        x: 800
        y: 626
        width: 100
        height: 22
        onClicked: wantOpenAlbum( currentAlbumId() )
        Text {
            anchors.centerIn: parent
            text: qsTr("Add to playlist")
            font.pixelSize: 12
        }
    }

/********************BUTTON_NEW_PL**************/
    NiceButton {
        x: 915
        y: 626
        width: 100
        height: 22
        onClicked: {
            needClearPlaylist()
            wantOpenAlbum( currentAlbumId() )
        }
        Text {
            anchors.centerIn: parent
            text: qsTr("New playlist")
            font.pixelSize: 12
        }
    }
/********************BUTTON_PAUSE**************/
    NiceButton {
        x: 950
        y: 20
        width: 35
        height: 35
        onClicked: {
            needPause()
            changeButtonMark()
        }
        Text {
            id: pausePlayMark
            anchors.centerIn: parent
            text: qsTr("||")
            font.pixelSize: 12
        }
    }

}
