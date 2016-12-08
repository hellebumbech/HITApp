using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

class HitAppForerunnerApp extends App.AppBase {

	hidden var view;

    function initialize() {
        AppBase.initialize();
        view = new HitAppForerunnerView();
    }

    // onStart() is called on application start up
    function onStart(state) {
    	
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [view, new HitAppForerunnerDelegate(view)];
    }

}
