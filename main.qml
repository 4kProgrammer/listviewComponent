import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.0

ApplicationWindow {
    visible: true
    width: 1200
    height: 400
    title: "ListView with Different Delegates"

    QtObject {
        id: customModel
        property var items: [
            { "commandType": "A command", "parameters": [
                    { "elementType": "TextField", "name": "param1", "value": "Value1" },
                    { "elementType": "comboBox", "name": "param2", "options": [
                            { "name": "Option1", "value": 1 },
                            { "name": "Option2", "value": 2 }
                        ], "selectedIndex": 0},
                    { "elementType": "checkBox", "name": "param3", "value": true },
                    { "elementType": "radioButton", "name": "param4", "options": [
                            { "name": "Option1", "value": 1 },
                            { "name": "Option2", "value": 2 }
                        ], "selectedIndex": 0},
                ], "expanded": true },

            { "commandType": "B command", "parameters": [
                    { "elementType": "TextField", "name": "param1", "value": "Value1" },
                    { "elementType": "comboBox", "name": "param2", "options": [
                            { "name": "Option1", "value": 1 },
                            { "name": "Option2", "value": 2 }
                        ], "selectedIndex": 2},
                ], "expanded": true },

            { "commandType": "C command", "parameters": [
                    { "elementType": "TextField", "name": "param1", "value": "Value1" },
                    { "elementType": "radioButton", "name": "param2", "options": [
                            { "name": "Option1", "value": 1 },
                            { "name": "Option2", "value": 2 }
                        ], "selectedIndex": 1},
                    { "elementType": "radioButton", "name": "param3", "options": [
                            { "name": "Option1", "value": 1 },
                            { "name": "Option2", "value": 2 }
                        ], "selectedIndex": 0},
                ], "expanded": true }
        ]
    }

    ColumnLayout {
           anchors.fill: parent
           spacing: 10

           Button {
               text: "Toggle Collapse/Expand All"
               Layout.preferredHeight: 40
               onClicked: {
                   var allExpanded = customModel.items.every(item => item.expanded);
                   for (var i = 0; i < customModel.items.length; i++) {
                       customModel.items[i].expanded = !allExpanded;
                   }
                   customModel.items = customModel.items; // Trigger update
               }
           }

           ListView {
               Layout.fillWidth: true
               Layout.fillHeight: true
               model: customModel.items.length
               spacing: 20
            delegate: Rectangle {
                id: commandElement
                width: parent.width
                property int commandIndex: index
                color: "red"
                height: {
                    if (customModel.items[commandElement.commandIndex]["expanded"]) {
                        85 * customModel.items[commandElement.commandIndex]["parameters"].length / 2 + 50
                    } else {
                        50 // Only height of the title when collapsed
                    }
                }

                Column {
                    width: parent.width
                    spacing: 10

                    Rectangle {
                        width: parent.width
                        height: 50
                        color: "lightgray"
                        Text {
                            text: customModel.items[commandElement.commandIndex]["commandType"]
                            font.bold: false
                            font.pointSize: 14
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var customeModelTemp = customModel.items
                                customeModelTemp[commandElement.commandIndex]["expanded"] = !customeModelTemp[commandElement.commandIndex]["expanded"]
                                customModel.items = customeModelTemp
                            }
                        }
                    }

                    GridView {
                        id: parameterContainer
                        width: parent.width
                        height: 85 * customModel.items[commandElement.commandIndex]["parameters"].length / 2
                        model: customModel.items[commandElement.commandIndex]["parameters"].length
                        visible: customModel.items[commandElement.commandIndex]["expanded"] // Show/hide GridView based on expanded state
                        cellWidth: width / 2 // Set cell width to half the GridView width
                        cellHeight: 40 // Set cell height as needed

                        delegate: Component {
                            Loader {
                                property int elemtIndex: index
                                property string elementType: customModel.items[commandElement.commandIndex]["parameters"][elemtIndex]["elementType"]

                                sourceComponent: switch(elementType) {
                                                 case "TextField": return textFieldComponent
                                                 case "radioButton": return radioButtonComponent
                                                 case "comboBox": return comboBoxComponent
                                                 case "checkBox": return checkBoxComponent
                                                 }

                                onLoaded: {
                                    item.width = 500
                                    item.height = 50

                                    switch(elementType) {
                                        case "TextField":
                                            item.paramName = customModel.items[commandElement.commandIndex]["parameters"][elemtIndex]["name"]
                                            item.paramValue = customModel.items[commandElement.commandIndex]["parameters"][elemtIndex]["value"]
                                            item.clicked.connect(function() {
                                                console.log("Item clicked: " + item.paramName)
                                            })
                                            item.textChanged.connect(function(newText) {
                                                console.log("Text changed in " + item.paramName + ": " + newText)
                                            })
                                            break

                                        case "radioButton":
                                            item.paramName = customModel.items[commandElement.commandIndex]["parameters"][elemtIndex]["name"]
                                            item.paramOptions = customModel.items[commandElement.commandIndex]["parameters"][elemtIndex]["options"]
                                            item.selectedIndex = customModel.items[commandElement.commandIndex]["parameters"][elemtIndex]["selectedIndex"]

                                            item.optionChanged.connect(function(newOption, newOptionName) {
                                                console.log("Option changed in " + item.paramName + ": " + newOption + ":" + newOptionName)
                                            })
                                            break

                                        case "comboBox":
                                            item.paramName = customModel.items[commandElement.commandIndex]["parameters"][elemtIndex]["name"]
                                            item.paramOptions = customModel.items[commandElement.commandIndex]["parameters"][elemtIndex]["options"]
                                            item.selectedIndex = customModel.items[commandElement.commandIndex]["parameters"][elemtIndex]["selectedIndex"]

                                            item.optionChanged.connect(function(newOption, newOptionName) {
                                                console.log("ComboBox option changed in " + item.paramName + ": " + newOption + " (" + newOptionName + ")")
                                            })
                                            break

                                        case "checkBox":
                                            item.paramName = customModel.items[commandElement.commandIndex]["parameters"][elemtIndex]["name"]
                                            item.paramValue = customModel.items[commandElement.commandIndex]["parameters"][elemtIndex]["value"]

                                            item.stateChanged.connect(function(newState) {
                                                console.log("CheckBox state changed in " + item.paramName + ": " + newState)
                                            })
                                            break
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: textFieldComponent
        GTTextField {}
    }

    Component {
        id: radioButtonComponent
        GTRadioButtons {}
    }
    Component {
        id: comboBoxComponent
        GTComboBox {}
    }
    Component {
        id: checkBoxComponent
        GTCheckBox {}
    }
}
