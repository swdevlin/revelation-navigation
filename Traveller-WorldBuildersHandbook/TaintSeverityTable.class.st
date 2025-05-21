"
WBH: Pg 83
"
Class {
	#name : 'TaintSeverityTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
TaintSeverityTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (4 -> 1).
			         (5 -> 2).
			         (6 -> 3).
			         (7 -> 4).
			         (8 -> 5).
			         (9 -> 6).
			         (10 -> 7).
			         (11 -> 8).
			         (12 -> 9) }
]

{ #category : 'roll' }
TaintSeverityTable >> rollFor: atmosphere [

	| dm |
	dm := atmosphere code = 12
		      ifTrue: [ 6 ]
		      ifFalse: [
			      (#( 'L' 'H' ) includes: atmosphere taint subtype)
				      ifTrue: [ 4 ]
				      ifFalse: [ 0 ] ].
	^ self rollwithDM: dm
]
