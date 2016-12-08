using Toybox.System as Sys;
using Toybox.Lang as Lang;

module Workout {

class Round {

	var roundName;
	var roundTime;
	var exercises;
	var pause;
	
	function initialize(roundName, exercises) {
		me.roundName = roundName;
		me.exercises = exercises;
		var roundTime = 0;
		for(var i = 0; i < exercises.size(); i++) {
			roundTime += exercises[i].exerciseTime;
		}
		me.roundTime = roundTime;
		if(roundName.toLower().equals("pause")) {
			me.pause = true;
		}
		else {
			me.pause = false;
		}
	}
	
}

class Exercise {
	
	var exerciseName;
	var exerciseTime;
	var timeRemaining;
	
	function initialize(exerciseName, exerciseTime) {
		me.exerciseName = exerciseName;
		me.exerciseTime = exerciseTime;
		me.timeRemaining = exerciseTime * 60;
	}	
}

function initialize(plan) {
	Sys.println("Plan is: " + plan);
	var numberOfRounds = 0;
	var rounds = [];
	while(plan.length() > 1) {
		var round = setRound(plan);
		rounds.add(round[0]);
		plan = resetString(plan, round[1]-1);
	}
	return rounds;
}

function setRound(plan) {
	var roundString = plan.substring(0, nextSlash(plan));
	var roundStringLength = roundString.length();
	var roundName = roundString.substring(0, nextSemiColon(plan));
	roundString = resetString(roundString, roundName.length());
	var exercises = [];
	var exercisesStringCount = roundName.length() + 1;
	var exerciseName;
	var exerciseTime;
	while(exercisesStringCount < roundStringLength) {
		// Grab the exerciseName
		exerciseName = roundString.substring(0, nextSemiColon(roundString));
		// Grab the exerciseTime
		roundString = resetString(roundString, exerciseName.length());
		exerciseTime = 0;
		if(nextSemiColon(roundString)) {
			exerciseTime = roundString.substring(0, nextSemiColon(roundString));
		}
		else {
			exerciseTime = roundString.substring(0, roundStringLength);
		}
		exercises.add(new Exercise(exerciseName, exerciseTime.toFloat()));
		exercisesStringCount += exerciseName.length() + exerciseTime.length() + 2;
		roundString = resetString(roundString, exerciseTime.length());
	}
	return [new Round(roundName, exercises), exercisesStringCount];
}

function resetString(string, start) {
	return string.substring(start + 1, string.length());
}

function nextSemiColon(plan) {
	return plan.toString().find(";");
}

function nextSlash(plan) {
	return plan.toString().find("/");
}

}