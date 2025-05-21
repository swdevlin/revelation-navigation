"
WBH: Page 82
"
Class {
	#name : 'TaintTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
TaintTable >> initialize [

	super initialize.
	table := Dictionary newFrom: {
			         (2 -> [ AtmosphereTaint newWithSubtype: 'L' ]).
			         (3 -> [ AtmosphereTaint newWithSubtype: 'R' ]).
			         (4 -> [ AtmosphereTaint newWithSubtype: 'B' ]).
			         (5 -> [ AtmosphereTaint newWithSubtype: 'G' ]).
			         (6 -> [ AtmosphereTaint newWithSubtype: 'P' ]).
			         (7 -> [ AtmosphereTaint newWithSubtype: 'G' ]).
			         (8 -> [ AtmosphereTaint newWithSubtype: 'S' ]).
			         (9 -> [ AtmosphereTaint newWithSubtype: 'B' ]).
			         (10 -> [ AtmosphereTaint newWithSubtype: 'P' ]).
			         (11 -> [ AtmosphereTaint newWithSubtype: 'R' ]).
			         (12 -> [ AtmosphereTaint newWithSubtype: 'H' ]) }
]

{ #category : 'roll' }
TaintTable >> rollForAtmosphere: atmo [

	| dm |
	dm := atmo code = 4 ifTrue: [ -2 ].
	dm := atmo code = 4 ifTrue: [ 2 ].
	^ self rollwithDM: dm
]
