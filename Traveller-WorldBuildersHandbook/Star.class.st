"
Stars
"
Class {
	#name : 'Star',
	#superclass : 'StellarObject',
	#instVars : [
		'stellarClass',
		'stellarType',
		'subtype',
		'age',
		'colour',
		'companion'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
Star class >> generateNew [

	| starTypeTable star type class subtype hotStarTable nonSpecialStarType |
	starTypeTable := RollTable starType.
	hotStarTable := RollTable hotStarType.

	nonSpecialStarType := [ :withRoll |
	                      | t |
	                      starTypeTable mod: 1.
	                      withRoll
		                      ifNil: [ t := starTypeTable roll ]
		                      ifNotNil: [ t := starTypeTable roll: withRoll ].
	                      t == #Hot ifTrue: [
		                      t := RollTable hotStarType roll ].
	                      t ].

	class := 'V'.

	type := starTypeTable roll.
	Transcript
		show: type;
		show: (starTypeTable lastRoll);
		cr.
	type == #Hot ifTrue: [ type := RollTable hotStarType roll ].

	type == #Special ifTrue: [
		class := RollTable specialStarClass roll.
		class == #Giant
			ifTrue: [
				class := RollTable giantStarClass roll.
				type := nonSpecialStarType value: nil ]
			ifFalse: [
				type := nonSpecialStarType value: nil.
				class == 'IV' ifTrue: [
					type == 'M' ifTrue: [
						| r |
						r := 5 + starTypeTable lastRoll.
						type := nonSpecialStarType value: r.
						type == 'O' ifTrue: [ type := 'B' ] ] ].
				class == 'VI' ifTrue: [
					type == 'F' ifTrue: [ type := 'G' ].
					type == 'A' ifTrue: [ type := 'B' ] ] ] ].

	subtype := RollTable starSubtype
		           rollForStellarClass: class
		           stellarType: type.

	star := self new.
	star
		stellarClass: class;
		subtype: subtype;
		stellarType: type.

	^ star
]

{ #category : 'accessing' }
Star >> age [

	^ age
]

{ #category : 'accessing' }
Star >> age: anObject [

	age := anObject
]

{ #category : 'accessing' }
Star >> colour [

	^ colour
]

{ #category : 'accessing' }
Star >> colour: anObject [

	colour := anObject
]

{ #category : 'accessing' }
Star >> companion [

	^ companion
]

{ #category : 'accessing' }
Star >> companion: anObject [

	companion := anObject
]

{ #category : 'accessing' }
Star >> stellarClass [

	^ stellarClass
]

{ #category : 'accessing' }
Star >> stellarClass: anObject [

	stellarClass := anObject
]

{ #category : 'accessing' }
Star >> stellarType [

	^ stellarType
]

{ #category : 'accessing' }
Star >> stellarType: anObject [

	stellarType := anObject
]

{ #category : 'accessing' }
Star >> subtype [

	^ subtype
]

{ #category : 'accessing' }
Star >> subtype: anObject [

	subtype := anObject
]
