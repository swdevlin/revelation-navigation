"
WBH: Page 84
"
Class {
	#name : 'TaintPersistenceTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
TaintPersistenceTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> 2).
			         (3 -> 3).
			         (4 -> 4).
			         (5 -> 5).
			         (6 -> 6).
			         (7 -> 7).
			         (8 -> 8).
			         (9 -> 9) }
]

{ #category : 'as yet unclassified' }
TaintPersistenceTable >> rollForSubtype: subtype severity: severity atmosphere: atmosphere [

	| dm |
	dm := atmosphere code = 12
		      ifTrue: [ 6 ]
		      ifFalse: [ 0 ].
	(#( 'L' #'.' 'H' ) includes: subtype) ifTrue: [
		dm := severity >= 8
			      ifTrue: [ dm + 6 ]
			      ifFalse: [ dm + 4 ] ].
	^ self rollwithDM: dm
]
