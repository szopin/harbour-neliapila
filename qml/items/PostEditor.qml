import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import io.thp.pyotherside 1.4
import Nemo.Thumbnailer 1.0

BackgroundItem {

    Item {
        anchors.fill: parent

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: parent.height

            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightDimmerColor, 1) }
                GradientStop { position: 0.5; color: Theme.rgba(Theme.highlightDimmerColor, 0.5) }
                GradientStop { position: 1.0; color: Theme.rgba(Theme.highlightDimmerColor, 0.1) }
            }
        }
    }


    id: newPostItem
    anchors.fill: parent

    property string boardId: boardId
    property int replyTo: 0
    property string selectedFile

    property string nickname: nameText.text
    property string options: ""
    property string subject: subjectText.text
    property string comment: commentText.text
    //property string file_path: selectedFile ? selectedFile : ""
    property variant captcha_token

    SilicaFlickable {
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        PullDownMenu {
            id: newPostPullDownMenu

            busy : busy

            MenuItem {
                text: qsTr("Post")
                //enabled: boardId ? true: false
                //enabled: comment.lenght ? true : false



                onClicked: {
                    pageStack.push("../pages/Captcha2Page.qml");
                    //py.post()
                }
            }

        }



        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: parent.width
            height: parent.contentHeight
            spacing: Theme.paddingSmall

            anchors{
                left:parent.left
                right:parent.right
                leftMargin: pageMargin
                rightMargin: pageMargin
            }

            PageHeader {
                title: "New Post"
            }

            Row{
                spacing: 0
                //spacing: Theme.paddingSmall

                Rectangle{
                    //spacing: Theme.paddingSmall
                    width: column.width/3
                    height: width
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Theme.rgba(Theme.primaryColor, 0) }
                        GradientStop { position: 1.0; color: Theme.rgba(Theme.primaryColor, 0.2) }
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
                        }

                    }
                }

                Column{
                    height: commentText.contentHeight < column.width/3 ? column.width/3 : commentText.contentHeight

                    //Column{

                        TextField{
                            id: subjectText
                            width: column.width/3*2
                            //wrapMode: Text.WordWrap
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.primaryColor
                            //text: content
                            //x: Theme.paddingSmall
                            clip: true
                            focus: false
                            label: 'Subject'
                            placeholderText: 'Subject'
                            text: subject
                        }
                    //}

                    TextArea{
                        id: commentText
                        width: column.width/3*2
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        //x: Theme.paddingSmall
                        clip: false
                        focus: false
                        wrapMode: TextEdit.Wrap
                        color: text ? Theme.primaryColor : 'red'
                        label: 'Comment'
                        placeholderText: 'Comment'
                        text: comment
                    }
                }
            }

            Rectangle{

                    //spacing: Theme.paddingSmall
                    width: column.width
                    height: nameText.height + optionsText.height
                    color: "transparent"
/*
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightDimmerColor, 0) }
                        GradientStop { position: 1.0; color: Theme.rgba(Theme.highlightDimmerColor, 0.6) }
                    }
*/

                    Row {

                        TextField{
                            id: nameText
                            width: column.width/3*2
                            //wrapMode: Text.WordWrap
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.primaryColor
                            //text: content
                            //x: Theme.paddingSmall
                            clip: true
                            focus: false
                            placeholderText: "Anonymous"
                            label: 'Name'
                            text: nickname
                        }

                        TextField{
                            id: optionsText
                            width: column.width/3
                            //wrapMode: Text.WordWrap
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.primaryColor
                            //text: content
                            //x: Theme.paddingSmall
                            clip: true
                            focus: false
                            label: 'Options'
                            placeholderText: 'Options'
                            text: options
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

/*
Python {
    id: py

    Component.onCompleted: {
        // Add the Python library directory to the import path
        var pythonpath = Qt.resolvedUrl('../../py/').substr('file://'.length);
        //var pythonpath = Qt.resolvedUrl('.').substr('file://'.length);
        addImportPath(pythonpath);
        console.log(pythonpath);
        importModule('posting', function() {});

         setHandler('post_successfull', function(result) {
             console.log("SUCCESS : "+result);
             infoBanner.alert("SUCCESS")

         });

        setHandler('post_failed', function(result) {
            console.log("FAILED : "+result);
            infoBanner.alert("Failed to send")

        });

        setHandler('set_response', function(result) {
            if(result.length === 1){
                console.log("set_response fired"+result);
                newPostItem.captcha_token = result[0]
                verificationButton.enabled = false
                verificationButton.color = "green"
                infoBanner.alert("Verified")


            }
            else {
                infoBanner.alert("Something went wrong, try reverify")
            }

        });

    }



    function post(){
        if(!comment.length){infoBanner.alert("Cannot post without comment");return}
        console.log("posting with captchatoken "+captcha_token)
        console.log("posting with filepath "+selectedFile)
        console.log("posting with subject "+subject)

        call('posting.post', [
                 nickname,
                 comment,
                 subject,
                 selectedFile,
                 captcha_token
             ], function() {});
        //(nickname="", comment="", subject="", file_attach="", captcha_response="")

    }

    onError: {
        // when an exception is raised, this error handler will be called
        console.log('python error: ' + traceback);
    }
    onReceived: {
        // asychronous messages from Python arrive here
        // in Python, this can be accomplished via pyotherside.send()
        console.log('got message from python: ' + data);
    }
}*/

}
