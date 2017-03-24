using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class ExerciseplanMenuDelegate extends Ui.MenuInputDelegate {

	hidden var view;

    function initialize(view) {
        MenuInputDelegate.initialize();
        me.view = view;
    }
    
    function onMenuItem(item) {
    	var plan = "";
        if (item == :Plan1) {
        	plan = Ui.loadResource(Rez.Strings.exerciseplan);
        } else if (item == :Plan2) {
        	plan = Ui.loadResource(Rez.Strings.exerciseplanTestQuick);
        }
        if(plan != "") {
        	view.startWorkout(plan);
        }
    }
    
}