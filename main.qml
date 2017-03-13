import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Image {
    id:root
    width:1024
    height: 768
    source:"qrc:/bg.jpg"
    Item {
        id:mainRect
        x:0
        y:0
        width:130
        height:50
        property bool containsMouse: dragArea.containsMouse
        MouseArea {
            id:dragArea
            anchors.fill: parent
            property real lastX :0
            property real lastY :0
            onContainsMouseChanged: {
                if(containsMouse) {
                    lastX = mouseX
                    lastY = mouseY
                }
            }
            onPositionChanged:  {
                mainRect.x += mouseX - lastX
                mainRect.y += mouseY - lastY
            }
        }

        Rectangle {
            id:bar
            width:parent.width
            height:40
            radius:height/2
            color:"white"
            anchors.verticalCenter: parent.verticalCenter
            border.color: "green"
            border.width: mainRect.containsMouse ?  2 : 0
            Column {
                anchors.top:parent.top
                anchors.bottom: parent.bottom
                anchors.right:parent.right
                anchors.left: parent.left
                anchors.leftMargin: ballrect.width + 5
                spacing: 5
                Row {
                    Image{
                        source:"qrc:/ArrowUp.png"
                    }
                    Text {
                        text:"1024MB/s"
                    }
                }
                Row{
                    Image{
                        source:"qrc:/ArrowDown.png"
                    }
                    Text {
                        text:"1024MB/s"
                    }
                }
            }
        }
        Rectangle{
            id:ballrect
            width:50
            height:50
            radius:25
            color:"white"
            border.color: "green"
            border.width: mainRect.containsMouse ?  2 : 0
            Rectangle {
                id:ball
                width:40
                height:40
                radius:20
                anchors.centerIn: parent
                border.color: "white"
                border.width: 1
                color:"green"
                property real percent : 0.75
                Behavior on percent { NumberAnimation { duration: 1000}}
                property bool wave: false
                Rectangle {
                    anchors.fill:parent
                    layer.enabled: true
                    layer.effect: ShaderEffect {
                        id:shader
                        property real percent: ball.percent
                        property real radius: 0.5
                        property real antialias: 0.05

                        property bool wave: ball.wave
                        onWaveChanged:  {
                            if(wave) {
                                startAnimation()
                            }
                        }
                        property real frequency: 0
                        property real amplitude: 0.05

                        property real time: 0.0
                        SequentialAnimation {
                            id:waveAnimation

                            NumberAnimation {
                                target: shader
                                property: "time"
                                to: Math.PI * 10
                                easing.type: Easing.InOutQuad
                                duration: 3000
                                loops: 1
                            }
                            onStopped: stopAnimation()
                        }
                        function startAnimation() {
                            frequency = 6
                            waveAnimation.start()
                        }
                        function stopAnimation() {
                            time = 0
                            frequency = 0
                            ball.wave = false
                        }

                        fragmentShader:  "
                                    varying highp vec2 qt_TexCoord0;
                                    uniform highp float percent;
                                    uniform highp float radius;
                                    uniform highp float antialias;
                                    uniform highp float frequency;
                                    uniform highp float amplitude;
                                    uniform highp float time;
                                    uniform lowp float qt_Opacity;
                                    void main() {
                                        float distance = length(qt_TexCoord0 -  vec2(0.5, 0.5));
                                        if (distance - radius > antialias)
                                            discard;
                                        float t = smoothstep(0, antialias, distance);
                                        vec2 pulse = sin(time - frequency * qt_TexCoord0);
                                        vec2 coord = qt_TexCoord0 + amplitude * vec2(pulse.x, -pulse.x);

                                        if (coord.y < (1.0 - percent))
                                            gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0 - t);
                                        else
                                            gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0 - t);
                                    }
"

                    }
                }
                Text {
                    anchors.centerIn: parent
                    text:parseInt(ball.percent * 100) + "%"
                    color:"white"
                    font.pointSize: 16
                }


                MouseArea {
                    id:ballArea
                    anchors.fill: parent
                    Timer {
                        id:timer
                        interval: 200
                        onTriggered: ballArea.singleClick()
                    }
                    onClicked:{
                        if(timer.running) {
                            doubleClick()
                            timer.stop()
                        } else {
                            timer.restart()
                        }
                    }
                    function singleClick() {
                        ball.wave = true
                    }
                    function doubleClick() {
                        ball.percent = Math.random().toFixed(2)
                    }

                }
            }
        }
    }

}
