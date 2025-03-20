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
		'colour',
		'companion',
		'age'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
Star class >> generateNew [

	| starTypeTable star type class subtype hotStarTable nonSpecialStarType catalog |
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

	catalog := StarCatalog new.
	star := self new.
	star
		stellarClass: class;
		subtype: subtype;
		stellarType: type;
		mass: (catalog massForType: type subtype: subtype class: class);
		temperature: (catalog temperatureForType: type subtype: subtype);
		diameter: (catalog diameterForType: type subtype: subtype class: class);
		colour: (catalog colourForType: type) .

	^ star
]

{ #category : 'as yet unclassified' }
Star class >> generateNewType: type subtype: subtype class: class [

	| star catalog |

	catalog := StarCatalog new.
	star := self new.
	star
		stellarClass: class;
		subtype: subtype;
		stellarType: type;
		mass: (catalog massForType: type subtype: subtype class: class);
		temperature: (catalog temperatureForType: type subtype: subtype);
		diameter: (catalog diameterForType: type subtype: subtype class: class);
		colour: (catalog colourForType: type) .

	^ star
]

{ #category : 'accessing' }
Star >> age [

	age ifNil: [
		| msl dice subGiantLifespan giantLifespan |
		dice := DieRoller roller.

		msl := 10 / (mass raisedTo: 2.5).

		(#( 'Ia' 'Ib' 'II' 'V' 'VI' ) includes: stellarClass)
			ifTrue: [
				age := mass > 0.9
					       ifTrue: [ msl * (dice roll: 1 d: 100) / 100.0 ]
					       ifFalse: [
						       (dice roll: 1 d: 6) * 2 + ((dice roll: 1 d: 3) - 2)
						       + ((dice roll: 1 d: 10) / 10.0) ].

				mass < 4.7 ifTrue: [ age := 0.01 max: age ] ]
			ifFalse: [
				subGiantLifespan := msl / (4 + mass).
				stellarClass = 'IV'
					ifTrue: [
					age := msl + (subGiantLifespan * (dice roll: 1 d: 100) / 100.0) ]
					ifFalse: [
						giantLifespan := msl / (10 * (mass raisedTo: 3)).
						age := msl + subGiantLifespan
						       + (giantLifespan * (dice roll: 1 d: 100) / 100.0) ] ] ].
	^ age
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

{ #category : 'as yet unclassified' }
Star >> companionCheck [

	^ self multipleStarCheck
]

{ #category : 'accessing' }
Star >> luminosity [

	^ diameter squared * ((temperature / 5772) squared)
]

{ #category : 'as yet unclassified' }
Star >> multipleStarCheck [

	| roller |
	roller := DieRoller roller.

	^ self multipleStarDM + (roller roll: 2 d: 6) >= 10
]

{ #category : 'as yet unclassified' }
Star >> multipleStarDM [

	| dm |
	dm := 0.

	(#( 'BD' 'D' 'PSR' 'BH' 'NS' ) includes: stellarType)
		ifTrue: [ dm := dm - 1 ]
		ifFalse: [
			(#( 'Ia' 'Ib' 'II' 'III' 'IV' ) includes: stellarClass)
				ifTrue: [ dm := dm + 1 ].

			(#( 'V' 'VI' ) includes: stellarClass) ifTrue: [
				stellarType = 'M' ifTrue: [ dm := dm - 1 ].
				(#( 'O' 'B' 'A' 'F' ) includes: stellarType) ifTrue: [
					dm := dm + 1 ] ] ].

	^ dm
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
