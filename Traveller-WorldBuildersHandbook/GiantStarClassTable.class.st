"
wbh: page 15
"
Class {
	#name : 'GiantStarClassTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'accessing' }
GiantStarClassTable class >> tableName [

	^ 'Giant Star Class'
]

{ #category : 'initialization' }
GiantStarClassTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> 'III').
			         (3 -> 'III').
			         (4 -> 'III').
			         (5 -> 'III').
			         (6 -> 'III').
			         (7 -> 'III').
			         (8 -> 'III').
			         (9 -> 'II').
			         (10 -> 'II').
			         (11 -> 'Ib').
			         (12 -> 'Ia') }
]
