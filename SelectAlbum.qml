import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1

Window {
    id: selectWindow
    property int itemSize: 100

    visible: true
    width: 1024
    height: 768
    color: "#ffffff"
    title: qsTr("Select Album")

    property var home

    signal newCurrentIndex(int index)
    signal wantOpenAlbum(int index)
    signal needClearPlaylist()
    signal needTrackList(int index)
    signal tlDoubleClicked(int index)
    signal needPause()
    signal circleSelected(int index)

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
    function calcActualAlbumIndex() {
        var index = albumInfo.currentIndex
        var count = albumInfo.model.count
        index += 5
        if (index >= count) {
            index -= count;
        }
        if (index == 0) {
            index = count
        }
        return index;
    }
    function changeButtonMark() {
        if (pausePlayMark.text == "||") {
            pausePlayMark.text = ">"
    } else {
        pausePlayMark.text = "||"
    }
    }

    Rectangle {
        width: parent.width
        height: 400
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
                    onClicked: console.log(albumPath.currentIndex)
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
        id: trackModel
    }

/*********************TIMER**********************/
    Timer {
        id: albumInfoTimer
        interval: 1500
        onTriggered: {
            trackModel.clear()
            needTrackList( calcActualAlbumIndex() )
        }
    }

/********************ALBUMS_LIST******************/
    Rectangle {
        x: parent.width / 3.2
        y: 300
        width: 400
        height: 400
        color: "orchid"
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

            path: Path {
                startX: albumInfo.width / 2
                startY: 0
                PathAttribute { name: "opacity"; value: 0.2 }
                PathLine {
                    x: albumInfo.width / 2
                    y: albumInfo.height / 2
                }
                PathAttribute { name: "opacity"; value: 1 }
                PathLine {
                    x: albumInfo.width / 2
                    y: albumInfo.height
                }
                PathAttribute { name: "opacity"; value: 0.2 }
            }
            delegate: Rectangle {
                id: infoDelegate
                width: 300
                height: 50
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
                    onClicked: console.log(albumPath.currentIndex)
                    onWheel: {
                        if( wheel.angleDelta.y > 0 ) albumInfo.decrementCurrentIndex();
                        else albumInfo.incrementCurrentIndex();
                    }
                }
            } //delegate
        }//PathView
    }

/*******************CIRCLES_LIST****************/
    Rectangle { // CIRCLES
        x: parent.width / 40
        y: 400
        width: 300
        height: 300
        color: "orchid"
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
                //newCurrentIndex(currentIndex)
                //albumPath.currentIndex = currentIndex
            }

            pathItemCount: 6
            model: circleModel

            path: Path {
                startX: circleView.width / 2
                startY: 0
                PathAttribute { name: "opacity"; value: 0.2 }
                PathLine {
                    x: circleView.width / 2
                    y: circleView.height / 2
                }
                PathAttribute { name: "opacity"; value: 1 }
                PathLine {
                    x: circleView.width / 2
                    y: circleView.height
                }
                PathAttribute { name: "opacity"; value: 0.2 }
            }
            delegate: Rectangle {
                id: circleDelegate
                width: 200
                height: 50
                opacity: PathView.opacity
                ColumnLayout {
                    Text {
                        text: circle
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    //onClicked: console.log(albumPath.currentIndex)
                    onWheel: {
                        if( wheel.angleDelta.y > 0 ) circleView.decrementCurrentIndex();
                        else circleView.incrementCurrentIndex();
                    }
                }
            } //delegate
        }//PathView
    } // CIRCLES

/************************TRACK_LIST*******************/
    Rectangle {
        x: parent.width / 1.43
        y: 400
        width: 300
        height: 300
        Component {
            id: songDelegate
            Item {
                width: parent.width
                height: 40
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
        y: 726
        width: 100
        height: 22
        onClicked: wantOpenAlbum( calcActualAlbumIndex() )
        Text {
            anchors.centerIn: parent
            text: qsTr("Add to playlist")
            font.pixelSize: 12
        }
    }

/********************BUTTON_NEW_PL**************/
    NiceButton {
        x: 915
        y: 726
        width: 100
        height: 22
        onClicked: {
            needClearPlaylist()
            wantOpenAlbum( calcActualAlbumIndex() )
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
