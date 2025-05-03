"
WBH 71
"
Class {
	#name : 'MostlyIceTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
MostlyIceTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> 0.18).
			         (3 -> 0.21).
			         (4 -> 0.24).
			         (5 -> 0.27).
			         (6 -> 0.30).
			         (7 -> 0.33).
			         (8 -> 0.36).
			         (9 -> 0.39).
			         (10 -> 0.41).
			         (11 -> 0.44).
			         (12 -> 0.47) }
]
