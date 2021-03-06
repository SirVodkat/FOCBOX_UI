/*
    Copyright 2018 Benjamin Vedder	benjamin@vedder.se

    

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program .  If not, see <http://www.gnu.org/licenses/>.
    */

import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import Vedder.vesc.vescinterface 1.0
import Vedder.vesc.configparams 1.0

Item {
    id: editor
    property string paramName: ""
    property ConfigParams params: null
    height: column.implicitHeight + 2 * column.anchors.margins
    Layout.fillWidth: true
    property real maxVal: 1.0

    Component.onCompleted: {
        if (params !== null) {
            nameText.text = params.getLongName(paramName)
            boolSwitch.checked = params.getParamBool(paramName)

            if (params.getParamTransmittable(paramName)) {
                nowButton.visible = true
                defaultButton.visible = true
            } else {
                nowButton.visible = false
                defaultButton.visible = false
            }
        }
    }

    Rectangle {
        id: rect
        color: "#00000000"
        anchors.fill: parent
        radius: 0
        border.color: "#00cca3"
        border.width: 3

        ColumnLayout {
            id: column
            spacing: 10
            anchors.fill: parent
            anchors.margins: 10

            Text {
                id: nameText
                text: paramName
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
                font.pointSize: 12
            }

            Switch {
                id: boolSwitch
                spacing: 10
                Layout.fillWidth: true

                onCheckedChanged: {
                    if (params !== null) {
                        if (params.getUpdateOnly() !== paramName) {
                            params.setUpdateOnly("")
                        }
                        params.updateParamBool(paramName, checked, editor);
                    }
                }
            }

            RowLayout {
                spacing: 10
                Layout.fillWidth: true
                Button {
                    id: nowButton
                    Layout.fillWidth: true
                    Layout.preferredWidth: 500
                    flat: false
                    text: "Current"
                    Layout.fillHeight: false
                    font.capitalization: Font.MixedCase
                    spacing: 10
                    onClicked: {
                        params.setUpdateOnly(paramName)
                        params.requestUpdate()
                    }
                }

                Button {
                    id: defaultButton
                    Layout.fillWidth: true
                    Layout.preferredWidth: 500
                    flat: false
                    text: "Default"
                    spacing: 10
                    onClicked: {
                        params.setUpdateOnly(paramName)
                        params.requestUpdateDefault()
                    }
                }

                Button {
                    id: helpButton
                    Layout.fillWidth: true
                    Layout.preferredWidth: 500
                    flat: false
                    text: "Help"
                    spacing: 10
                    padding: 1
                    topPadding: 5
                    font.weight: Font.Light
                    onClicked: {
                        VescIf.emitMessageDialog(
                                    params.getLongName(paramName),
                                    params.getDescription(paramName),
                                    true, true)
                    }
                }
            }
        }
    }

    Connections {
        target: params

        onParamChangedBool: {
            if (src !== editor && name == paramName) {
                boolSwitch.checked = newParam
            }
        }
    }
}
