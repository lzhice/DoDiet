import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import components 1.0
import views 1.0
import models 1.0

ApplicationWindow {
    id: root

    width: 360
    height: 640
    minimumHeight: 640
    minimumWidth: 360
    visible: false
    title: qsTr("Hello World")

    Material.theme  : AppTheme.theme
    Material.primary: AppTheme.primaryInt

    Component.onCompleted: {
        console.time("Boot Time")
    }

    Loader{
        id: mainLoader
        asynchronous: true
        anchors.fill: parent
        active: true
        onLoaded: {
            RecipeModel.createTable()
            NutrientsModel.createTable()
            HistoriesModel.createTable()
        }
        onStatusChanged: {
            if (status === Loader.Ready)
            {
                root.visible = true
                console.timeEnd("Boot Time")
            }
        }

        sourceComponent: Page{
            //**********HEADER ITEM**************//
            header: ToolBar{
                RowLayout{
                    anchors.fill:parent
                    ToolButton{
                        icon{
                            source: drawer.visible? "qrc:/back.svg":"qrc:/menu.svg"
                            width: 20
                            height: 20
                        }
                        onClicked: {
                            if(!drawer.visible)
                                drawer.open()
                            else drawer.close()

                        }
                    }
                    Label{
                        text: qsTr("Do Diet")
                        Layout.fillWidth: true
                    }
                    ToolButton{
                        visible: mainStack.depth > 1
                        icon{
                            source: "qrc:/back.svg"
                            color: "white"
                            width: 20
                            height: 20
                        }
                        onClicked: {
                            mainStack.pop()
                        }
                    }
                }

            }
            Drawer{
                id: drawer
                height: mainStack.height
                y:header.height
                edge: Qt.LeftEdge
                width: Math.min(parent.width*2/3,350)
            }

            //**********Content ITEM**************//
            StackView{
                id: mainStack
                anchors.fill:parent
                initialItem: RecipesView{}
            }


            //**********FOOTER ITEM**************//
            footer: Label{
                visible: false
                width: parent.width
                text: "loading ..."
                leftPadding: 20
            }
        }

    }
}
