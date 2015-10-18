import QtQuick 2.0
import Sailfish.Silica 1.0
import "../items"
import io.thp.pyotherside 1.4
import "../js/utils.js" as Utils

AbstractPage {
    id: threadPage
    objectName: "threadPage"
    property string mode: "thread"
    property string boardTitle: ""
    property variant currentModel : model
    property bool threadItem:true
    property int pages
    property bool showPinnedPage: false


    title: boardId ? "<b>/"+boardId+"/</b>" : "Neliapila"

    function replacePage(){
        showPinnedPage = true
    }


    function change_board(boardId){
        if(helpTxt.enabled){
            helpTxt.enabled = false
        }

        listView.scrollToTop()
        pyt.getThreads(boardId,1)
    }

    function change_page(pageNo){
        listView.scrollToTop()
        pyt.getThreads(boardId,pageNo)
        infoBanner.alert("Page "+pageNo);
    }

    SilicaListView {
        id: listView
        model: currentModel
        anchors.fill: parent
        contentHeight: threadPage.height
        focus: true

        PullDownMenu {
            id: mainPullDownMenu

            busy : busy

            MenuItem {
                text: qsTr("Settings")
                onClicked: {

                    pageStack.push("SettingsPage.qml");
                }
            }

            MenuItem {
                id: showPinnedMenu
                text: qsTr("Pinned posts");
                visible: mode === "thread" ? true: false

                onClicked: {
                    showPinnedTimer.start()
                }
            }

            MenuItem {
                id: backToThreadMode
                //text: qsTr("/"+ boardId+"/")
                text: "Back to <b>/"+boardId+"/</b>"
                visible: mode === "pinned" ? true: false

                onClicked: {
                    showThreadTimer.start()
                }
            }

            MenuItem {
                id:menuRefresh
                text: qsTr("Refresh")
                enabled: false

                onClicked: {
                    pyt.getThreads(boardId,pageNo)
                    infoBanner.alert("Refreshing...")
                }
            }
            Label{
                text: boardTitle
                //wrapMode: Text.WordWrap
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryHighlightColor
                clip: true
                smooth: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        header: PageHeader {
            id: pageHeader
            title: threadPage.title //<b>/"+boardId+"/</b>"


            Rectangle{
                //This is for appIcon placement. Anyone got better solution?
                id: headerSeparator
                color:"red"
                width: parent.width*0.02
                height:parent.height
                anchors.left: parent.left
                anchors.top: parent.top
            }

            Image {
                id: appIcon
                anchors{
                    left: headerSeparator.right
                    verticalCenter: parent.verticalCenter
                }
                width: parent.height*0.6;
                height: width
                fillMode: Image.PreserveAspectFit
                smooth: true
                source: "../img/neliapila.png"
                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        pageStack.push("AboutPage.qml")

                    }
                }

            }
        }

        Button{
            id: moreInfoButton
            visible: false
            text: "More info"
            anchors.centerIn: parent
            anchors.verticalCenterOffset: parent.height*0.1
            property string fullError
            property string errorTitle
            onClicked: {
                pageStack.push(Qt.resolvedUrl("TextPage.qml"),
                               {
                                   "title" : errorTitle,
                                   "content": fullError
                               });
            }
        }

        ViewPlaceholder {
            id: helpTxt
            text: "No board selected"
            enabled: false
        }

        ListModel {
            id: model
        }

        ListModel {
            id: pinModel
        }

        delegate: PostItem{
            id: delegate

        }

        Component {
            id: contextMenuComponent

            ContextMenu {
                property string postReplies
                //property var postReplies : []
                property string com
                property var quote
                property var thisPostNo
                property var modelToStrip
                property bool pinned
                property int index
                property string boardId

                MenuItem {
                    visible: pinned ? true : false
                    text: qsTr("Remove pin")
                    onClicked:{
                        console.log("Remove pin" +thisPostNo)
                    }
                }

                MenuItem {
                    visible: pinned ? false : true
                    text: qsTr("Add pin")
                    onClicked:{
                        console.log("Add pin" +thisPostNo)
                        pyt.pin(thisPostNo,boardId,index)
                    }
                }

                MenuItem {
                    text: qsTr("Open thread in browser")
                    onClicked: {

                        var url = "https://boards.4chan.org/"+boardId+"/thread/"+postNo
                        infoBanner.alert("Opening thread in browser");
                        Qt.openUrlExternally(url)
                    }
                }

            }
        }

        add: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 500 }
            //NumberAnimation { property: "scale"; easing.type: Easing.InQuint; from: 0; to: 1.0; duration: 500 }

        }
        remove: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: 500 }
        }

        footer: ThreadPageFooter{
            id: pageNav
            visible : model.count<5 || mode === "pinned" ? false : true
        }
    }

    Component.onCompleted: {


        if(boardId){
            pyt.getThreads(boardId,1)
        }
        else{
            pyt.call('threads.get_default',[],function(result){
                if(typeof result === 'undefined'){
                    busy = false
                    helpTxt.enabled = true
                    //pageStack.navigateForward();
                }
                else{
                    boardId = result
                    pageNo = 1
                    pyt.getThreads(result,1)
                }

            });
        }
    }

    Timer {
        id: showThreadTimer
        interval: 500; running: false; repeat: false
        onTriggered: {
            helpTxt.enabled = false
            mode = "thread"
            title ="<b>/"+boardId+"/</b>"
            currentModel = model
        }
    }

    Timer {
        id: showPinnedTimer
        interval: 500; running: false; repeat: false
        onTriggered: pyt.getPinned()
    }

    onStatusChanged: {

        if (status === PageStatus.Active && pageStack.depth === 1 && mode === "thread") {
            pageStack.pushAttached(Qt.resolvedUrl("NaviPage.qml"),{boardId: boardId} );
            if(model.count != 0){
                pyt.call('pinned.data.thread_this', ['get_by_board',{'board':boardId}],function() {});
            }
        }
        else if (status === PageStatus.Active && pageStack.depth === 1 && mode === "pinned") {
            pageStack.pushAttached(Qt.resolvedUrl("NaviPage.qml"),{boardId: boardId} );
            pyt.getPinned()
        }
    }




    Python {
        id: pyt

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../py/').substr('file://'.length);
            //var pythonpath = Qt.resolvedUrl('.').substr('file://'.length);
            addImportPath(pythonpath);
            //console.log("Threads: "+pythonpath);

            setHandler('boards', function(result) {
                //To silence onReceived from boards
            });

            setHandler('posts', function(result) {
                //To silence onReceived from posts
            });

            setHandler('pinned_postno', function(result) {
                //To silence onReceived from pinned
            });

            setHandler('posts_status', function(result) {
                //To silence onReceived from pinned
            });

            setHandler('pinned_board', function(result) {

                for (var i=0; i<model.count; i++) {

                    var no = model.get(i)['no']

                    var updateItem
                    updateItem = model.get(i)

                    if(result.indexOf(no) >= 0) {
                        //console.log("THIS POST IS PINNED: " + no)
                        updateItem.pin = 1
                    }
                    else{
                        updateItem.pin = 0
                    }

                }

                //                for (var i=0; i<result.length; i++) {
                //                    //model.append(result[i]);
                //                    console.log(result[i]['postNo'])
                //                    model.get()

                //                }

                //To silence onReceived from pinned
            });

            setHandler('threads', function(result) {
                for (var i=0; i<result.length; i++) {
                    model.append(result[i]);
                }

                busy = false
                menuRefresh.enabled = true

                call('pinned.data.thread_this', ['get_by_board',{'board':boardId}],function() {});

                call('threads.get_pages', [boardId],function(pages) {
                    //console.log(threadPage.pages)
                    threadPage.pages = pages
                    //console.log(threadPage.pages)
                });

            });

            setHandler('pinned_all', function(result) {
                //To silence onReceived from posts
                console.log("Pinned all Handler!")

                for (var i=0; i<result.length; i++) {
                    pinModel.append(result[i]);
                }

                if(!result.length){
                    helpTxt.text = "No pinned posts"
                    helpTxt.enabled = true
                }

                busy = false
            });

            setHandler('pinned_all_update', function(result) {

                for (var i=0; i<pinModel.count; i++) {

                    var no = pinModel.get(i)['no']

                    var updateItem
                    updateItem = pinModel.get(i)

                    for (var i=0; i<result.length; i++) {
                        updateItem.postCount = result[i]['postCount']
                    }

                }

            });

            importModule('threads', function() {});
            importModule('pinned', function() {});
        }

        function getThreads(boardId,pageNo){
            busy = true

            if(model.count !== 0){
                model.clear()
            }
            if(currentModel === pinModel){
                pinModel.clear()
                currentModel = model

                console.log("Model changed to model")
            }

            threadPage.boardId = boardId
            threadPage.pageNo = pageNo

            call('threads.data.thread_this', ['get',{'board':boardId,'page':pageNo}],function() {});

        }

        function getPinned(){
            busy=true
            //model.clear()
            pinModel.clear()
            currentModel = pinModel
            helpTxt.enabled = false
            mode = "pinned"
            title = "Pinned posts"


            call('pinned.data.thread_this', ['get_all',{}],function() {});
        }

        function pin(postNo,boardId,index){

            var model = currentModel


            //var postNo = model.get(index)['no']
            //var boardId = model.get(index)['board']
            var com = model.get(index)['com']
            var thumbUrl = model.get(index)['thumbUrl']
            var time = model.get(index)['time']
            var replies = model.get(index)['replies_count']
            console.log(postNo,boardId,index,thumbUrl,time,replies)

            call('pinned.add_pin', [postNo,boardId,com,thumbUrl,time,replies],function() {
                //pinned = true
                //updateItem(pinned)
            });

        }

        function unpin(postNo,boardId){
            //console.log("UNPIN: "+postNo+" board:"+boardId)
            call('pinned.delete_pins', [postNo,boardId],function() {
                //pinned = false
                //updateItem(pinned)
            });

        }

        onError: {
            // when an exception is raised, this error handler will be called
            console.log('threads python error: ' + traceback);


            busy=false
            Utils.tracebackCatcher(traceback,helpTxt)


        }
        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log('threads got message from python: ' + data);
        }
    }

}
