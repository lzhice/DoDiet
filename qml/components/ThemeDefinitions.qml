pragma Singleton
import QtQuick 2.15
import QtQuick.Controls.Material 2.15

QtObject{
	id:root
    property int theme : Material.Dark
    property color textColor                : theme ?   "#FFFFFF"     : "#0F110F"
    property color shadowColor              : theme ?   "#171717"   :   "#EAEAEA"
    property color borderColor              : theme ?   "#ADFFFFFF" :   "#8D000000"
    property color borderColorOnPrimary     : Material.color(primaryInt,Material.Shade200)
    property color rippleColor              : theme ?   "#22171717" :   "#224D4D4D"
    property color primaryColor             : Material.color(primaryInt)
    property color placeholderColor         : theme ?   "#B3FFFFFF" :   "#B3000000"
    property color appBackgroundColor       : theme ?   "#2F2F2F"   :   "#FAFAFA"
    property color dialogBackgroundColor    : theme ?   "#3F3F3F"   :   "#FFFFFF"
    property color textOnPrimaryColor       : textOnPrimaryInt ? "#0F110F": "#FFFFFF"

    property int textOnPrimaryInt : 0

    property int primaryInt:  Material.Teal

}
