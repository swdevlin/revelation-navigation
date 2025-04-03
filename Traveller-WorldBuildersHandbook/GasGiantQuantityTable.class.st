"
wbh: something
"
Class {
	#name : 'GasGiantQuantityTable',
	#superclass : 'RollTable',
	#instVars : [
		'solarSystem'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'roll' }
GasGiantQuantityTable >> computeDM [

	| dm |
	dm := super computeDM.

	(solarSystem starCount = 1 and:
		 solarSystem primary stellarClass = 'V') ifTrue: [ dm := dm + 1 ].

	solarSystem primary isBrownDwarf ifTrue: [ dm := dm - 2 ].

	solarSystem primary isPostStellar ifTrue: [ dm := dm - 2 ].

	solarSystem starCount >= 4 ifTrue: [ dm := dm - 1 ].
	^ dm
]

{ #category : 'initialization' }
GasGiantQuantityTable >> initialize [

	super initialize.

	table := Dictionary newFrom: {
			         (4 -> 1).
			         (5 -> 2).
			         (6 -> 2).
			         (7 -> 3).
			         (8 -> 3).
			         (9 -> 4).
			         (10 -> 4).
			         (11 -> 4).
			         (12 -> 5).
			         (13 -> 6) }
]

{ #category : 'roll' }
GasGiantQuantityTable >> rollFor: aSolarSystem [

	solarSystem := aSolarSystem.
	^ super roll
]

{ #category : 'accessing' }
GasGiantQuantityTable >> solarSystem [

	^ solarSystem
]

{ #category : 'accessing' }
GasGiantQuantityTable >> solarSystem: anObject [

	solarSystem := anObject
]
