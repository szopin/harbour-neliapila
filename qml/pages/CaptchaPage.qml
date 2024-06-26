import QtQuick 2.2
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0

import "../items"
import io.thp.pyotherside 1.4


    Page {
        id: page
        property string imgdata: ""
        property string bgdata: ""
        property string nickname
        property string subject 
        property string selectedFile
        property string challenge
        property string replyTo
        property string boardId
        property string url: replyTo ? "https://sys.4chan.org/captcha?framed=0&board=" + boardId + "&thread_id=" + replyTo : "https://sys.4chan.org/captcha?board=" + boardId
        property string comment
        property string response
        property int img_width
        property int bg_width
        property int img_height
        property bool loaded: false
        
        /*WebView {
        anchors.fill: parent
        url: url
        httpUserAgent: 'Mozilla/5.0 (Linux; Plasma Mobile, like Android 9.0) AppleWebKit/537.36 (KHTML, like Gecko) QtWebEngine/5.15.13 Chrome/87.0.4280.144 Mobile Safari/537.36'
        */
        function getCaptcha(){
            var xhr = new XMLHttpRequest;
        xhr.open("GET",  "https://testwebsite1277.000webhostapp.com/headers.php");// url);
        xhr.setRequestHeader('test', 'test');
        xhr.setRequestHeader('learance', 'cxSThcay8rPYbw0tdgRTkaXvvcOH653C7fytK9Zxqgg-1685614967-0-150');
        xhr.setRequestHeader('-User-Agent', 'Mozilla/5.0 (Linux; Plasma Mobile, like Android 9.0) AppleWebKit/537.36 (KHTML, like Gecko) QtWebEngine/5.15.13 Chrome/87.0.4280.144 Mobile Safari/537.36');
        xhr.setRequestHeader("_gid", "GA1.3.1826924971.1685614962");
        xhr.setRequestHeader("_ga", "GA1.3.1745808135.1685614962");
            
        
        
      //  xhr.setRequestHeader("user-agent", "
        //R7iRrlsGgw6I5m9zpzhXv2TbCDJ9.GQ7X308w7aHKDE-1681472776-0-150"); 
            xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                    //  console.log(xhr.getAllResponseHeaders());
                       console.log(xhr.responseText);          
                var data = JSON.parse(xhr.responseText);
                console.log(url);

                loaded = true;
                challenge = data.challenge;
                imgdata  = data.img;
                img_width = data.img_width;
                img_height = data.img_height;
                bgdata = data.bg;
                bg_width = data.bg_width;
             
            }
                                
        }
            xhr.send();

        }

    Flickable {
        id: flick
        anchors.fill: parent
        
        PageHeader {
                id: header
                title: "Captcha"
                }
                

            Image {
                id: imgfg
                anchors.top: header.bottom
                width: page.bg_width *2 
                height: page.img_height *2
                x: 100 - bgslider.value    
                source: !page.loaded ? page.imgdata : "data:image/png;base64," + page.bgdata  
            }
            Image {
                id: imgbg
                anchors.top: header.bottom
                width: page.img_width *2 
                height: page.img_height *2
                source: !page.loaded ? page.bgdata : "data:image/png;base64," + page.imgdata  
            }
            Rectangle {
                anchors.left: imgbg.right
                anchors.top: header.bottom
                height: page.img_height *2
                width: screen.width - page.img_width *2 
                color: Theme.rgba(Theme.primaryColor, 1)
            }
        
            Slider {
                id: bgslider
                anchors.top: imgbg.bottom
                minimumValue: 0
                maximumValue: 200
                stepSize: 2
                enabled: true
                width: parent.width
                handleVisible: true
                label: qsTr("Slide to reveal captcha")
            }
            
            TextField {
                id: captchaInput
                width: parent.width
                anchors.top: bgslider.bottom
                placeholderText: "Enter CAPTCHA"                          
                EnterKey.enabled: text.length > 2
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.onClicked: {
                   replyTo ? py.postpost(text) : py.postthread(text);
                        pageStack.navigateBack();
                    }

            }
    Component.onCompleted: {
            page.getCaptcha();
        
    }
}
                Python {
        id: py

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../../py/').substr('file://'.length);
            addImportPath(pythonpath);
            importModule('posting', function() {});
                }
            function postpost(response) {
            console.log("Replying to "+replyTo)
            console.log("posting with captchatoken "+challenge)
            console.log("posting with filepath "+selectedFile)
            console.log("posting with subject "+subject)
            console.log("posting with comment "+comment)
            console.log("posting to board "+boardId)
                    console.log(response)

            call('posting.post', [
                     nickname,
                     comment,
                     subject,
                     selectedFile,
                     response,
                     boardId,
                     challenge,
                     replyTo
                 ], function() {});
                    }
                
           function postthread(response) {
            console.log("posting with captchatoken "+challenge)
            console.log("posting with filepath "+selectedFile)
            console.log("posting with subject "+subject)
            console.log("posting with comment "+comment)
            console.log("posting to board "+boardId)
                    console.log(response)

            call('posting.post', [
                     nickname,
                     comment,
                     subject,
                     selectedFile,
                     response,
                     boardId,
                     challenge                     
                 ], function() {});
                }
}
}
