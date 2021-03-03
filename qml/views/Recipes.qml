import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.14

import components 1.0
import controllers 1.0
import models 1.0

Item {
    id:root

    signal changeStatus(string state);

    RecipeControllers{ id: controllers }

    ListModel{
        id:recipeModel

        ListElement{
            localId:1
            image:""
            label : "Test"
            calories: 789.0
            dietLabels: "Low-Sodium"
            healthLabels:"Celery-free"
            share: ""
        }

    }

    GridLayout{
        id:  searchBox

        rows: 1
        height: 60
        columns: 3
        columnSpacing: 15

        anchors{
            top:        parent.top
            left:       parent.left
            right:      parent.right
            margins:    10
        }

        RoundButton{
            id:  fliterBtn
            Layout.row: 0
            Layout.column: 0
            Layout.columnSpan: 1
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: Layout.columnSpan
            Layout.preferredHeight: Layout.rowSpan

            spacing: 10

            Material.theme      :  Material.Light
            Material.background :  AppTheme.primaryInt
            Material.foreground :  "WHITE"

            text: qsTr("Filter")
            display: width <= (height+20) ? "IconOnly": "TextBesideIcon"

            icon{
                source: "qrc:/settings.svg"
                width: 20
                height: 20
                color: "white"
            }

            font{
                pixelSize: 18
                capitalization: Font.MixedCase
            }

            onClicked: {
                filterPopup.open()
            }
        }

        CustomTextField{
            id: searchInput

            Layout.row: 0
            Layout.column: 1
            Layout.columnSpan: 2
            Layout.fillWidth : true
            Layout.preferredHeight: 50
            Layout.preferredWidth: Layout.columnSpan

            hasCounter   : false
            rightPadding : 20
            placeholderText:qsTr("Search") + " ..."

            Keys.onEnterPressed: searchBtn.clicked(Qt.RightButton)
            Keys.onReturnPressed: searchBtn.clicked(Qt.RightButton)


            RoundButton{
                id:  searchBtn
                width: 50
                radius: 10
                height: width
                visible: opacity
                opacity: parent.text? 1 : 0

                Material.background: AppTheme.primaryInt
                Material.theme: Material.Light

                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                icon{
                    source: "qrc:/search.svg"
                    width: 35
                    height: 35
                    color: "white"
                }

                onClicked: {
                    if(parent.text.trim() === "")
                        return // return if user not type anything

                    let data = {q:searchInput.text.trim().toLowerCase()}
                    recipeModel.clear()
                    searchGuide.close()
                    controllers.getItemsByQuery(data,recipeModel)
                }

                Behavior on opacity {
                    NumberAnimation{duration: 200}
                }

            } // end of RoundButton

            onTextChanged: {
                if(text.trim() !== "")
                {
                    let hints = HistoriesModel.getHistoryByKey(searchInput.text.trim().toLowerCase())
                    if(hints.length)
                    {
                        searchGuide.open()
                        searchGuide.hintsModel.clear()
                        searchGuide.hintsModel.append(hints)
                    }
                    else {
                        searchGuide.close()
                    }
                }
                else searchGuide.close()

                changeStatus("")

            }

            Component.onCompleted: {
                forceActiveFocus()
            }
        } // end of CustomTextField

        Popup{
            id:  searchGuide
            width: searchInput.width
            x: searchInput.x
            y: searchInput.height+ 10
            height: Math.min(hintsList.contentHeight,root.height-searchBox.height)+40
            property ListModel hintsModel: ListModel{}

            Label{
                id:label
                text: qsTr("History")
                anchors{
                    top: parent.top
                    left: parent.left
                    topMargin: -2
                    leftMargin: -3
                }
                font{
                    pixelSize: 12
                    italic: true
                }
            }

            ListView{
                id: hintsList
                anchors.top: label.bottom
                anchors.bottom: parent.bottom
                width: parent.width
                clip: true

                delegate: Item{
                    id: hintBtn
                    width: searchGuide.width
                    height: 40
                    Image{
                        id: hintIcon
                        source: "qrc:/history.svg"
                        width: 20
                        height: 20
                        visible: false
                        sourceSize: Qt.size(width,height)
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 5
                        }
                    }
                    ColorOverlay{
                        anchors.fill: hintIcon
                        source: hintIcon
                        color: AppTheme.textColor
                    }

                    Text {
                        text: key
                        color: AppTheme.textColor
                        font{
                            pixelSize: 14
                            capitalization: Font.MixedCase
                        }
                        anchors{
                            verticalCenter: hintIcon.verticalCenter
                            left: hintIcon.right
                            leftMargin: 10
                        }
                    }
                    Rectangle{
                        height: 1
                        width: parent.width
                        anchors{
                            bottom: parent.bottom
                            bottomMargin: 2
                        }
                        color: AppTheme.textColor
                        visible: index !== (searchGuide.hintsModel.count-1)
                    }

                    MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            searchInput.text = model.key
                            searchGuide.close()
                            searchBtn.clicked(Qt.RightButton)
                        }
                    }
                }

                model: searchGuide.hintsModel
            }
        }

        Popup{
            id:  filterPopup
            width: 260
            x: fliterBtn.x
            y: fliterBtn.height
            height: Math.min(300,root.height-searchBox.height)
        }
    } // End of GridLayout

    GridView{
        id:recipeList

        clip: true
        cellHeight: 160
        cellWidth: width / (parseInt(width / 300)===0?1:parseInt(width / 300))

        delegate: RecipeItem{}

        model: recipeModel

        anchors{
            top:    searchBox.bottom
            left:   parent.left
            right:  parent.right
            bottom: parent.bottom
            topMargin:      10
            leftMargin:     10
            rightMargin:    10
        }

    }

    Loader{
        id: statusImageLoader

        anchors{
            fill: recipeList
            margins: 5
        }
        active: false

        sourceComponent: GridLayout{
            id: statusItem
            rows: 5
            columns: 1
            rowSpacing: 15
            anchors.fill: parent
            state: "searching"
            states: [
                State{
                    name : "not-found"

                    PropertyChanges{ target: searchIndicator;   running:    false }
                    PropertyChanges{ target: statusText;        text:        qsTr("Not Found Anything For") +" '"+searchInput.text.trim()+"'" }
                    PropertyChanges{ target: statusImage;       source:     "qrc:/not-found.svg"}
                },

                State{
                    name : "searching"

                    PropertyChanges{ target: searchIndicator;   running:    true }
                    PropertyChanges{ target: statusImage;       source:     "qrc:/searching.svg" }
                    PropertyChanges{ target: statusText;        text:       qsTr("Searching ...") }
                }
            ]
            Image{
                id: statusImage
                Layout.row: 0
                Layout.column: 0
                Layout.rowSpan: 3
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredHeight: Layout.rowSpan
                Layout.preferredWidth: Layout.columnSpan
                fillMode: Image.PreserveAspectFit
            }

            BusyIndicator{
                id: searchIndicator
                Layout.row: 3
                Layout.column: 0
                Layout.rowSpan: 1
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredHeight: Layout.rowSpan
                Layout.preferredWidth: Layout.columnSpan
                visible: running
            }

            Text{
                id: statusText
                Layout.row: 4
                Layout.column: 0
                Layout.rowSpan: 1
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: Layout.rowSpan
                Layout.preferredWidth: Layout.columnSpan
                Layout.fillWidth: true
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                color: AppTheme.textColor
                horizontalAlignment: Text.AlignHCenter

                font{
                    pixelSize: 20
                    bold: true
                }

            }// end of Text
        }
        //        } // end of Item
    } // end of loader

    //SLOTS

    onChangeStatus: {
        if(state !== "")
        {
            statusImageLoader.active = true
            statusImageLoader.item.state = state
        }
        else {
            statusImageLoader.active = false
        }
        searchInput.enabled= state!= "searching"
    }
}
