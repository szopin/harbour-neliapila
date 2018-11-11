import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import io.thp.pyotherside 1.4
import Nemo.Thumbnailer 1.0

DockedPanel {

    id: newPostItem

    property string boardId: boardId
    property int replyTo
    property string selectedFile

    property string nickname: nameText.text
    property string options: ""
    property string subject: subjectText.text
    property string comment: commentText.text
    //property string file_path: selectedFile ? selectedFile : ""
    property variant captcha_token
    property bool optionalFieldsVisible: false
    property bool busy: false

    //anchors.fill: parent
    width: parent.width
    height: commentRow.height + postActionButtons.height + optionalFields.height + pageMargin*2

    Item {
        anchors.fill: parent
        enabled: !busy

        Rectangle {
            anchors.fill: parent

            //color: "black"

            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightDimmerColor, 1) }
                GradientStop { position: 5.0; color: Theme.rgba(Theme.highlightDimmerColor, 0.5) }
            }

        }
    }

    Item{

        anchors{
            fill: parent
            topMargin: pageMargin
            bottomMargin: Theme.paddingSmall
            leftMargin: pageMargin
            rightMargin: pageMargin
        }



        BusyIndicator {
            id: postBusyIndicator;
            anchors.centerIn: parent
            size: BusyIndicatorSize.Large;
            running: newPostItem.busy;
            visible: newPostItem.busy;
        }

        Column {
            id: column

            width: parent.width
            height: commentText.text
                    ? commentText.height
                    : commentText.height + screen.height * 0.3
            //height: parent.contentHeight
            spacing: Theme.paddingSmall
            opacity: newPostItem.busy
                    ? 0.5
                    : 1

            anchors.fill: parent

            Row{
                id: commentRow
                //width: parent.width

                spacing: 0
                //spacing: Theme.paddingSmall

                Rectangle{
                    //spacing: Theme.paddingSmall
                    width: column.width/3
                    height: width

                    //color: "transparent"

                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Theme.rgba(Theme.primaryColor, 0) }
                        GradientStop { position: 1.0; color: Theme.rgba(Theme.secondaryColor, 0.5) }
                    }

                    Image {
                        id: selectedImageThumb
                        source: selectedFile ? "image://nemoThumbnail/" + selectedFile : "image://theme/icon-l-image"
                        width: parent.width
                        height: parent.height
                        fillMode: Image.PreserveAspectCrop
                        sourceSize.width: selectedImageThumb.width
                        sourceSize.height: selectedImageThumb.height
                        asynchronous: true

                        MouseArea{
                            anchors.fill: parent
                            onClicked: pageStack.push(filePickerPage)
                            enabled: !busy
                        }
                    }
                }

                Column{
                    height: commentText.contentHeight < column.width/3
                            ? column.width/3
                            : commentText.contentHeight
                    spacing: 0

                    TextArea{
                        id: commentText
                        enabled: !busy
                        width: column.width/3*2
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        clip: false
                        //focus: newPostItem.open
                        focus: false
                        wrapMode: TextEdit.Wrap
                        color: text ? Theme.primaryColor : 'red'
                        label: 'Comment ' + text.length + '/2000'
                        placeholderText: 'Comment'
                        text: comment
                    }
                }
            }

            Rectangle{
                id: optionalFields
                width: column.width
                height: optionalFieldsVisible
                        ? nameText.height + subjectText.height + Theme.paddingSmall
                        : 0
                color: "transparent"

                Column{

                    TextField{
                        id: subjectText
                        enabled: !busy
                        width: column.width
                        visible: optionalFieldsVisible
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.primaryColor
                        clip: true

                        focus: optionalFieldsVisible
                        label: 'Subject'
                        placeholderText: 'Subject'
                        text: subject
                    }

                    Row {

                        TextField{
                            id: nameText
                            enabled: !busy
                            width: column.width/3*2
                            visible: optionalFieldsVisible
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.primaryColor
                            clip: true
                            focus: false
                            placeholderText: "Anonymous"
                            label: 'Name'
                            text: nickname
                        }

                        TextField{
                            id: optionsText
                            enabled: !busy
                            width: column.width/3
                            visible: optionalFieldsVisible
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.primaryColor
                            clip: true
                            focus: false
                            label: 'Options'
                            placeholderText: 'Options'
                            text: options
                        }

                    }
                }
            }

            Rectangle{
                id: postActionButtons
                color: "transparent"
                width: column.width
                height: Theme.iconSizeMedium

                IconButton {
                    id: closePostButton
                    width: Theme.iconSizeMedium
                    height: width
                    enabled: !busy

                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        leftMargin: Theme.paddingSmall
                    }

                    icon.source: "image://theme/icon-m-tab-close"
                    onClicked: {
                        newPostItem.open = false
                        newPostItem.clear()

                    }
                }

                IconButton {
                    id: postButton
                    width: Theme.iconSizeMedium
                    height: width

                    enabled: !newPostItem.busy

                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                        rightMargin: Theme.paddingSmall
                    }

                    icon.source: "image://theme/icon-m-message"
                    onClicked: {

                        if(!newPostItem.replyTo){
                            console.log("new thread")

                            if(!newPostItem.comment && !newPostItem.selectedFile){

                                infoBanner.alert("Comment & Image required in new post");
                                return;
                            }
                        }
                        else{
                            console.log("new post")

                            if(!newPostItem.comment || !newPostItem.selectedFile){
                                infoBanner.alert("Comment or Image required in reply");
                                return;
                            }
                        }


                        newPostItem.replyTo
                            ? pageStack.push("../pages/Captcha2Page.qml",
                              {
                                  "replyTo" : newPostItem.replyTo
                              })
                            : pageStack.push("../pages/Captcha2Page.qml");

                        /*
                        if(!newPostItem.replyTo && !newPostItem.comment && !newPostItem.selectedFile){

                            infoBanner.alert("Comment & Image required in new post");
                            return;
                        }
                        else if(!newPostItem.comment){
                                infoBanner.alert("Comment required in reply");
                                return;
                        }
                        else{
                            newPostItem.replyTo
                                ? pageStack.push("../pages/Captcha2Page.qml",
                                  {
                                      "replyTo" : newPostItem.replyTo
                                  })
                                : pageStack.push("../pages/Captcha2Page.qml");
                        }*/
                    }
                }

                IconButton {
                    id: expandOptionalButton
                    enabled: !busy
                    width: Theme.iconSizeMedium
                    height: width

                    anchors {
                        bottom: parent.bottom
                        right: postButton.left
                        rightMargin: Theme.paddingSmall
                    }

                    icon.source: optionalFieldsVisible
                                 ? "image://theme/icon-m-up"
                                 : "image://theme/icon-m-down"
                    onClicked: {
                        optionalFieldsVisible
                                ? optionalFieldsVisible = false
                                : optionalFieldsVisible = true

                    }
                }

            }

        }
    }

Component {
    id: filePickerPage
    FilePickerPage {
        nameFilters: [ '*.jpg', '*.png', '*.webm','*.gif' ]
        onSelectedContentPropertiesChanged: {
            newPostItem.selectedFile = selectedContentProperties.filePath
            //newPostItem.selectedImageThumb.source = selectedContentProperties.filePath
            selectedImageThumb.source = "image://nemoThumbnail/" + selectedContentProperties.filePath
        }
    }
}

function clear(){
    subjectText.text = "";
    selectedFile = "";
    selectedImageThumb.source = "image://theme/icon-l-image";
    nameText.text = "";
    optionsText.text = "";
    commentText.text = "";

}

}