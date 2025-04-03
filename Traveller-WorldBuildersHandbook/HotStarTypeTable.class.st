"
wbh: page 15
"
Class {
	#name : 'HotStarTypeTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
HotStarTypeTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> 'A').
			         (3 -> 'A').
			         (4 -> 'A').
			         (5 -> 'A').
			         (6 -> 'A').
			         (7 -> 'A').
			         (8 -> 'A').
			         (9 -> 'A').
			         (10 -> 'B').
			         (11 -> 'B').
			         (12 -> 'O') }
]
