using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class HitAppForerunnerMenuDelegate extends Ui.MenuInputDelegate {

    hidden var view;

    function initialize(view) {
        MenuInputDelegate.initialize();
        me.view = view;
    }

    function onMenuItem(item) {
    	Sys.println("item er: " + item);
        if (item == :SaveActivity) {
            Sys.println("Save activity");
            view.stopRecording(true);
           	pushView(new Rez.Menus.SavedMenu(), new HitAppForerunnerMenuDelegate(view), Ui.SLIDE_UP);
            
        } else if (item == :ExitApp) {
            Sys.println("Exit app");
	    	Ui.popView(Ui.SLIDE_IMMEDIATE);
	    	Ui.popView(Ui.SLIDE_IMMEDIATE);
        }
    }
}