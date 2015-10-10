/* GCompris - wind.qml
 *
 * Copyright (C) 2015 Sagar Chand Agarwal <atomsagar@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Sagar Chand Agarwal <atomsagar@gmail.com> (Qt Quick port)
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import GCompris 1.0
import "renewable_energy.js" as Activity
import "../../core"

Item {
    id: wind
    property bool active: false
    property alias power: windTransformer.power

    Image {
        id: cloud
        opacity: 1
        source: activity.url + "wind/" + (started ? "cloud_fury.svg" :"cloud_quiet.svg")
        sourceSize.width: parent.width * 0.20
        sourceSize.height: parent.height * 0.10
        anchors {
            right: parent.right
            top: parent.top
            topMargin: 0.05 * parent.height
            rightMargin: 0.05 * parent.width
        }
        property bool started: false
        MouseArea {
            anchors.fill: parent
            onClicked: {
                cloud.started = true
                windTimer.restart()
            }
        }
    }

    Timer {
        id: windTimer
        interval: 30000
        running: false
        repeat: false
        onTriggered: cloud.started = false
    }

    Image {
        id: windTransformer
        source: activity.url + (started ? "transformer.svg" : "transformer_off.svg")
        sourceSize.width: parent.width * 0.035
        height: parent.height * 0.06
        anchors {
            top: parent.top
            right: parent.right
            topMargin: parent.height * 0.2
            rightMargin: parent.width * 0.18
        }
        property bool started: false
        property double power: started ? windTurbine.power : 0
        MouseArea {
            anchors.fill: parent
            onClicked: {
                parent.started = !parent.started
            }
        }
    }

    Image {
        sourceSize.width: windTransformer.width / 2
        sourceSize.height: windTransformer.height / 2
        source: activity.url + "down.svg"
        anchors {
            bottom: windTransformer.top
            right: parent.right
            rightMargin: parent.width*0.20
        }

        Rectangle {
            width: windvoltage.width * 1.1
            height: windvoltage.height * 1.1
            border.color: "black"
            radius: 5
            color: "yellow"
            anchors {
                bottom: parent.top
                right: parent.right
            }
            GCText {
                id: windvoltage
                anchors.centerIn: parent
                text: wind.power.toString() + "W"
                fontSize: smallSize * 0.5
            }
        }
    }


    Image {
        source: activity.url + (windTurbine.power ? "wind/windturbineon.svg" : "wind/windturbineoff.svg")
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        anchors.fill: parent
    }

    Image {
        source: activity.url + (windTransformer.power ? "wind/windpoweron.svg" : "wind/windpoweroff.svg")
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        anchors.fill: parent
    }

    // Wind turbines
    Image {
        id: windTurbine
        source: activity.url + "wind/mast.svg"
        sourceSize.width: parent.width * 0.01
        anchors {
            top: parent.top
            right: parent.right
            topMargin: parent.height * 0.17
            rightMargin: parent.width * 0.05
        }
        property double power: cloud.started ? 1000 : 0

        Image {
            id: blade
            source: activity.url + "wind/blade.svg"
            sourceSize.height: parent.height * 1.3
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.top
                verticalCenterOffset: parent.height * 0.06
            }

            SequentialAnimation on rotation {
                id: anim
                loops: Animation.Infinite
                running: cloud.started
                NumberAnimation {
                    from: 0; to: 360
                    duration: 3000
                }
            }
        }
    }
}
