jmaki.FlickrProxySearch = function(service, topic){

    var target;
    
    if (typeof  topic == 'undfined') {
        topic = "flickrSearch";
    }
	
    this.searchPhotos = function(tags) {
        // build and encode the last URL parameter tags=_target.value
        target = encodeURIComponent("tags=" + tags);
        var url = jmaki.xhp + "?key=flickrtagsearch&urlparams=" + target;
        jmaki.doAjax({url: url, callback: function(req) { var _req=req; postProcess(_req);}});
    }
	
    function postProcess(req) {
        if (req.readyState == 4) {
            if (req.status == 200) {          	
                if (req.responseText != '') {
                    var response = eval("(" + req.responseText + ")");
		    jmaki.publish(topic, response.photos);
                } else {
	                jmaki.publish(topic, []);
	            }
            }
        }
    }
}
/**
*  Insert a script tag in the head of the document which will inter load the flicker photos
*  and call jsonFlickrFeed(obj) with the corresponding object.
*
*/
jmaki.FlickrLoader = function(apiKey) {
    
    this.load = function(tags, callback) {
        if (typeof _globalScope.flickrListeners == 'undefined') {
            _globalScope.flickrListeners = {};
        }
        var listeners = _globalScope.flickrListeners[tags];
        if (typeof listeners == 'undefined') {
            listeners = [];
        }
        listeners.push(callback);
        _globalScope.flickrListeners[tags] = listeners;      
        
        _globalScope.jsonFlickrFeed = function(args) {

            var title = args.title;
            var tagsEnd = title.indexOf("tagged ");
            var tagNames = title.substring(tagsEnd + "tagged ".length, title.length);
            tagNames = tagNames.replace(/ and /, ',');
            var tListeners = _globalScope.flickrListeners[tagNames];
            if (tListeners != null) {
                for (var i = 0; i < tListeners.length; i++) {
                    tListeners[i](args,tagNames);
                }
                // release the listeners for this tag
                delete _globalScope.flickrListeners[tagNames];
            }
        }
        var s = document.createElement("script");
        var url ="http://www.flickr.com/services/feeds/photos_public.gne?tags=" + tags + "&format=json";
        if (typeof apiKey != 'undefined') {
            url += "&appid=" + apiKey;
        }
        s.src = url;
        s.type = "text/javascript";
        s.charset = "utf-8";
        document.body.appendChild(s);      
    }
}
