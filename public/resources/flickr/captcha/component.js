/* Copyright 2007 You may not modify, use, reproduce, or distribute this software except in compliance with the terms of the License at:
 http://developer.sun.com/berkeley_license.html
 $Id: component.js,v 1.0 2007/04/15 19:39:59 gmurray71 Exp $
*/
// define the namespaces
if (!jmaki.widgets.flickr) {
	jmaki.widgets.flickr = {};
}
jmaki.widgets.flickr.captcha = {};

/**
 * @constructor
 */
jmaki.widgets.flickr.captcha.Widget = function(wargs) {

	// default captcha
	var characters = ['j','m','a','k','i'];
	var fl;
	var repeatCharacters = false;
	var pxSize = 25;	
    var items = {};
    var usedChars = {};
    var renderred = false;
    var topic = "/flickr/captcha";
        
	
	if (typeof wargs.args != "undefined") {
	    var chars = "abcdefghiklmnopqrstuvwxyz";
	    var length = 5;
	    if (typeof wargs.args.length != "undefined") {
	        length = Number(wargs.args.length);
	    }
	    if (typeof wargs.args.repeatCharacters != "undefined") {
	        repeatCharacters = (wargs.args.repeatCharacters.toLowerCase() == 'true');
	    }
	    if (typeof wargs.args.size != "undefined") {
	        pxSize = wargs.args.size;
	    }
	    characters = [];
	    for (var ch=0; ch < length; ch++) {
	        var l= Math.floor(Math.random()*(chars.length));
	        characters.push(chars.charAt(l));
	    }
	    if (typeof wargs.args.tags != "undefined") {
	        fl = new jmaki.FlickrLoader(wargs.args.apikey);
	    } else {
	        fl = new jmaki.FlickrLoader();
	    }
	    if (typeof wargs.args.topic == "undefined"){
		topic = wargs.args.topic;
	    }
	}

    this.getTargetWord = function() {
        return items.targetCharacters.join();
    }
    
    this.matches = function(target) {
	var match = false;
	if (target ==  items.targetCharacters.join('') ) {
	   match = true;
	}
	jmaki.publish(topic, match);
        return (match );
    }

   function fCallback (obj, t) {

        var letter = t.split(',')[1].charAt(0);
        // get info from the JSON object
        items[letter] = [];
        // get the letter count which will be more than one if
        // repeact characters was set
        var count = Number(usedChars[letter]);
        for (var lo = 0; lo < count; lo++) {
            // randomly choose one of the letters
            var l= Math.floor(Math.random()*(obj.items.length));
            var description = obj.items[l].description;     
            var start = description.indexOf("src=") + 10;
            var stop =  description.indexOf("_m.jpg");
            var imageBase = description.substring(start,stop);
            var thumbURL = imageBase + "_s.jpg";
            var name = obj.items[l].title;
            var i = {name: name, url: thumbURL};
            items[letter].push(i);
        }
        // check to see all the images are loaded
        if (checkIfDone() && !renderred) {
            renderred = true;
            showImages(items);
        }
    }
    
    // check to see if all the target characters have been loaded.
    function checkIfDone() {        
        for (var l = 0; l < items.targetCharacters.length; l++) {
            if (typeof items[items.targetCharacters[l]] == 'undefined') {
                return false;
            }
        }
        return true;
    }
    
    this.init = function(target, size, repeat) {
        items = {};
        usedChars = {};
        if (typeof repeat != 'undefined') {
            repeatCharacters = repeat;
        }
        if (typeof size != 'undefined') {
            pxSize = size;
        }
        renderred = false;
        items.targetCharacters =  target;
        for (var i = 0; i < target.length; i++) {
            if (typeof usedChars[target[i]] == 'undefined') {
                usedChars[target[i]] = 1;
                fl.load("oneletter," + target[i] + target[i], fCallback);
            } else {
                var prev = Number(usedChars[target[i]]);
                // increment the counter so we can load multiple images
                // for each character
                usedChars[target[i]] = ++prev; 
            }
        }
        
    }

    function showImages(items, repeat) {

        var targetDiv = document.getElementById(wargs.uuid);
        targetDiv.style.height = "auto";
        targetDiv.innerHTML = "";
        for (var i =0;  i < items.targetCharacters.length; i++) {
            var node = document.createElement("img");
            node.style.height = pxSize + "px";
            node.style.width = pxSize + "px";
            if (typeof items[items.targetCharacters[i]] != 'undefined') {
                // take the next available letter off the top if repeatCharacters is on
                // otherwise default to the first one (as there is only one)
                var t;
                if (repeatCharacters == false) {
                    if (typeof items[items.targetCharacters[i]] != 'undefined') {
                        t = items[items.targetCharacters[i]].pop();
                        node.src = t.url;
                        targetDiv.appendChild(node);
                    }
                } else {
                  t = items[items.targetCharacters[i]][0];
                  node.src = t.url;
                  targetDiv.appendChild(node);  
                }        
            }
        }
    }
    this.init(characters,pxSize,repeatCharacters);
}
