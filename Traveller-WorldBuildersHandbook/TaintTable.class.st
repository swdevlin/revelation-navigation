"
WBH: Page 82
"
Class {
	#name : 'TaintTable',
	#superclass : 'RollTable',
	#instVars : [
		'atmo'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
TaintTable >> computeDM [

	| dm |
	dm := super computeDM .
	dm := atmo code = 4 ifTrue: [ -2 ].
	dm := atmo code = 9 ifTrue: [ 2 ].
	^ dm
]

{ #category : 'initialization' }
TaintTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> [ 'L' ]).
			         (3 -> [ 'R' ]).
			         (4 -> [ 'B' ]).
			         (5 -> [ 'G' ]).
			         (6 -> [ 'P' ]).
			         (7 -> [ 'G' ]).
			         (8 -> [ 'S' ]).
			         (9 -> [ 'B' ]).
			         (10 -> [
			          | subtype |
			          subtype := 'P' , self roll.
			          subtype size > 3 ifTrue: [
				          subtype := subtype copyFrom: 1 to: 3 ].
			          subtype ]).
			         (11 -> [ 'R' ]).
			         (12 -> [ 'H' ]) }
]

{ #category : 'roll' }
TaintTable >> rollForAtmosphere: anAtmo [

	atmo := anAtmo .
	^ self roll
]
