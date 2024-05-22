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
                        ], "selectedIndex": 1},
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

        property var filteredItems: items

        function getUniqueCommandTypes() {
            var commandTypes = items.map(function(item) {
                return item.commandType;
            });
            return commandTypes.filter((value, index, self) => self.indexOf(value) === index);
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Button {
                text: "Toggle Collapse/Expand All"
                Layout.preferredHeight: 40
                onClicked: {
                    var allExpanded = customModel.filteredItems.every(item => item.expanded);
                    for (var i = 0; i < customModel.items.length; i++) {
                        customModel.items[i].expanded = !allExpanded;
                    }
                    customModel.filteredItems = customModel.filteredItems; // Trigger update
                }
            }

            TextField {
                id: searchField
                placeholderText: "Search..."
                Layout.fillWidth: true
                onTextChanged: {
                    customModel.filteredItems = customModel.items.filter(function(item) {
                        return item.commandType.toLowerCase().indexOf(searchField.text.toLowerCase()) !== -1;
                    });
                }
            }

            ComboBox {
                id: commandTypeComboBox
                Layout.preferredWidth: 150
                model: ["A command", "B command", "C command"]
            }

            Button {
                text: "Add Command"
                Layout.preferredHeight: 40
                onClicked: {
                    var newCommandType = commandTypeComboBox.currentText;
                    var newParameters;

                    switch (newCommandType) {
                        case "A command":
                            newParameters = [
                                { "elementType": "TextField", "name": "param1", "value": "ValueA1" },
                                { "elementType": "comboBox", "name": "param2", "options": [
                                    { "name": "Option1", "value": 1 },
                                    { "name": "Option2", "value": 2 }
                                ], "selectedIndex": 0},
                                { "elementType": "checkBox", "name": "param3", "value": false },
                                { "elementType": "radioButton", "name": "param4", "options": [
                                    { "name": "Option1", "value": 1 },
                                    { "name": "Option2", "value": 2 }
                                ], "selectedIndex": 0}
                            ];
                            break;
                        case "B command":
                            newParameters = [
                                { "elementType": "TextField", "name": "param1", "value": "ValueB1" },
                                { "elementType": "comboBox", "name": "param2", "options": [
                                    { "name": "Option1", "value": 1 },
                                    { "name": "Option2", "value": 2 }
                                ], "selectedIndex": 1}
                            ];
                            break;
                        case "C command":
                            newParameters = [
                                { "elementType": "TextField", "name": "param1", "value": "ValueC1" },
                                { "elementType": "radioButton", "name": "param2", "options": [
                                    { "name": "Option1", "value": 1 },
                                    { "name": "Option2", "value": 2 }
                                ], "selectedIndex": 0}
                            ];
                            break;
                    }

                    customModel.items.push({
                        "commandType": newCommandType,
                        "parameters": newParameters,
                        "expanded": true
                    });
                    customModel.filteredItems = customModel.items; // Trigger update
                }
            }

            Button {
                text: "Filter Commands"
                Layout.preferredHeight: 40
                onClicked: filterPopup.open()
            }

            Button {
                text: "Clear All Filters"
                Layout.preferredHeight: 40
                onClicked: {
                    customModel.filteredItems = customModel.items
                }
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: listView
                width: parent.width
                height: parent.height
                model: customModel.filteredItems.length
                spacing: 20
                clip: true
                delegate: Rectangle {
                    id: commandElement
                    width: parent.width
                    property int commandIndex: index
                    color: "red"
                    height: {
                        if (customModel.filteredItems[commandElement.commandIndex]["expanded"]) {
                            85 * customModel.filteredItems[commandElement.commandIndex]["parameters"].length / 2 + 50
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
                            RowLayout {
                                anchors.fill: parent
                                spacing: 10

                                Text {
                                    text: customModel.filteredItems[commandElement.commandIndex]["commandType"]
                                    font.bold: false
                                    font.pointSize: 14
                                    Layout.alignment: Qt.AlignLeft
                                    Layout.fillWidth: true
                                }

                                Button {
                                    text: "Delete"
                                    Layout.alignment: Qt.AlignRight
                                    onClicked: {
                                        customModel.items.splice(commandElement.commandIndex, 1);
                                        customModel.filteredItems = customModel.items; // Trigger update
                                    }
                                }

                                Button {
                                    text: "Add Below"
                                    Layout.alignment: Qt.AlignRight
                                    onClicked: {
                                        addPopup.commandIndex = commandElement.commandIndex;
                                        addPopup.visible = true;
                                    }
                                }

                                Button {
                                    text: "Move Up"
                                    Layout.alignment: Qt.AlignRight
                                    enabled: commandElement.commandIndex > 0
                                    onClicked: {
                                        moveItem(customModel.items, commandElement.commandIndex, commandElement.commandIndex - 1);
                                        customModel.filteredItems = customModel.items; // Trigger update
                                    }
                                }

                                Button {
                                    text: "Move Down"
                                    Layout.alignment: Qt.AlignRight
                                    enabled: commandElement.commandIndex < customModel.filteredItems.length - 1
                                    onClicked: {
                                        moveItem(customModel.items, commandElement.commandIndex, commandElement.commandIndex + 1);
                                        customModel.filteredItems = customModel.items; // Trigger update
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    var customModelTemp = customModel.items;
                                    customModelTemp[commandElement.commandIndex]["expanded"] = !customModelTemp[commandElement.commandIndex]["expanded"];
                                    customModel.items = customModelTemp;
                                    customModel.filteredItems = customModel.filteredItems; // Trigger update
                                }
                            }
                        }

                        GridView {
                            id: parameterContainer
                            width: parent.width
                            height: 85 * customModel.filteredItems[commandElement.commandIndex]["parameters"].length / 2
                            model: customModel.filteredItems[commandElement.commandIndex]["parameters"].length
                            visible: customModel.filteredItems[commandElement.commandIndex]["expanded"] // Show/hide GridView based on expanded state
                            cellWidth: width / 2 // Set cell width to half the GridView width
                            cellHeight: 40 // Set cell height as needed

                            delegate: Component {
                                Loader {
                                    property int elemtIndex: index
                                    property string elementType: customModel.filteredItems[commandElement.commandIndex]["parameters"][elemtIndex]["elementType"]

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
                                                item.paramName = customModel.filteredItems[commandElement.commandIndex]["parameters"][elemtIndex]["name"]
                                                item.paramValue = customModel.filteredItems[commandElement.commandIndex]["parameters"][elemtIndex]["value"]
                                                item.clicked.connect(function() {
                                                    console.log("Item clicked: " + item.paramName)
                                                })
                                                item.textChanged.connect(function(newText) {
                                                    console.log("Text changed in " + item.paramName + ": " + newText)
                                                })
                                                break

                                            case "radioButton":
                                                item.paramName = customModel.filteredItems[commandElement.commandIndex]["parameters"][elemtIndex]["name"]
                                                item.paramOptions = customModel.filteredItems[commandElement.commandIndex]["parameters"][elemtIndex]["options"]
                                                item.selectedIndex = customModel.filteredItems[commandElement.commandIndex]["parameters"][elemtIndex]["selectedIndex"]

                                                item.optionChanged.connect(function(newOption, newOptionName) {
                                                    console.log("Option changed in " + item.paramName + ": " + newOption + ":" + newOptionName)
                                                })
                                                break

                                            case "comboBox":
                                                item.paramName = customModel.filteredItems[commandElement.commandIndex]["parameters"][elemtIndex]["name"]
                                                item.paramOptions = customModel.filteredItems[commandElement.commandIndex]["parameters"][elemtIndex]["options"]
                                                item.selectedIndex = customModel.filteredItems[commandElement.commandIndex]["parameters"][elemtIndex]["selectedIndex"]

                                                item.optionChanged.connect(function(newOption, newOptionName) {
                                                    console.log("ComboBox option changed in " + item.paramName + ": " + newOption + " (" + newOptionName + ")")
                                                })
                                                break

                                            case "checkBox":
                                                item.paramName = customModel.filteredItems[commandElement.commandIndex]["parameters"][elemtIndex]["name"]
                                                item.paramValue = customModel.filteredItems[commandElement.commandIndex]["parameters"][elemtIndex]["value"]

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
    }

    Popup {
        id: addPopup
        width: 300
        height: 200
        modal: true
        closePolicy: Popup.CloseOnEscape
        property int commandIndex: -1

        ColumnLayout {
            anchors.fill: parent
            spacing: 10
            //padding: 10

            Text {
                text: "Select Command Type"
                font.bold: true
                font.pointSize: 16
                Layout.alignment: Qt.AlignHCenter
            }

            ComboBox {
                id: popupCommandTypeComboBox
                Layout.fillWidth: true
                model: ["A command", "B command", "C command"]
            }

            Button {
                text: "OK"
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    var newCommandType = popupCommandTypeComboBox.currentText;
                    var newParameters;

                    switch (newCommandType) {
                        case "A command":
                            newParameters = [
                                { "elementType": "TextField", "name": "param1", "value": "ValueA1" },
                                { "elementType": "comboBox", "name": "param2", "options": [
                                    { "name": "Option1", "value": 1 },
                                    { "name": "Option2", "value": 2 }
                                ], "selectedIndex": 0},
                                { "elementType": "checkBox", "name": "param3", "value": false },
                                { "elementType": "radioButton", "name": "param4", "options": [
                                    { "name": "Option1", "value": 1 },
                                    { "name": "Option2", "value": 2 }
                                ], "selectedIndex": 0}
                            ];
                            break;
                        case "B command":
                            newParameters = [
                                { "elementType": "TextField", "name": "param1", "value": "ValueB1" },
                                { "elementType": "comboBox", "name": "param2", "options": [
                                    { "name": "Option1", "value": 1 },
                                    { "name": "Option2", "value": 2 }
                                ], "selectedIndex": 1}
                            ];
                            break;
                        case "C command":
                            newParameters = [
                                { "elementType": "TextField", "name": "param1", "value": "ValueC1" },
                                { "elementType": "radioButton", "name": "param2", "options": [
                                    { "name": "Option1", "value": 1 },
                                    { "name": "Option2", "value": 2 }
                                ], "selectedIndex": 0}
                            ];
                            break;
                    }

                    customModel.items.splice(addPopup.commandIndex + 1, 0, {
                        "commandType": newCommandType,
                        "parameters": newParameters,
                        "expanded": true
                    });
                    customModel.filteredItems = customModel.items; // Trigger update

                    addPopup.visible = false;
                }
            }

            Button {
                text: "Cancel"
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignRight
                onClicked: addPopup.visible = false
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

    Popup {
        id: filterPopup
        width: 300
        height: 200
        modal: true
        closePolicy: Popup.CloseOnEscape

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            Text {
                text: "Filter Command Types"
                font.bold: true
                font.pointSize: 16
                Layout.alignment: Qt.AlignHCenter
            }

            Repeater {
                id: filterRepeater
                model: customModel.getUniqueCommandTypes()

                CheckBox {
                    text: modelData
                    checked: true
                }
            }

            Button {
                text: "Apply Filter"
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    var selectedCommandTypes = [];
                    for (var i = 0; i < filterRepeater.count; i++) {
                        var checkBox = filterRepeater.itemAt(i);
                        if (checkBox.checked) {
                            selectedCommandTypes.push(checkBox.text);
                        }
                    }
                    customModel.filteredItems = customModel.items.filter(function(item) {
                        return selectedCommandTypes.indexOf(item.commandType) !== -1;
                    });
                    filterPopup.close();
                }
            }

            Button {
                text: "Clear All Filters"
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    customModel.filteredItems = customModel.items;
                    filterPopup.close();
                }
            }
        }
    }

    function moveItem(array, fromIndex, toIndex) {
        if (toIndex >= array.length) {
            var k = toIndex - array.length + 1;
            while (k--) {
                array.push(undefined);
            }
        }
        array.splice(toIndex, 0, array.splice(fromIndex, 1)[0]);
        customModel.filteredItems = array; // Trigger update
    }
}
