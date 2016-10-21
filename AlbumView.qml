import QtQuick 2.0

Rectangle {
    property int itemSize: 100

    width: 1000
    height: 400

    PathView {
        id: albumPath
        anchors.fill: parent
        //model: 8//AlbumListModel { id: alModel }
        property int wheelIndex: -1
        currentIndex: 0
        pathItemCount: 8
        path: Path {
            startX: 0
            startY: height

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
            PathAttribute { name: "size"; value: itemSize * 2 }
            PathAttribute { name: "opacity"; value: 1 }
            PathLine {
                x: albumPath.width / 5 * 3
                y: albumPath.height / 4
            }
            PathAttribute { name: "size"; value: itemSize * 2 }
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
            color: "orchid"
            opacity: PathView.opacity
            border {
                color: "black"
                width: 1
            }

            Image {
                id: listCover
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }
            Rectangle {
                Column {
                    anchors.fill: parent
                    Text { text: circle }

                }
            }
        /*
        MouseArea {
            anchors.fill: parent
            preventStealing: true;
            propagateComposedEvents: true

            Timer {
                id: wheelTimer
                interval: 200
                running: false
                repeat: false
                onTriggered: {
                    albumPath.wheelIndex = -1
                }
            }
            onWheel: {
                wheelTimer.start();

                if (albumPath.wheelIndex === -1) {
                    albumPath.wheelIndex = albumPath.currentIndex
                }
                if (wheel.angleDelta.y > 0) {
                    albumPath.wheelIndex++
                    if (albumPath.wheelIndex > albumPath.model.count) {
                        albumPath.wheelIndex = 0
                    }
                    albumPath.currentIndex = albumPath.wheelIndex
                } else {
                    albumPath.wheelIndex--
                    if (albumPath.wheelIndex < 0) {
                        albumPath.wheelIndex = albumPath.model.count - 1
                    }
                    albumPath.currentIndex = albumPath.wheelIndex;
                }
            }
        }
        */
    }
/*
    Component {

        Item {
            //width: parent.width
            //height: 40
            Rectangle {
            id: albumDelegate
            width: PathView.size
            height: PathView.size
            color: "orchid"
            opacity: PathView.opacity
            border {
                color: "black"
                width: 1
            }
            Image {
                id: listCover
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }
            Rectangle {
                Column {
                    anchors.fill: parent
                    Text { text: circle }

                }
            }
        }
            /*
            MouseArea {
                anchors.fill: parent
                onClicked: plView.currentIndex = index
                onDoubleClicked: { plDoubleClicked(index) }
            }

        }
    }

*/


}
}
