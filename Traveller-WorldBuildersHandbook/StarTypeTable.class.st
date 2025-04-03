"
wbh: page 15
"
Class {
	#name : 'StarTypeTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
StarTypeTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> #Special).
			         (3 -> 'M').
			         (4 -> 'M').
			         (5 -> 'M').
			         (6 -> 'M').
			         (7 -> 'K').
			         (8 -> 'K').
			         (9 -> 'G').
			         (10 -> 'G').
			         (11 -> 'F').
			         (12 -> #Hot) }
]
