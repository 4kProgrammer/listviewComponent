import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

Rectangle {
    width: 500
    height: 100
    color: "lightblue"
    property string paramName: ""
    property var paramOptions: []
    property int selectedIndex: -1

    signal clicked()
    signal optionChanged(var newOption, string newOptionName)

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5

        Text {
            id: textElement
            text: paramName
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
        }

        ComboBox {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
            model: paramOptions
            textRole: "name"
            valueRole: "value"
            currentIndex: selectedIndex

            onCurrentIndexChanged: {
                parent.parent.selectedIndex = currentIndex
                parent.parent.optionChanged(paramOptions[currentIndex].value, paramOptions[currentIndex].name)
            }
        }
    }


}
