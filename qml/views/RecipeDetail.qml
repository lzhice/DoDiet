import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtGraphicalEffects 1.14
import components 1.0
import models 1.0

Item {
    id:root

    property int recipeId: -1
    property var model
    property string totalNutrients :""

    Component.onCompleted: {
        model = RecipeModel.getRecipeById(recipeId)
        let nuts = NutrientsModel.getNutrientsByRecipe(recipeId)
        totalNutrients = "<ul>"
        for(let i=0;i<nuts.length;i++){
            totalNutrients += "<li>"+nuts[i].name +'='+ nuts[i].quantity.toFixed(2) +" ("+nuts[i].unit+") - "+nuts[i].dailyQuantity.toFixed(2) +" (%)</li>"
        }
        totalNutrients += "</ul>"
    }
    Flickable{
        id: mainFlick
        anchors{
            fill: parent
            margins: 15
        }

        onContentYChanged: {
            if(contentY<0 || contentHeight < mainFlick.height)
                contentY = 0
            else if(contentY > contentHeight)
                contentY = contentHeight
        }

        onContentXChanged: {
            if(contentX<0 || contentWidth < mainFlick.width)
                contentX = 0
            else if(contentX > contentWidth)
                contentX = contentWidth
        }
        contentWidth: mainFlick.width
        contentHeight: Math.max(root.height - 30,mainFlow.height + 30)
        Rectangle{
            id: backRect
            width: mainFlick.contentWidth
            height: mainFlick.contentHeight
            radius: 20
            color: Material.color(AppTheme.primaryInt,Material.Shade50)
        }
        Flow{
            id: mainFlow
            clip: true
            spacing: 10
            anchors{
                top: parent.top
                topMargin: 20
                left: parent.left
                leftMargin: 20
                right: parent.right
                rightMargin: 20
            }

            Rectangle{
                id: foodImage

                width: Math.min(200,parent.width-50)
                height: width
                radius: 10
                color: loader.active  ?"#D3D3D3"
                                      :"transparent"
                clip: true

                border{
                    width: 2
                    color: Material.color( AppTheme.primaryInt, Material.ShadeA700 )
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

                    source: model.image.replace('.jpg','-l.jpg') // For large pictures
                    visible: status === Image.Ready
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
            }

            Flow{
                id: innerFlow
                width: Math.max(foodName.width,sourceText.width,caloriesText.width,totalWeightText.width,yieldText.width,mainFlow.width - foodImage.width - 10)
                spacing: 10
                Text {
                    id: foodName
                    text: model.label
                    font{
                        bold:true
                        pixelSize: 20
                    }

                }// end of Text
                MenuSeparator{width: parent.width;height: 2;opacity: 0} // sperator
                Text {
                    id: sourceText
                    font.pixelSize: 14
                    text: "<b>"+qsTr("source")+": " +'<a href="'+model.url+'">'+(model.source??"")+"</a>"

                    onLinkActivated:{
                        Qt.openUrlExternally(model.url)
                    }
                }// end of Text

                Text {
                    id: caloriesText
                    font.pixelSize: 14
                    text: "<b>"+qsTr("Calories")+": </b>" +(model.calories.toFixed(2)??"-")+ "<i> kcal </i>"

                }// end of Text
                Text {
                    id: yieldText
                    font.pixelSize: 14
                    text:"<b>"+ qsTr("Number of servings")+": </b>" +( model.yield??"-")+ "<i> person </i>"

                }// end of Text
                Text {
                    id: totalWeightText
                    font.pixelSize: 14
                    text: "<b>"+qsTr("Weight")+": </b>" +( model.totalWeight.toFixed(2)??"-")+ "<i> g </i>"

                }// end of Text

                Text {
                    id: dietText
                    text: "<b>"+qsTr("Diet label")+": </b>" + (model.dietLabels??"-")
                    font.pixelSize: 14
                }

                Text {
                    id: healthText
                    text: "<b>"+qsTr("Health label")+": </b>" +(model.healthLabels??"-")
                    font.pixelSize: 14
                }
            }
            Item{
                width: parent.width
                height: 60
                RoundButton{
                    width: foodImage.width
                    height: 60
                    text: qsTr("consume")
                    anchors{
                        left: parent.left
                        leftMargin: 15
                    }
                    Material.background: AppTheme.primaryInt
                }
            }
            Text {
                id: ingredientsText
                elide: Qt.ElideRight
                width: Math.max(250,mainFlow.width/2 -20)
                font.pixelSize: 15
                font.letterSpacing: 0.8
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignLeft
                text:"<b>"+ qsTr("Ingredients")+":</b>" + (model.ingredientLines??"")
            }
            Text {
                id: nutrientsText
                elide: Qt.ElideRight
                width: Math.max(250,mainFlow.width/2 -20)
                font.pixelSize: 15
                font.letterSpacing: 0.8
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: Text.AlignLeft
                text:"<b>"+ qsTr("Nutrients") + " - "+ qsTr("Nutrients per serving")+":</b>"
                     + (totalNutrients??"-")
            }// end of Text

        }

    }
}
