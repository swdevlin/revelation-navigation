"
wbh: page 29

"
Class {
	#name : 'CompanionStarDeterminationTable',
	#superclass : 'RollTable',
	#instVars : [
		'star'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
CompanionStarDeterminationTable >> computeDM [

	| dm |
	dm := super computeDM.

	(#( 'III' 'IV' ) includes: star stellarClass) ifTrue: [ dm := dm - 1 ].
	^ dm
]

{ #category : 'initialization' }
CompanionStarDeterminationTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> #Other).
			         (3 -> #Other).
			         (4 -> #Random).
			         (5 -> #Random).
			         (6 -> #Random).
			         (7 -> #Lesser).
			         (8 -> #Sibling).
			         (9 -> #Sibling).
			         (10 -> #Twin).
			         (11 -> #Twin).
			         (12 -> #Twin) }
]

{ #category : 'roll' }
CompanionStarDeterminationTable >> rollFor: aStar [

	star := aStar.
	^ super roll
]
