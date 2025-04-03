"
wbh: page 16
"
Class {
	#name : 'MTypePrimarySubtypeTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
MTypePrimarySubtypeTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> 8).
			         (3 -> 6).
			         (4 -> 5).
			         (5 -> 4).
			         (6 -> 0).
			         (7 -> 2).
			         (8 -> 1).
			         (9 -> 3).
			         (10 -> 5).
			         (11 -> 7).
			         (12 -> 9) }
]
