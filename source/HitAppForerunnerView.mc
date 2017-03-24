using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Attention as Attn;
using Toybox.Timer as Timer;
using Toybox.Time.Gregorian as Cal;
using Workout;
using Toybox.ActivityRecording as Record;

var session = null;

class HitAppForerunnerView extends Ui.View {

    var workout; // object holding the rounds and their exercises
	
	// timers
	var countdown; // countdown timer - counting down the exercise time
	var catTimer; // timer to animate cat
	
	var countdownStopped = false;
	var workoutStarted = false;
	var workoutFinished = false;
	
	// changeable values
	var i; // to hold roundnumber
	var j; // to hold exercisenumber
	var catXpos; // to hold X-position of catgif
	var catYpos; // to hold Y-position of catgif
	var catCount; // to hold number of running catgif
	var catPauseCount; // to hold number of pausing catgif
	
	//GIFS
	var catgif1;
	var catgif2;
	var catgif3;
	var catgif4;
	var catgifpause1;
	var catgifpause2;
	var catgifpause3;
	var donegif;

    function initialize() {
	    
        View.initialize();
        
        countdown = new Timer.Timer();
        catTimer = new Timer.Timer();
        
        i = 0;
        j = 0;
        
        // Variables used for catgifs
        catXpos = 220;
        catYpos = 35;
        catCount = 1;
        catPauseCount = 1;
        
       	// Catgifs
       	catgif1 = Ui.loadResource(Rez.Drawables.MotivatorCat_1);
        catgif2 = Ui.loadResource(Rez.Drawables.MotivatorCat_2);
        catgif3 = Ui.loadResource(Rez.Drawables.MotivatorCat_3);
        catgif4 = Ui.loadResource(Rez.Drawables.MotivatorCat_4);
        catgifpause1 = Ui.loadResource(Rez.Drawables.MotivatorCatPause_1);
        catgifpause2 = Ui.loadResource(Rez.Drawables.MotivatorCatPause_2);
        catgifpause3 = Ui.loadResource(Rez.Drawables.MotivatorCatPause_3);
        
        // gif for last view
        donegif = Ui.loadResource(Rez.Drawables.Star);
        
        //var plan1 = Ui.loadResource(Rez.Strings.exerciseplan);
       // var plan2 = Ui.loadResource(Rez.Strings.exerciseplanTestQuick);
        //workout = Workout.initialize(plan1);
        workout = [];
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        var bitmapInfo = getBitmapInfo();
        if(bitmapInfo) {
        	dc.drawBitmap(bitmapInfo[0], bitmapInfo[1], bitmapInfo[2]);
        }
    }
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
    
    function startWorkout(plan) {
    	workout = Workout.initialize(plan);
    	View.findDrawableById("initial").setText("");
    	setRoundFacts();
    	startTimers();
    	Attn.playTone(1); // start tone
    	startRecording();
    	workoutStarted = true;
    	requestUpdate();
    }
    
    function startTimers() {
    	countdown.start(method(:updateCountdown), 1000, true);
    	catTimer.start(method(:updateCatgif), 100, true);
    	countdownStopped = false;
    }
    
    function stopTimers() {
    	if(!countdownStopped) {
	    	countdown.stop();
	    	catTimer.stop();
	    }
	    countdownStopped = true;
	}
    
    function updateCountdown() {
	    if(workout[i].exercises[j].timeRemaining == 0) { // current exercise is done - start the next
	        updateExercise();
	        Attn.vibrate([new Attn.VibeProfile(100, 200)]);
	    }
    	if(j == workout[i].exercises.size()) { // last exercise in round has ended - start new round
    		updateRound();
    		setNewLapOnSession();
    		Attn.vibrate([new Attn.VibeProfile(100, 200)]);
    	}
    	if(i == workout.size()) { // last round has ended - finish
	        stopTimers();
	        finish();
	    }
	    else if(workout[i].exercises[j].timeRemaining > 0) { // current exercise is still ongoing - just update countdown
	    	workout[i].exercises[j].timeRemaining = workout[i].exercises[j].timeRemaining - 1;
	    	var timeRemainingText = getTimeRemainingFormatted(workout[i].exercises[j].timeRemaining.toNumber());
	    	View.findDrawableById("ExerciseTime").setText(timeRemainingText);
	    }
	    requestUpdate();
    }
    
    function updateCatgif() {
    	catCount++;
    	catXpos = catXpos - 10;
    	if(catCount == 5) {
    		catCount = 1;
    	}
    	if(catPauseCount == 5) {
    		catPauseCount = 1;
    	}
    	if(catXpos < -60) {
    		catXpos = 220;
    	}
    	if(catCount % 2) {
    		catPauseCount++;
    	}
    	requestUpdate();
    }
    
    function finish() {
	    clearView();
	    freeMemory();
	    Attn.playTone(2); // stop tone
	    stopRecording();
	    View.findDrawableById("WorkoutDone").setText(Rez.Strings.done);
	    workoutFinished = true;
	    Ui.requestUpdate();
    }

    function updateRound() {
    	i++;
    	j=0; // reset excercise number because we are starting a new round
    	if(i < workout.size()) {
    		setRoundFacts();
    	}
    }
    
    function updateExercise() {
    	j++;
    	if(j < workout[i].exercises.size()) {
    		setExerciseFacts();
    	}
    }
    
    function setRoundFacts() {
    	View.findDrawableById("RoundName").setText(workout[i].roundName);
    	var time = (workout[i].roundTime).toNumber();
    	var timeText = getTimeRemainingFormatted(time);
	    View.findDrawableById("RoundTime").setText(timeText + " min");
	    setExerciseFacts();
    }
    
    function setExerciseFacts() {
    	View.findDrawableById("ExerciseName").setText(workout[i].exercises[j].exerciseName);
    	var time = (workout[i].exercises[j].exerciseTime).toNumber();
    	var timeText = getTimeRemainingFormatted(time);
    	View.findDrawableById("ExerciseTime").setText(timeText);
    }
    
    function getTimeRemainingFormatted(timeRemainingSeconds) {
    	var minutes = (timeRemainingSeconds / Cal.SECONDS_PER_MINUTE).toNumber();
		var seconds = timeRemainingSeconds % Cal.SECONDS_PER_MINUTE;
		return minutes.format("%01d") + ":" + seconds.format("%02d");
    }
    
    function clearView() {
    	View.findDrawableById("RoundName").setText("");
	    View.findDrawableById("RoundTime").setText("");
	    View.findDrawableById("ExerciseName").setText("");
	    View.findDrawableById("ExerciseTime").setText("");
    }
    
    function getBitmapInfo() {
    	if (!workoutStarted) {
    		return false;
    	}
    	else if(i == null || workoutFinished) { // workout is done
        	return [60, 70, donegif];
        }
        else if(workout[i].pause) { // show pause cat
        	var pausecat = catgifpause1;
        	if(catPauseCount == 2) {
        		pausecat = catgifpause2;
        	}
        	else if(catPauseCount == 3){
        		pausecat = catgifpause3;
        	}
        	else if(catPauseCount == 4) {
        		pausecat = catgifpause2;
        	}
        	return [70, catYpos, pausecat];
        }
        else { // show running cat
        	var catgif = catgif1;
	        if(catCount == 2) {
	        	catgif = catgif2;
	        } else if(catCount == 3) {
	        	catgif = catgif3;
	        } else if(catCount == 4) {
	        	catgif = catgif4;
	        }
	        return [catXpos, catYpos, catgif];
        }
    }
    
    
    function startRecording() {
        if( Toybox has :ActivityRecording && (( session == null ) || ( session.isRecording() == false ))) {
            session = Record.createSession({:name=>"HIT", :sport=>Record.SPORT_TRAINING, :subSport=>Record.SUB_SPORT_CARDIO_TRAINING});
            session.start();
        }
        return true;
    }
    
    function stopRecording() {
	    if( Toybox has :ActivityRecording && session != null && session.isRecording()) {
			session.stop();
	    }
	    return true;	
    }
    
    function saveRecording() {
    	if( Toybox has :ActivityRecording && session != null) {
    		if(session.isRecording()) {
    			session.stop();
    		}
    		session.save();
    		session = null;
    	}
    	return true;
    }
    
    function discardRecording() {
    	if( Toybox has :ActivityRecording && session != null && session.isRecording() == false) {
    		session.discard();
    		session = null;
    	}
    	return true;
    }
    
    function setNewLapOnSession() {
    	if( Toybox has :ActivityRecording && session != null && session.isRecording() ) {
    		session.addLap();
    	}
    	return true;
    }
    
    function freeMemory() {
    	stopTimers();
    	me.countdown = null;
    	me.catTimer = null;
    	me.i = null;
    	me.j = null;
    	me.catXpos = null;
		me.catYpos = null; 
		me.catCount = null;
		me.catPauseCount = null;
		me.catgif1 = null;
		me.catgif2 = null;
		me.catgif3 = null;
		me.catgif4 = null;
		me.catgifpause1 = null;
		me.catgifpause2 = null;
		me.catgifpause3 = null;
    }
}
