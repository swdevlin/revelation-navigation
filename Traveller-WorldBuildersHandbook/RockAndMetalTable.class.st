"
WBH 71
"
Class {
	#name : 'RockAndMetalTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
RockAndMetalTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> 0.82).
			         (3 -> 0.85).
			         (4 -> 0.88).
			         (5 -> 0.91).
			         (6 -> 0.94).
			         (7 -> 0.97).
			         (8 -> 1.00).
			         (9 -> 1.03).
			         (10 -> 1.06).
			         (11 -> 1.09).
			         (12 -> 1.12) }
]
