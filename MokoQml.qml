import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Window {
    visible: true
    width: 640
    height: 480
    color: "#ffffff"
    title: qsTr("Mokou Player")

    signal sendLoginUrl(string str)
    signal playClicked(int id)
    signal plDoubleClicked(int id)
    signal pauseClicked()
    signal stopClicked()
    signal selectOpened(QtObject obj)

    function plAppend(newElement) {
        plView.model.append(newElement)
    }
    function fillPlayerData(newData) {
        songPosBar.maximumValue = newData["posbar"]
        cover.source = "file:///home/roman/develop/mokoplayer/covers/" + newData["cover"]
        currentArtist.text = newData["artist"]
        currentTitle.text = newData["title"]
        console.log("hello")
    }
    function setSongPos(value) {
        songPosBar.setValue(value)
    }
    function setCover(file) { // actually for mokou only
        cover.source = "file:///home/roman/develop/mokoplayer/covers/" + file
    }
    function changeSongStatusToPlay(id) {
       //currentArtist.text = plView.model.get(id-1).artist
       //currentTitle.text   = plView.model.get(id-1).song
        plModel.setProperty(id, "status", ">")
    }
    function changeSongStatusToPause(id) {
        plModel.setProperty(id, "status", "||")
    }
    function changeSongStatusToBlank(id) {
        plModel.setProperty(id, "status", "")
    }
    function setAlbumsCount(count) {
        albumCount = count
    }
    function clearModel(index) {
        plModel.clear()
        //setCover("covers/" + index)
    }

/****************BUTTON_PANEL****************/
    RowLayout {
        id: menu
        width: 310
        height: 27
        NiceButton {
            id: loginButton
            Layout.preferredWidth: 70
            Layout.fillHeight: true
            onClicked: {
                var component = Qt.createComponent("VkLogin.qml")
                var window = component.createObject(this)
                window.show()
            }
            Text {
                id: loginText
                anchors.centerIn: parent
                text: qsTr("vk login")
                font.pixelSize: 12
            }
        }
        NiceButton {
            id: selectButton
            Layout.preferredWidth: 70
            Layout.fillHeight: true
            onClicked: {

                var component = Qt.createComponent("SelectAlbum.qml")
                var window = component.createObject(this)
                window.show()
                selectOpened(window)

            }
            Text {
                anchors.centerIn: parent
                text: qsTr("select")
                font.pixelSize: 12
            }
        }
    }
/**********************PLAYER_&_COVER*************************/
    ColumnLayout {
        id: playerColumn
        //x: 5
        width: 310
        //anchors.top: parent.top
        anchors.top: menu.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 10
        Rectangle {
            id: playerBox
            Layout.fillWidth: true
            //anchors.topMargin: 100
            //Layout.alignment: Qt.AlignTop
            //Layout.preferredWidth: 200
            Layout.preferredHeight: 150
            GridLayout {
                rows: 4
                columns : 5
                anchors.fill: parent
                Text {
                    id: currentArtist
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                    Layout.row: 1
                    Layout.column: 1
                    Layout.columnSpan: 5
                    //Layout.alignment: Qt.AlignBottom
                    //text: "Artist"
                }
                Text {
                    id: currentTitle
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.row: 2
                    Layout.column: 1
                    Layout.columnSpan: 5
                    //Layout.alignment: Qt.AlignTop
                    //text: "Title"
                }

                ProgressBar {
                    id: songPosBar
                    Layout.row: 3
                    Layout.column: 1
                    Layout.columnSpan: 5
                    Layout.alignment: Qt.AlignHCenter //| Qt.AlignBottom
                    style: ProgressBarStyle {
                        background: Rectangle {
                            radius : 2
                            color: "lightgray"
                            border.color: "gray"
                            border.width: 1
                            implicitHeight: 12
                            implicitWidth: 300
                        }
                        progress: Rectangle {
                            color: "#ea6363"
                            border.color: "#c11919"
                        }
                    }
                }
            /**************PLAYER_BUTTONS****************/
                NiceButton {
                    id: prevButton
                    width: 55
                    Layout.row: 4
                    Layout.column: 1
                    Layout.alignment: Qt.AlignCenter
                    //onClicked: { prevMusic() }
                    Text {
                        id: prevText
                        anchors.centerIn: parent
                        text: qsTr("<<")
                        font.pixelSize: 12
                    }
                }
                NiceButton {
                    id: playButton
                    width: 55
                    Layout.row: 4
                    Layout.column: 2
                    Layout.alignment: Qt.AlignCenter
                    onClicked: { playClicked(plView.currentIndex) }
                    Text {
                        id: playText
                        anchors.centerIn: parent
                        text: qsTr(">")
                        font.pixelSize: 12
                    }
                }
                NiceButton {
                    id: pauseButton
                    width: 55
                    Layout.row: 4
                    Layout.column: 3
                    Layout.alignment: Qt.AlignCenter
                    onClicked: { pauseClicked() }
                    Text {
                        id: pauseText
                        anchors.centerIn: parent
                        text: qsTr("||")
                        font.pixelSize: 12
                    }
                }
                NiceButton {
                    id: stopButton
                    width: 55
                    Layout.row: 4
                    Layout.column: 4
                    Layout.alignment: Qt.AlignCenter
                    onClicked: { stopClicked() }
                    Text {
                        id: stopText
                        anchors.centerIn: parent
                        text: qsTr("■")
                        font.pixelSize: 12
                    }
                }
                NiceButton {
                    id: nextButton
                    width: 55
                    Layout.row: 4
                    Layout.column: 5
                    Layout.alignment: Qt.AlignCenter
                    //onClicked: { nextMusic() }
                    Text {
                        id: nextText
                        anchors.centerIn: parent
                        text: qsTr(">>")
                        font.pixelSize: 12
                    }
                }

            }
        }
    /*****************COVER******************/
        Image {
           // Layout.alignment: Qt.AlignTop
            //color: "green"
            //Layout.preferredWidth: 40
            //Layout.preferredHeight: 70
            id: cover
            anchors.top: playerBox.bottom
            Layout.fillWidth: true
            Layout.fillHeight: true
            fillMode: Image.PreserveAspectFit
            //source: "200px-Mokou.png"

        }
    }

/*************************PLAYLIST*********************/
    Rectangle { // PLAYLIST
        //id: playListBox
        //width: 320
        anchors.left: playerColumn.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        Image {
            id: prohodi
            anchors.fill: parent
            Layout.fillWidth: true
            Layout.fillHeight: true
            fillMode: Image.PreserveAspectFit
            source: "file:///home/roman/develop/mokoplayer/prohodi.jpg"
            opacity: 0.2
        }
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
                    onClicked: plView.currentIndex = index
                    onDoubleClicked: {
                        //currentArtist.text = plView.model.get(plView.currentIndex).artist
                        //currentTitle.text   = plView.model.get(plView.currentIndex).song
                        //playStatus.text = ">"
                        plDoubleClicked(index)
                        //playNewTrack(index+1)
                    }
                }
            }
        }
        ListView {
            id: plView
            anchors.fill: parent
            model: PlayListModel { id: plModel }
            delegate: songDelegate
            highlight: Rectangle { color: "#eA6060"; radius: 5; opacity: 0.4 }//#f2ebeb #eaeaea
            highlightMoveVelocity: 1500.0
            focus: true
        }
/*        ScrollBar {
            flickable: plView
        }*/
    } //PLAYLIST

}
