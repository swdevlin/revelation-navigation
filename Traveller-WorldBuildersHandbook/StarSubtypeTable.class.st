"
wbh: page 16

Determine a star's subtype (0-9)
"
Class {
	#name : 'StarSubtypeTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'initialization' }
StarSubtypeTable >> initialize [

	super initialize.

	table := Dictionary newFrom: {
			         (2 -> 0).
			         (3 -> 1).
			         (4 -> 3).
			         (5 -> 5).
			         (6 -> 7).
			         (7 -> 9).
			         (8 -> 8).
			         (9 -> 6).
			         (10 -> 4).
			         (11 -> 2).
			         (12 -> 0) }
]

{ #category : 'as yet unclassified' }
StarSubtypeTable >> rollForStellarType: st stellarClass: sc [

	| r |
	r := self roll.
	(st = 'K' and: sc = 'IV') ifTrue: [ r > 4 ifTrue: [ r := r - 5 ] ].
	^ r
]
