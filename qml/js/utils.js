function makeurls(content) {
   // console.log(content)
     //   var pattern1 = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
    var pattern1 = /((((https?|ftp|file):\/\/)|\b)(([-A-Z0-9]+\.)+(xn--[A-Z0-9-]{4,}|[A-Z]{2,})(?:(?=[\/\s\b\<]|$)(?!%))((?=[\/])[-A-Z0-9+&@#\/%\'?=~_|!:,.;一-龠ぁ-ゔァ-ヴー々〆〤ヶа-яё\(\)\[\]]*[-A-Z0-9+&;@\'#\/%=~_一-龠ぁ-ゔァ-ヴー々〆〤ヶа-яё\(\)\[\]|])?))(?![^<>]*>|[^"]*?<\/a)/ig;

    // /(((https?|ftp|file):\/\/)?([-A-Z0-9]+\.)+(xn--[A-Z0-9-]{4,}|[A-Z]{2,})(((\/[-A-Z0-9+&@#\/%\'?=~_|!:,.;一-龠ぁ-ゔァ-ヴー々〆〤ヶа-яё\(\)\[\]]*)[-A-Z0-9+&;@\'#\/%=~_一-龠ぁ-ゔァ-ヴー々〆〤ヶа-яё\(\)\[\]|]?)?|\/))(?![^<>]*>|[^"]*?<\/a)/ig;


    // /(\b((https?|ftp|file):\/\/)?([-A-Z0-9]+\.)+(xn--[A-Z0-9-]{2,}|[A-Z]{2,})((\/[-A-Z0-9+&@#\/%\'?=~_|!:,.;一-龠ぁ-ゔァ-ヴー々〆〤ヶа-яё\(\)\[\]]*)[-A-Z0-9+&;@\'#\/%=~_一-龠ぁ-ゔァ-ヴー々〆〤ヶа-яё\(\)\[\]|])?)(?![^<>]*>|[^"]*?<\/a)/ig;

        content = content.replace(pattern1, function(x) {
        return "<a href=\"" + x.replace(/\'/g, "%27") + "\">" + x + "</a>"
        //encodeURI(x) + "\">" + x + "</a>"
        // x.replace(/\'/g, "%27") + "\">" + x + "</a>"
    });

    // "<a href=\"$1\" >$1</a> ");
    //content = content.replace(/<a href=\"(.*)\>/
   // console.log(content)
        return content
}
//function makeurls(content) {
    //var pattern1 = /(\b((https?|ftp|file):\/\/)?[-A-Z0-9]*\.[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
    //    var pattern1 = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])(?![^<>]*>|[^"]*?<\/a)/ig;
//		content = content.replace(pattern1, "<a href='$1'>$1</a>");
//		return content
  //  }       (?=.*[A-Z])
var pattern1 = /(\b((https?|ftp|file):\/\/)?[-A-Z0-9\.]*\.([A-Z]{2,})([-A-Z0-9+&@#\/'%?=~_|!:,.;]*[-A-Z0-9+&'@#\/%=~_|])?)(?![^<>]*>|[^"]*?<\/a)/ig;

//Regex to match
// any kind of url
var wwwAddress = new RegExp(/\b((?:[a-z][\w\-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]|\((?:[^\s()<>]|(?:\([^\s()<>]+\)))*\))+(?:\((?:[^\s()<>]|(?:\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:".,<>?«»“”‘’]))/gi);
//tagged url "<a href='url'>somethingsomethng</a>
var htmlTag = new RegExp(/<a[^>]* href="([^"]*)"\>.*?\<\/a\>/g);
//This one collects also 'url.org' but breaks if url has odd characters
//var wwwAddress2 = new RegExp(/[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,6}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi);

function tracebackCatcher(traceback,holder){
    //This determines whats in the butt
    var catchHttpError = new RegExp(/urllib.error.HTTPError: HTTP Error (.*)/)
    //requests.exceptions.ConnectionError: ('Connection aborted.', gaierror(-2, 'Name or service not known'))
    var catchRequestsConnectionError = new RegExp((/requests.exceptions.ConnectionError: \(\'(.*)\'\,/))



    if(traceback.match(catchHttpError)){
        var errTxt = traceback.match(catchHttpError)[1]
        console.log(errTxt)

        holder.text= errTxt
        holder.enabled = true
    }
    else if(traceback.match(catchRequestsConnectionError)){
        var errTxt = traceback.match(catchRequestsConnectionError)[1]
        console.log(errTxt)

        holder.text= errTxt
        holder.enabled = true
    }
    else if(typeof traceback === "undefined"){
        holder.text= "Something broke"
        moreInfoButton.visible = false
        holder.enabled = true
    }
    else{
        holder.text= "I crashed little bit :("
        moreInfoButton.visible = true
        moreInfoButton.errorTitle = "Python error"
        moreInfoButton.fullError = traceback
        holder.enabled = true
    }
}

//function parseLinks(com){

//    com = com.replace(/\&\#039\;|\<wbr\>/gi,

//                      function replaceWith(x){

//                          switch (x)
//                          {
//                          case "&#039;":

//                              return "'"
//                          case "<wbr>":

//                              return ""
//                          //case "&quot;":
//                          //    return '"'
//                          }
//                      });

//    com = com.replace(/\<a[^>]* href="([^"]*)"\>.*?\<\/a\>|\b((?:[a-z][\w\-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]|\((?:[^\s()<>]|(?:\([^\s()<>]+\)))*\))+(?:\((?:[^\s()<>]|(?:\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:".,<>?«»“”‘’]))/g,
//                      function replaceWith(x){

//                          if(x.match(htmlTag)){
//                              return x
//                          }
//                          else if(!x.match(htmlTag) && x.match(wwwAddress)){
//                              var uri = x.match(wwwAddress)[0]
//                              var wwwPattern = "<a href='"+uri+"'>"+uri+"</a>";
//                              var wwwText = x.replace(wwwAddress,wwwPattern);
//                              return wwwText
//                          }
//                          else{
//                              infoBanner.alert("URL parsing failed, text might miss urls.");
//                              console.log("Did not catch anything..")
//                          }
//                      }
//                      );
//    return com
//}

function openLink(link) {
    console.log(link)
    link = link.replace(/&amp;/gm, '&');
    var wwwAddress = new RegExp(/[-a-zA-Z0-9@:'%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%'_\+.~#?&//=]*)?/gi)
    var httplink = new RegExp(/^http/)
    //Internal link to another thread, also get board
    var intlink = new RegExp(/^\/[a-z]+\/thread\/[0-9]+\#p[0-9]+/)
    var bintlink = new RegExp(/^\/\/boards\.4chan\.org\/[a-z]+\/thread\/[0-9]+\#p[0-9]+/)
    var restolink = new RegExp(/^#p[0-9]+/)

    if (link.match(pattern1) && !link.match(bintlink)){
        //If external link is matched, add http:// if its not there already because otherwise Sailfish doesnt understand to open URL with browser
        if(!link.match(httplink)){
            link = "http://"+link
        }

        infoBanner.alert("Opening link in browser");
        console.log(link)
        Qt.openUrlExternally(link)
    }
    else if (link.match(intlink) || link.match(bintlink) ){
console.log('intlink')
        link = link.replace(/\/\/boards\.4chan\.org\//gm, '\/');
        var brd = link.match(/([a-z]+)/)[0]
        var trd = link.match(/([0-9]+)/)[0]
        var pid = link.match(/#p([0-9]+)/)[1]
        console.log(brd, trd, pid)
cleanup = true
        if(pid == trd){
        pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {postNo: trd, boardId: brd, tdepth: "1"} );
        } else {
             if (pid !== trd) pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {postNo: trd, boardId: brd, delaystrip: pid} );
        }
    }
    else if (link.match(restolink)){
        var singlePostNo = link = link.replace('#p','');
        var postsToShow = "["+singlePostNo+"]"
        var model

        if(typeof modelToStrip !== 'undefined'){
            console.log('restoundef')
            model = modelToStrip
        }
        else{
            console.log('restomodel')
            model = postsModel
        }

        pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {
                           postNo: postNo,
                           boardId: boardId,
                           threadId: threadId,
                           modelToStrip: model,
                           postsToShow:postsToShow,
                           singlePostNo: singlePostNo
                       } )

        //        if(typeof modelToStrip !== 'undefined'){
        //            pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {
        //                               postNo: postNo,
        //                               boardId: boardId,
        //                               modelToStrip: modelToStrip,
        //                               postsToShow:postsToShow,
        //                               singlePostNo: singlePostNo
        //                           } )
        //        }
        //        else{
        //            pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {
        //                               postNo: postNo,
        //                               boardId: boardId,
        //                               modelToStrip: postsModel,
        //                               postsToShow:postsToShow,
        //                               singlePostNo: singlePostNo
        //                           } )
        //        }
    }

    else{
        console.log("Did not match: "+link)}
}
