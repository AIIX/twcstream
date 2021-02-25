import QtMultimedia 5.12
import QtQuick.Layouts 1.4
import QtQuick 2.9
import QtQuick.Controls 2.12 as Controls
import QtQuick.Window 2.3 as Window
import org.kde.kirigami 2.10 as Kirigami
import QtGraphicalEffects 1.0
import Mycroft 1.0 as Mycroft
import "." as Local

Mycroft.Delegate {
    id: twcLivePlayer
    property var currentState: sessionData.videoState
  
    fillWidth: true
    background: Rectangle {
        color: "black"
    }
    leftPadding: 0
    topPadding: 0
    rightPadding: 0
    bottomPadding: 0
    
    
    Keys.onReturnPressed: {
        player.playbackState === MediaPlayer.PlayingState ? player.pause() : player.play();
        controlBarItem.opened = true
    }
    
    Keys.onDownPressed: {
        controlBarItem.opened = true
        controlBarItem.forceActiveFocus()
    }
        
    onFocusChanged: {
        if(focus) {
            player.forceActiveFocus();
        }
    }
    
    Connections {
        target: Window.window
        onVisibleChanged: {
            if(player.playbackState == MediaPlayer.PlayingState) {
                player.stop()
            }
        }
    }
    
    function closeWindow() {
        player.stop()
        Window.window.close()
    }
    
    Timer {
        id: delaytimer
    }

    function delay(delayTime, cb) {
            delaytimer.interval = delayTime;
            delaytimer.repeat = false;
            delaytimer.triggered.connect(cb);
            delaytimer.start();
    }
    
    controlBar: Local.SeekControl {
        id: seekControl
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        playerControl: player
        z: 1000
    }
    
    Item {
        id: videoRoot
        anchors.fill: parent 
        
        Image {
            id: thumbart
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "images/background.png"
        }
        
        Video {
            id: player
            autoPlay: true
            autoLoad: true
            fillMode: VideoOutput.PreserveAspectFit
            anchors.fill: parent
            source: "http://weather-lh.akamaihd.net/i/twc_1@92006/master.m3u8"
            
            onStatusChanged: {
                console.log(status)
            }
            
            Keys.onDownPressed: {
                controlBarItem.opened = true
                controlBarItem.forceActiveFocus()
            }

	    MouseArea {
		anchors.fill: parent
		onClicked: {
			controlBarItem.opened = true
		}
	    }
        }
    }
}
