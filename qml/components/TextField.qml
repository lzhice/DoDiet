import QtQuick 2.14
import QtQuick.Templates 2.14 as T
import QtQuick.Controls 2.14
import QtQuick.Controls.impl 2.14
import QtQuick.Controls.Material 2.14
import QtQuick.Controls.Material.impl 2.14

T.TextField {
    id: control
    property bool hasCounter: true
    property alias borderColor : bgRect.border
    property color bgUnderItem
    property bool filedInDialog: false
    property bool fieldInPrimary : false

    color: fieldInPrimary ? "black" : AppTheme.textColor // Foreground Color
    padding: 10
    font {
        pixelSize: 14;
    }
    placeholderText: ""
    Material.accent: AppTheme.primaryColor
    topPadding: 8
    selectionColor: Material.accentColor
    selectedTextColor: Material.primaryHighlightedTextColor
    selectByMouse: true
    verticalAlignment: TextInput.AlignVCenter
    cursorDelegate: CursorDelegate { }
    horizontalAlignment: Qt.AlignLeft//AppTheme.ltr?Text.AlignLeft:Text.AlignRight
    Label {
        id: controlPlaceHolder
        text: control.placeholderText
        color: fieldInPrimary? "black"
                             :control.focus || control.text!==""?  AppTheme.textColor
                                                                :  AppTheme.placeholderColor
        y: control.focus || control.text!==""?-10:height-10
        anchors{
            left:  control.left
            leftMargin: parent.padding + 10
        }
        font{
            pixelSize:( control.focus || control.text!=""?10:12);
            bold:control.focus || control.text
        }
        Behavior on y {
            NumberAnimation{ duration: 160}
        }
        Rectangle{
            width: parent.width + 30
            anchors.right: parent.right
            anchors.rightMargin: -15
            height: parent.height
            z:-1
            color: filedInDialog? AppTheme.dialogBackgroundColor
                                : fieldInPrimary ? bgUnderItem
                                                 : AppTheme.appBackgroundColor
            visible: control.focus || control.text!==""
            radius: 15
        }
    }
    Label {
        id: counterLabel
        text: control.length+" / "+control.maximumLength
        color: fieldInPrimary ? "black":AppTheme.placeholderColor
        y: control.height-15
        visible: hasCounter
        anchors{
            left: control.left
            leftMargin: 30
        }
        font{
            pixelSize:12;
            bold:true
        }

        Rectangle{
            width: parent.width + 30
            anchors.right: parent.right
            anchors.rightMargin: -15
            height: parent.height
            z:-1
            color: filedInDialog? AppTheme.dialogBackgroundColor
                                : fieldInPrimary ? bgUnderItem
                                                 : AppTheme.appBackgroundColor
            radius: 15
        }
    }
    background: Rectangle {
        id: bgRect
        anchors.fill: parent
        border.color: control.focus? AppTheme.primaryColor
                                   : fieldInPrimary ? AppTheme.borderColorOnPrimary
                                                    : AppTheme.borderColor
        radius: 15
        color: "transparent"
    }
}

