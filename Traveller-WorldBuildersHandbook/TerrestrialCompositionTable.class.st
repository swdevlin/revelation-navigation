"
WBH 71
"
Class {
	#name : 'TerrestrialCompositionTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'accessing' }
TerrestrialCompositionTable class >> tableName [

	^ 'Terrestrial Composition'
]

{ #category : 'initialization' }
TerrestrialCompositionTable >> initialize [

	super initialize.

	table := Dictionary newFrom: {
			         (-4 -> ('Exotic Ice' -> ExoticIceTable)).
			         (-3 -> ('Mostly Ice' -> MostlyIceTable)).
			         (-2 -> ('Mostly Ice' -> MostlyIceTable)).
			         (-1 -> ('Mostly Ice' -> MostlyIceTable)).
			         (0 -> ('Mostly Ice' -> MostlyIceTable)).
			         (1 -> ('Mostly Ice' -> MostlyIceTable)).
			         (2 -> ('Mostly Ice' -> MostlyIceTable)).
			         (3 -> ('Mostly Rock' -> MostlyRockTable)).
			         (4 -> ('Mostly Rock' -> MostlyRockTable)).
			         (5 -> ('Mostly Rock' -> MostlyRockTable)).
			         (6 -> ('Mostly Rock' -> MostlyRockTable)).
			         (7 -> ('Rock and Metal'-> RockAndMetalTable)).
			         (8 -> ('Rock and Metal'-> RockAndMetalTable)).
			         (9 -> ('Rock and Metal'-> RockAndMetalTable)).
			         (10 -> ('Rock and Metal'-> RockAndMetalTable)).
			         (11 -> ('Rock and Metal'-> RockAndMetalTable)).
			         (12 -> ('Mostly Metal' -> MostlyMetalTable)).
			         (13 -> ('Mostly Metal' -> MostlyMetalTable)).
			         (14 -> ('Mostly Metal' -> MostlyMetalTable)).
			         (15 -> ('Compressed Metal' -> CompressedMetalTable)) }
]

{ #category : 'roll' }
TerrestrialCompositionTable >> roll: aRoll dm: dm [

	| total |
	total := aRoll + dm.
	lastRoll := aRoll.
	lastDM := dm.

	total <= -4 ifTrue: [ ^ 'Exotic Ice' -> ExoticIceTable new roll ].
	total <= 2 ifTrue: [ ^ 'Mostly Ice' -> MostlyIceTable new roll ].
	total <= 6 ifTrue: [ ^ 'Mostly Rock' -> MostlyRockTable new roll ].
	total <= 11 ifTrue: [
		^ 'Rock and Metal' -> RockAndMetalTable new roll ].
	total < 15 ifTrue: [ ^ 'Mostly Metal' -> MostlyMetalTable new roll ].
	total >= 15 ifTrue: [
		^ 'Compressed Metal' -> CompressedMetalTable new roll ]
]

{ #category : 'roll' }
TerrestrialCompositionTable >> rollFor: aPlanet [

	| dm star |
	dm := 0.
	aPlanet sizeCode <= 4 ifTrue: [ dm := dm - 1 ].
	(aPlanet sizeCode between: 6 and: 9) ifTrue: [ dm := dm + 1 ].
	(aPlanet sizeCode between: 10 and: 15) ifTrue: [ dm := dm + 3 ].
	star := aPlanet orbiting.
	dm := aPlanet orbit < star hzco
		      ifTrue: [ dm + 1 ]
		      ifFalse: [ dm - 1 ].
	dm := dm - (aPlanet orbit - star hzco floor min: 0).
	star age > 10 ifTrue: [ dm := dm - 1 ].
	^ self rollwithDM: dm
]
