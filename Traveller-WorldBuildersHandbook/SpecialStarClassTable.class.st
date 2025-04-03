"
wbh: page 15
"
Class {
	#name : 'SpecialStarClassTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
SpecialStarClassTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> 'VI').
			         (3 -> 'VI').
			         (4 -> 'VI').
			         (5 -> 'VI').
			         (6 -> 'IV').
			         (7 -> 'IV').
			         (8 -> 'IV').
			         (9 -> 'III').
			         (10 -> 'III').
			         (11 -> #Giant).
			         (12 -> #Giant) }
]
