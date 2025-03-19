"
Determine a star's subtype (0-9).
"
Class {
	#name : 'StarSubtypeRollTable',
	#superclass : 'RollTable',
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
StarSubtypeRollTable >> rollForStellarClass: class stellarType: type [

	| subtype |
	subtype := self roll.
	(type == 'K' and: class == 'IV') ifTrue: [
		subtype > 4 ifTrue: [ subtype := subtype - 5 ] ].

	^ subtype
]
