"
wbh: 37
"
Class {
	#name : 'PlanetoidBeltQuantityTable',
	#superclass : 'RollTable',
	#instVars : [
		'solarSystem',
		'gasGiantCount'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
PlanetoidBeltQuantityTable >> computeDM [

	| dm primary |
	dm := super computeDM.
	primary := solarSystem primary.

	self gasGiantCount > 0 ifTrue: [ dm := dm + 1 ].
	primary isProtoStar ifTrue: [ dm := dm + 3 ].
	primary isPrimordial ifTrue: [ dm := dm + 2 ].
	primary isPostStellar ifTrue: [ dm := dm + 1 ].
	dm := dm + solarSystem postStellarCount.
	solarSystem starCount >= 2 ifTrue: [ dm := dm + 1 ].
	^ dm
]

{ #category : 'accessing' }
PlanetoidBeltQuantityTable >> gasGiantCount [

	^ gasGiantCount
]

{ #category : 'accessing' }
PlanetoidBeltQuantityTable >> gasGiantCount: anObject [

	gasGiantCount := anObject
]

{ #category : 'initialization' }
PlanetoidBeltQuantityTable >> initialize [

	super initialize.

	table := Dictionary newFrom: {
			         (6 -> 1).
			         (7 -> 2).
			         (8 -> 2).
			         (9 -> 2).
			         (10 -> 2).
			         (11 -> 2).
			         (12 -> 3) }
]

{ #category : 'as yet unclassified' }
PlanetoidBeltQuantityTable >> rollFor: aSolarSystem gasGiants: gasGiants [

	solarSystem := aSolarSystem.
	gasGiantCount := gasGiants.
	^ self roll
]

{ #category : 'accessing' }
PlanetoidBeltQuantityTable >> solarSystem [

	^ solarSystem
]

{ #category : 'accessing' }
PlanetoidBeltQuantityTable >> solarSystem: anObject [

	solarSystem := anObject
]
