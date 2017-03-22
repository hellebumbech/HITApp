using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class HitAppForerunnerDelegate extends Ui.BehaviorDelegate {

    hidden var view;
	hidden var workoutStarted;
	
    function initialize(view) {
        BehaviorDelegate.initialize();
        me.view = view;
        me.workoutStarted = false;
    }
    
    // start/stop the application
    function onKey(evt) {
    	if(evt.getKey() == 4) {
	    	if(workoutStarted) {
	    		if(!view.countdownStopped) {
		    		view.stopTimers();
		    	}
		    	else {
		    		view.startTimers();
		    		Ui.requestUpdate();
		    	}
	    	}
	    	else {
	    		view.startWorkout();
	    		workoutStarted = true;
	    		}
	    	}
	    	
	    else if(evt.getKey() == 5) {
	    	// exit application
	    	Ui.popView(Ui.SLIDE_IMMEDIATE);
	    }
    	return true;
    }
}