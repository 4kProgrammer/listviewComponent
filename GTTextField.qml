import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

Rectangle {
//    width: 500
//    height: 40
    color: "lightblue"
    property string paramName: ""
    property string paramValue: ""

    signal clicked()
    signal textChanged(string newText)

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5

        Text {
            id: textElement
            text: paramName
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
        }

        TextField {
            text: paramValue
            onTextChanged: {
                // Use parent.parent to reference the Rectangle, which is the actual parent of RowLayout
                parent.parent.textChanged(text)
            }
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
        }
    }

//    MouseArea {
//        anchors.fill: parent
//        onClicked: parent.clicked
//    }
}
