import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

Rectangle {
    width: 500
    height: 40
    color: "lightblue"
    property string paramName: ""
    property bool paramValue: false

    signal clicked()
    signal stateChanged(bool newState)

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5

        Text {
            id: textElement
            text: paramName
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
        }

        CheckBox {
            checked: paramValue
            onCheckedChanged: {
                parent.parent.stateChanged(checked)
            }
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
        }
    }

}
