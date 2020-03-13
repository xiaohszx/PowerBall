# 仿360 能量球

**功能**

* 鼠标单击圆形区域，随机切换一个百分比
* 鼠标双击圆形区域，水面效果

![demo](demo_wave.png)

**原理**

	水面效果是在qml中使用ShaderEffect实现。定时器控制正弦曲线。
**GLSL Versions**

GLSL Versions
|OpenGL Version	|GLSL Version|
|--|--|
|2.0|110|
|2.1|120|
|3.0|130|
|3.1|140|
|3.2|150|
|3.3|330|
|4.0|400|
|4.1|410|
|4.2|420|
|4.3|430|

GLSL ES Versions (Android, iOS, WebGL)

|OpenGL ES Version|	GLSL ES Version|
|--|--|
|2.0|100|
|3.0|300|