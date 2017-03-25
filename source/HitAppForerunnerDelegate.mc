using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class HitAppForerunnerDelegate extends Ui.BehaviorDelegate {

    hidden var view;
	
    function initialize(view) {
        BehaviorDelegate.initialize();
        me.view = view;
    }
    
    // start/stop the application
    function onKey(evt) {
    	if(evt.getKey() == 4) {
    		handleStartStopEvent();
	    }
	    else if(evt.getKey() == 5) {
	    	handleBackEvent();	
	    }
    	return true;
    }
    
    function handleStartStopEvent() {
    	if(view.workoutStarted && !view.workoutFinished) {
    		handleStartStopOngoingActivity();
    	}
    	else if(view.workoutFinished) {
    		showExitMenu();
    	}
    	else {
    		beginWorkout();
    	}
    }
    
    function handleStartStopOngoingActivity() {
    	if(!view.countdownStopped) {
    		view.stopTimers();
    	}
    	else {
    		view.startTimers();
    		Ui.requestUpdate();
    	}
    }
    
    function showExitMenu() {
    	pushView(new Rez.Menus.ExitMenu(), new HitAppForerunnerMenuDelegate(view), Ui.SLIDE_UP);
    }
    
    function beginWorkout() {
    	Ui.pushView(new Rez.Menus.WorkoutMenu(), new ExerciseplanMenuDelegate(view), Ui.SLIDE_UP);
    }
    
    function handleBackEvent() {
    	view.stopTimers();
    	showExitMenu();	    
    }
}