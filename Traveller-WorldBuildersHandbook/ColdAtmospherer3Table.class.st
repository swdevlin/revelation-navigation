"
WBH 95
"
Class {
	#name : 'ColdAtmospherer3Table',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
ColdAtmospherer3Table >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (0 -> [
			          Atmosphere new
				          code: 0;
				          yourself ]).
			         (1 -> [
			          Atmosphere new
				          code: 1;
				          yourself ]).
			         (2 -> [
			          | r |
			          r := self roller roll: 1 d: 6.
			          r >= 4 ifTrue: [
				          Atmosphere new
					          code: 1;
					          yourself ] ]).
			         (3 -> [
			          Atmosphere new
				          code: 10;
				          density: 'Very Thin' yourself ]).
			         (4 -> 'A').
			         (5 -> 'A').
			         (6 -> 'A').
			         (7 -> 'A').
			         (8 -> 'A').
			         (9 -> 'A').
			         (10 -> 'B').
			         (11 -> 'B').
			         (12 -> 'O') }
]
