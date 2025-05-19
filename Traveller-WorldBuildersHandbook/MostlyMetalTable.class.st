"
WBH 71
"
Class {
	#name : 'MostlyMetalTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
MostlyMetalTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> 1.15).
			         (3 -> 1.18).
			         (4 -> 1.21).
			         (5 -> 1.24).
			         (6 -> 1.27).
			         (7 -> 1.30).
			         (8 -> 1.33).
			         (9 -> 1.36).
			         (10 -> 1.39).
			         (11 -> 1.42).
			         (12 -> 1.45) }
]
