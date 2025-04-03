"
WBH: page 29


"
Class {
	#name : 'SecondaryStarDeterminationTable',
	#superclass : 'RollTable',
	#instVars : [
		'primary'
	],
	#classInstVars : [
		'primary'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
SecondaryStarDeterminationTable >> computeDM [

	| dm |
	dm := super computeDM.
	(#( 'III' 'IV' ) includes: primary stellarClass) ifTrue: [
		dm := dm - 1 ].
	^ dm
]

{ #category : 'initialization' }
SecondaryStarDeterminationTable >> initialize [

	super initialize.

	table := Dictionary newFrom: {
			         (2 -> #Other).
			         (3 -> #Other).
			         (4 -> #Random).
			         (5 -> #Random).
			         (6 -> #Random).
			         (7 -> #Lesser).
			         (8 -> #Lesser).
			         (9 -> #Sibling).
			         (10 -> #Sibling).
			         (11 -> #Twin).
			         (12 -> #Twin) }
]

{ #category : 'roll' }
SecondaryStarDeterminationTable >> rollFor: primaryStar [

	primary := primaryStar.
	^ self roll
]
