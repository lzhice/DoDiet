import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtGraphicalEffects 1.14
import models 1.0
import components 1.0

Item {
    property real todayCalories: -1
    ListModel{id: consumedModel}
    Component.onCompleted: {
        todayCalories = ConsumedModel.getCurrentDayCalories()
        consumedModel.append(ConsumedModel.getConsumed())
    }

    Text{
        id: currentDayCalorieText
        text: todayCalories.toFixed(2)
        color: AppTheme.textColor
        font{
            pixelSize: 30
            bold: true
        }
        anchors{
            top: parent.top
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: -15
        }
    }
    Text{
        text: "KCAL"
        color: AppTheme.textColor
        font{
            pixelSize: 12
            italic: true
        }
        anchors{
            bottom: currentDayCalorieText.bottom
            bottomMargin: 10
            left: currentDayCalorieText.right
            leftMargin: 5
        }
    }
    Image{
        id: weightImg
        source: "qrc:/measurement.svg"
        width: 150
        height: width
        sourceSize: Qt.size(width,height)
        anchors{
            top: currentDayCalorieText.bottom
            topMargin:  -10
            horizontalCenter: parent.horizontalCenter
        }
        Text{
            text: qsTr("Today")
            color: "white"
            font{
                pixelSize: 12
                italic: true
            }
            anchors{
                bottom: parent.bottom
                bottomMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
        }
    }
    ListView{
        id: consumedList

        clip: true

        anchors{
            left: parent.left
            right: parent.right
            top: weightImg.bottom
            bottom: parent.bottom
            margins: 5
        }
        section{
            property: "registerDate"
            delegate: Item {
                width: consumedList.width
                height: 30


                Rectangle{
                    id:sectionRect
                    color: Material.color(AppTheme.primaryInt,Material.Shade300)
                    width: 100
                    height: parent.height
                    radius: 10
                    anchors{
                        left: parent.left
                        leftMargin: 10
                    }
                    Rectangle{
                        color: Material.color(AppTheme.primaryInt,Material.Shade300)
                        height: 10
                        width: parent.width
                        anchors{
                            bottom: parent.bottom
                        }
                    }
                    Text{
                        text: section
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: AppTheme.textOnPrimaryColor
                    }
                }
                Rectangle{
                    color: Material.color(AppTheme.primaryInt,Material.Shade300)
                    height: 3
                    anchors{
                        bottom: parent.bottom
                        left: sectionRect.left
                        right: parent.right
                        rightMargin: 10
                    }
                }
            }
        }
        model:consumedModel

        delegate: Item{
            id:foodItem
            width: consumedList.width
            height: 160
            RoundButton{
                radius: 20
                Material.background: Material.color(AppTheme.primaryInt,Material.Shade100)

                anchors{
                    fill: parent
                    margins: 2
                }

                Rectangle{
                    id: foodImage

                    width: parent.height - 40
                    height: width
                    radius: 10
                    color: loader.active  ?"#D3D3D3"
                                          :"transparent"
                    clip: true

                    border{
                        width: 2
                        color: Material.color( AppTheme.primaryInt, Material.ShadeA700 )
                    }

                    anchors{
                        left: parent.left
                        leftMargin: 15
                        verticalCenter: parent.verticalCenter
                    }

                    Loader{
                        id: loader

                        visible: active
                        active: !img.visible
                        anchors.centerIn: parent

                        sourceComponent: BusyIndicator{
                            running: true
                            Material.theme: Material.Light
                        }
                    } // end of loader


                    Image {
                        id:img

                        source:       model.image.replace('.jpg','-s.jpg') // For thumbnail pictures
                        visible:      status === Image.Ready
                        asynchronous: true

                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                x: foodImage.x
                                y: foodImage.y
                                width: foodImage.width
                                height: foodImage.height
                                radius: foodImage.radius
                            } // End of Rectangle
                        }//End of OpacityMask

                        anchors{
                            fill: parent
                            margins: 5
                        }

                    }//End of Image
                } // end of rectangle -> foodImage

                Text {
                    id: foodName

                    text: model.label
                    elide: Qt.ElideRight

                    anchors{
                        top: foodImage.top
                        left: foodImage.right
                        leftMargin: 10
                        right: parent.right
                        rightMargin: 15
                    }

                    font{
                        bold:true
                        pixelSize: 17
                    }

                }// end of Text -> foodName

                Flow{
                    id:  labelsFlow
                    property var dateList: {
                        try{
                            model.registerDate.split(' ')
                        }catch(e){

                        }

                    }
                    spacing: 5

                    anchors{
                        top: foodName.bottom
                        topMargin: 2
                        left: foodImage.right
                        leftMargin: 10
                        right: parent.right
                        rightMargin: 15
                    }

                    Text {
                        id: dateText
                        text: qsTr("Consumed Date")+": "+model.registerDate
                        elide: Qt.ElideRight
                        font.pixelSize: 13
                    }

                    Text {
                        id: timeText
                        text: qsTr("Consumed Time")+": "+model.registerTime
                        elide: Qt.ElideRight
                        font.pixelSize: 13
                    }
                }// end of Flow -> labelsFlow

                Text {
                    id: caloriesText
                    text: qsTr("calories")+": " + model.calories.toFixed(2) + " kcal"
                    elide: Qt.ElideRight
                    font.pixelSize: 13
                    anchors{
                        top: labelsFlow.bottom
                        topMargin: 2
                        left: foodImage.right
                        leftMargin: 10
                        right: parent.right
                        rightMargin: 15
                    }

                }// end of Text -> caloriesText

                onClicked: {
                    mainStack.push("qrc:/views/RecipeDetail.qml",{recipeId:model.recipeId})
                }
            }// end of RoundButton
        } // end of delegate
    }

}
