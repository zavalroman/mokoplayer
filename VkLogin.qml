import QtQuick 2.6
import QtQuick.Window 2.2
//import QtQuick.Controls 1.0
import QtWebKit 3.0

Window {
    id: loginWindow
    visible: true
    width: 1024
    height: 768
    color: "#ffffff"
    title: qsTr("VK Login")

    WebView {
        id: webview
        anchors.fill: parent
        url: "https://oauth.vk.com/authorize?client_id=5534287&scope=audio&redirect_url=https://oauth.vk.com/blank.html&display=popup&v=5.52&response_type=token"
        onLoadingChanged: { sendLoginUrl(url) }
    }


}


