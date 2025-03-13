
import QtQuick 2.1
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5
import "../items"
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0

AbstractPage {
    id: imagePage
    allowedOrientations : Orientation.All
    property string imgUrl //: imageItem.source
    property string thumbUrl
    property string ext
    property string filename
    property string filename_original

    WebView {
         id: webView

         anchors {
             top: parent.top
             left: parent.left
             right: parent.right
             bottom: parent.bottom
         }
         url: pageurl



        Component.onCompleted: {

                var uri = imgUrl
            py.call('savefile.savefile', ['/tmp', 'tempfile', uri, filename] )

        }
    }


    Python {
        id: py

        Component.onCompleted: {
            // Add the Python library directory to the import path
            var pythonpath = Qt.resolvedUrl('../../py/').substr('file://'.length);

            addImportPath(pythonpath);
            console.log(Qt.resolvedUrl('../../py/'));
            console.log(pythonpath);
            importModule('savefile', function() {});


        setHandler(filename, function(result) {

            webView.url = '/tmp/tempfile'
            });
        }
    }

    function cd(dir) {
        py.call('savefile.getdirs', [dir], function(response) {
            page.dirs = response
        });
    }
}
