import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtGraphicalEffects 1.15
import components 1.0

Component{
    id: recipeComponent

    Item{
        id:foodItem

        width:  recipeList.cellWidth
        height: recipeList.cellHeight

        RoundButton{
            radius: 20
            Material.background: Material.color(AppTheme.primaryInt,Material.Shade100)

            anchors{
                fill: parent
                margins: 5
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
                    id: dietText
                    text: model.dietLabels
                    elide: Qt.ElideRight
                    font.pixelSize: 13
                }

                Text {
                    id: healthText
                    text: model.healthLabels
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
                console.log(model.localId)
                mainStack.push("qrc:/views/RecipeDetail.qml",{recipeId:model.localId})
            }
        }// end of RoundButton
    }//end of Item
}//end of Component
