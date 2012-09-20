/* Copyright 2007 You may not modify, use, reproduce, or distribute this software except in compliance with the terms of the License at:
 http://developer.sun.com/berkeley_license.html
 $Id: component.js,v 1.0 2007/04/15 19:39:59 gmurray71 Exp $

For detailed usage documentation see:

http://github.com/madrobby/scriptaculous/wikis/ajax-autocompleter

*/

jmaki.namespace("jmaki.widgets.scriptaculous.autocompleter");

jmaki.widgets.scriptaculous.autocompleter.Widget = function(wargs) {
    
    var service = wargs.service;
    
    // parameter used when making queries to
    var _paramName = "query";
    
    if (wargs.args) {
        if (wargs.args.paramName) {
            _paramName = wargs.args.paramName;
        }
    }
    
    if (!wargs.service){
        jmaki.log("You did need to provide a service for the completer to use. Defaulting to an _autocomplete.html file in the widget directory."); 
        service = wargs.widgetDir + "/_autocomplete.html";
    }
    this.wrapper = new Ajax.Autocompleter(wargs.uuid, wargs.uuid + '_target',
				  service, {method:'get', select:'selectme', paramName : _paramName}
				  );
}