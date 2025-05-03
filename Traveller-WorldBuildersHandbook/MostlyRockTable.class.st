"
WBH 71
"
Class {
	#name : 'MostlyRockTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
MostlyRockTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> 0.50).
			         (3 -> 0.53).
			         (4 -> 0.56).
			         (5 -> 0.59).
			         (6 -> 0.62).
			         (7 -> 0.65).
			         (8 -> 0.68).
			         (9 -> 0.71).
			         (10 -> 0.74).
			         (11 -> 0.77).
			         (12 -> 0.80) }
]
