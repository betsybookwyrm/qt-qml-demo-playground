/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.0
import QtQuick.Particles 2.0
import "content"

Rectangle {
    id: root
    property bool readySetGo: false
    //Debugging
    property int hits: 0
    property int misses: 0
    property real ratio: hits/(misses?misses:1)
    //Move to JS file?
    property Ship redVar1: Ship {shipType: 1; gunType: 1}
    property Ship redVar2: Ship {shipType: 1; gunType: 2}
    property Ship redVar3: Ship {shipType: 1; gunType: 3}
    property Ship greenVar1: Ship {shipType: 3; gunType: 1}
    property Ship greenVar2: Ship {shipType: 2; gunType: 2}
    property Ship greenVar3: Ship {shipType: 1; gunType: 3}
    property string winner: "0"
    property int players: 0
    function aiSet(ship) {
        ship.gunType = Math.floor(Math.random() * 3) + 1
        ship.shipType = Math.floor(Math.random() * 3) + 1
    }

    width: 360
    height: 600
    color: "black"
    SequentialLoader {
        anchors.fill: parent
        //General Children
        Image {
            anchors.centerIn: parent
            source: "../images/finalfrontier.png"
        }
        ParticleSystem {
            id: particles
        }
        PlasmaPatrolParticles { sys: particles; z: 100 }//Renders all particles on the one plane
        //Component parts
        id: pageControl
        Component.onCompleted: advance();
        pages:[
        Component {Item {
            id: menu
            width: root.width
            height: root.height
            Column {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                spacing: 8
                Item {
                    id: title
                    width: root.width
                    height: 240
                    Emitter {
                        anchors.fill: parent
                        system: particles
                        enabled: true
                        group: "default"
                        emitRate: 1200
                        lifeSpan: 1200
                        shape: MaskShape {source:"content/pics/TitleText.png"}
                        size: 16
                        endSize: 0
                        sizeVariation: 8
                        speed: AngleDirection {angleVariation:360; magnitudeVariation: 6}
                    }
                }
                Button {
                    text: "1P"
                    onClicked: {root.players = 1; pageControl.advance();}
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Button {
                    text: "2P"
                    onClicked: {root.players = 2; pageControl.advance();}
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Button {
                    text: "Demo"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {root.players = 0; 
                        aiSet(redVar1);
                        aiSet(redVar2);
                        aiSet(redVar3);
                        aiSet(greenVar1);
                        aiSet(greenVar2);
                        aiSet(greenVar3);
                        pageControl.at = 5;//TODO: Not a magic number
                        pageControl.advance();}
                }
                Button {
                    text: "Help"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        pageControl.at = 7;//TODO: Not a magic number
                        pageControl.advance();
                    }
                }
                Button {
                    text: "Quit"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: Qt.quit();
                }
            }
        }},
        Component {Item {
            id: p1Screen
            z: 101
            width: root.width
            height: root.height
            Rectangle {
                anchors.fill: parent
                color: "red"
            }
            Text {
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 64
                font.bold: true
                text: "Player\n    1"
                horizontalAlignment: Text.AlignHCenter
            }
            MouseArea {
                anchors.fill: parent
                onClicked: pageControl.advance()
            }
        }},
        Component {Item {
            id: p1Choices
            z: 3
            width: root.width
            height: root.height
            Rectangle {
                color: "black"
                anchors.fill: parent
            }
            Column {
                spacing: 16
                width: root.width
                anchors.horizontalCenter: parent.horizontalCenter
                ChoiceBox {
                    target: redVar1
                    system: particles
                }
                ChoiceBox {
                    target: redVar2
                    system: particles
                }
                ChoiceBox {
                    target: redVar3
                    system: particles
                }
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Next"
                    onClicked: {
                        if (root.players < 2) {
                            aiSet(greenVar1);
                            aiSet(greenVar2);
                            aiSet(greenVar3);
                            pageControl.at = 5;//TODO: Not a magic number
                        }
                        pageControl.advance();
                    }
                }
            }
        }},
        Component {Item {
            id: p2Screen
            z: 101
            width: root.width
            height: root.height
            Rectangle {
                anchors.fill: parent
                color: "green"
            }
            Text {
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 64
                font.bold: true
                text: "Player\n    2"
                horizontalAlignment: Text.AlignHCenter
            }
            MouseArea {
                anchors.fill: parent
                onClicked: pageControl.advance()
            }
        }},
        Component {Item {
            id: p2Choices
            z: 1
            width: root.width
            height: root.height
            Rectangle {
                color: "black"
                anchors.fill: parent
            }
            Column {
                spacing: 16
                width: root.width
                anchors.horizontalCenter: parent.horizontalCenter
                ChoiceBox {
                    target: greenVar1
                    system: particles
                }
                ChoiceBox {
                    target: greenVar2
                    system: particles
                }
                ChoiceBox {
                    target: greenVar3
                    system: particles
                }
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Next"
                    onClicked: pageControl.advance()
                }
            }
        }},
        Component {Item {
            id: arena
            width: root.width
            height: root.height
            z: 0
            Component.onCompleted: root.readySetGo = true
            Component.onDestruction: root.readySetGo = false
            property bool victory: redShip3.hp <= 0 || greenShip3.hp <=0
            onVictoryChanged: {
                if (redShip3.hp <= 0) {
                    if (greenShip3.hp <= 0) {
                        root.winner = "1&2"
                    }else {
                        root.winner = "2"
                    }
                } else {
                    root.winner = "1"
                }
                winTimer.start()
            }
            Timer {
                id: winTimer
                interval: 1200
                repeat: false
                running: false
                onTriggered: pageControl.advance();
            }
            Ship {
                id: redShip1
                shipParticle: "redTeam"
                system: particles
                x: 180-64
                y: 128
                shipType: redVar1.shipType
                gunType: redVar1.gunType
                targets: [greenShip1, greenShip2, greenShip3]
            }
            Ship {
                id: redShip2
                shipParticle: "redTeam"
                system: particles
                x: 0
                y: 0
                shipType: redVar2.shipType
                gunType: redVar2.gunType
                targets: [greenShip1, greenShip2, greenShip3]
            }
            Ship {
                id: redShip3
                shipParticle: "redTeam"
                system: particles
                x: 360-128
                y: 0
                shipType: redVar3.shipType
                gunType: redVar3.gunType
                targets: [greenShip1, greenShip2, greenShip3]
            }

            Ship {
                id: greenShip1
                shipParticle: "greenTeam"
                system: particles
                x: 180-64
                y: 600 - 128 - 128
                shipType: greenVar1.shipType
                gunType: greenVar1.gunType
                targets: [redShip1, redShip2, redShip3]
            }
            Ship {
                id: greenShip2
                shipParticle: "greenTeam"
                system: particles
                x: 0
                y: 600-128
                shipType: greenVar2.shipType
                gunType: greenVar2.gunType
                targets: [redShip1, redShip2, redShip3]
            }
            Ship {
                id: greenShip3
                shipParticle: "greenTeam"
                system: particles
                x: 360 - 128
                y: 600 - 128
                shipType: greenVar3.shipType
                gunType: greenVar3.gunType
                targets: [redShip1, redShip2, redShip3]
            }
        }},
        Component {Item {
            id: winScreen
            z: 101
            width: root.width
            height: root.height
            /*
            Rectangle {
                anchors.fill: parent
                color: "black"
            }
            */
            Text {//TODO: Particle Text?
                anchors.fill: parent
                color: "white"
                font.pixelSize: 64
                font.bold: true
                text: "Player " + root.winner + " wins!"
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {pageControl.at = 0; pageControl.advance();}
            }
        }},
        Component {
            HelpScreens {
                onExitDesired: {pageControl.at = 0; pageControl.advance();}
            }
        }
        ]
    }
}
