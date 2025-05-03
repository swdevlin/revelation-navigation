"
WBH 71
"
Class {
	#name : 'CompressedMetalTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
CompressedMetalTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> 1.50).
			         (3 -> 1.55).
			         (4 -> 1.60).
			         (5 -> 1.65).
			         (6 -> 1.70).
			         (7 -> 1.75).
			         (8 -> 1.80).
			         (9 -> 1.85).
			         (10 -> 1.90).
			         (11 -> 1.95).
			         (12 -> 2.00) }
]
