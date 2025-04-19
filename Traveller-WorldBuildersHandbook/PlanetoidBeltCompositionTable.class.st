"
From World Builder's Handbook page 73
"
Class {
	#name : 'PlanetoidBeltCompositionTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
PlanetoidBeltCompositionTable >> initialize [

	| dice |
	dice := DieRoller roller.

	super initialize.

	table := Dictionary newFrom: {
			         (0 -> [
			          ^ Dictionary new
				            at: #mPercentage put: 60 + ((dice roll: 1 d: 6) * 5);
				            at: #sPercentage put: (dice roll: 1 d: 6) * 5;
				            at: #cPercentage put: 0;
				            yourself ]).
			         (1 -> [
			          ^ Dictionary new
				            at: #mPercentage put: 50 + ((dice roll: 1 d: 6) * 5);
				            at: #sPercentage put: 5 + ((dice roll: 1 d: 6) * 5);
				            at: #cPercentage put: (dice roll: 1 d: 3);
				            yourself ]).
			         (2 -> [
			          ^ Dictionary new
				            at: #mPercentage put: 40 + ((dice roll: 1 d: 6) * 5);
				            at: #sPercentage put: 15 + ((dice roll: 1 d: 6) * 5);
				            at: #cPercentage put: (dice roll: 1 d: 6);
				            yourself ]).
			         (3 -> [
			          ^ Dictionary new
				            at: #mPercentage put: 25 + ((dice roll: 1 d: 6) * 5);
				            at: #sPercentage put: 30 + ((dice roll: 1 d: 6) * 5);
				            at: #cPercentage put: (dice roll: 1 d: 6);
				            yourself ]).
			         (4 -> [
			          ^ Dictionary new
				            at: #mPercentage put: 15 + ((dice roll: 1 d: 6) * 5);
				            at: #sPercentage put: 35 + ((dice roll: 1 d: 6) * 5);
				            at: #cPercentage put: (5 + dice roll: 1 d: 6);
				            yourself ]).
			         (5 -> [
			          ^ Dictionary new
				            at: #mPercentage put: 5 + ((dice roll: 1 d: 6) * 5);
				            at: #sPercentage put: 40 + ((dice roll: 1 d: 6) * 5);
				            at: #cPercentage put: 5 + ((dice roll: 1 d: 6) * 2);
				            yourself ]).
			         (6 -> [
			          ^ Dictionary new
				            at: #mPercentage put: (dice roll: 1 d: 6) * 5;
				            at: #sPercentage put: 40 + ((dice roll: 1 d: 6) * 5);
				            at: #cPercentage put: (dice roll: 1 d: 6) * 5;
				            yourself ]).
			         (7 -> [
			          ^ Dictionary new
				            at: #mPercentage put: 5 + ((dice roll: 1 d: 6) * 2);
				            at: #sPercentage put: 35 + ((dice roll: 1 d: 6) * 5);
				            at: #cPercentage put: 10 + ((dice roll: 1 d: 6) * 5);
				            yourself ]).
			         (8 -> [
			          ^ Dictionary new
				            at: #mPercentage put: 5 + (dice roll: 1 d: 6);
				            at: #sPercentage put: 30 + ((dice roll: 1 d: 6) * 5);
				            at: #cPercentage put: 20 + ((dice roll: 1 d: 6) * 5);
				            yourself ]).
			         (9 -> [
			          ^ Dictionary new
				            at: #mPercentage put: (dice roll: 1 d: 6);
				            at: #sPercentage put: 15 + ((dice roll: 1 d: 6) * 5);
				            at: #cPercentage put: 40 + ((dice roll: 1 d: 6) * 5);
				            yourself ]).
			         (10 -> [
			          ^ Dictionary new
				            at: #mPercentage put: (dice roll: 1 d: 6);
				            at: #sPercentage put: 5 + ((dice roll: 1 d: 6) * 5);
				            at: #cPercentage put: 50 + ((dice roll: 1 d: 6) * 5);
				            yourself ]).
			         (11 -> [
			          ^ Dictionary new
				            at: #mPercentage put: (dice roll: 1 d: 3);
				            at: #sPercentage put: 5 + ((dice roll: 1 d: 6) * 2);
				            at: #cPercentage put: 60 + ((dice roll: 1 d: 6) * 5);
				            yourself ]).
			         (12 -> [
			          ^ Dictionary new
				            at: #mPercentage put: 0;
				            at: #sPercentage put: (dice roll: 1 d: 6);
				            at: #cPercentage put: 70 + ((dice roll: 1 d: 6) * 5);
				            yourself ]) }
]
