dojo.require("dijit._Calendar");

jmaki.namespace("jmaki.widgets.dojo.dijit.calendar");

jmaki.widgets.dojo.dijit.calendar.Widget = function(wargs) {

    var _widget = this;
    _widget.container = document.getElementById(wargs.uuid);
    
    _widget.wrapper = new dijit._Calendar({}, _widget.container);
  
    var publish = "/dojo/dijit/calendar";	

    if (wargs.value) {
        var date = new Date(wargs.value);
	this.wrapper.setDate(date);
    }
    
    if ( wargs.publish) {
        publish = wargs.publish;
    }
     
    this.getValue = function() {
        return  _widget.wrapper.getValue().replace(/-/g, '/');
    }

   this.datepickerEvent = function(date) {
        jmaki.publish(publish, {id: wargs.uuid, wargs: wargs, value:date});
    }

    dojo.connect(_widget.wrapper, "onValueChanged", _widget, "datepickerEvent" );    

};
