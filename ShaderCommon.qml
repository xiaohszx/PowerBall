import QtQuick 2.12
import QtQuick.Controls 2.12

QtObject {

    // 如果环境是OpenGL ES2，默认的version是 version 110, 不需要写出来。
    // 比ES2更老的版本是ES 1.0 和 ES 1.1, 这种古董设备，还是不要玩Shader了吧。
    // ES2没有texture函数，要用旧的texture2D代替
    // 精度限定要写成float
    readonly property string gles2Ver: "
#define texture texture2D
precision mediump float;
"




    // 如果环境是OpenGL ES3，version是 version 300 es
    // ES 3.1 ES 3.2也可以。
    // ES3可以用in out 关键字，gl_FragColor也可以用out fragColor取代
    // 精度限定要写成float
    readonly property string gles3Ver: "#version 300 es
#define varying in
#define gl_FragColor fragColor
precision mediump float;

out vec4 fragColor;
"


    // 如果环境是OpenGL Desktop 3.x，version这里参考Qt默认的version 150。大部分Desktop设备应该都是150
    // 150 即3.2版本，第一个区分Core和Compatibility的版本。Core是核心模式，只有核心api以减轻负担。相应的Compatibility是兼容模式，保留全部API以兼容低版本。
    // 可以用in out 关键字，gl_FragColor也可以用out fragColor取代
    // 精度限定抹掉，用默认的。不抹掉有些情况下会报错，不能通用。
    readonly property string gl3Ver: "#version 150
#define varying in
#define gl_FragColor fragColor
#define lowp
#define mediump
#define highp

out vec4 fragColor;
"


    // 如果环境是OpenGL Desktop 2.x，version这里就用2.0的version 110，即2.0版本
    // 2.x 没有texture函数，要用旧的texture2D代替
    readonly property string gl2Ver: "#version 110
#define texture texture2D
"


    property string versionString: {
        if (Qt.platform.os === "android") {
            if (GraphicsInfo.majorVersion === 3) {
                console.log("android gles 3")
                return gles3Ver
            } else {
                console.log("android gles 2")
                return gles2Ver
            }
        } else {
            if (GraphicsInfo.majorVersion === 3 ||GraphicsInfo.majorVersion === 4) {
                return gl3Ver
            } else {
                return gl2Ver
            }
        }
    }

}
