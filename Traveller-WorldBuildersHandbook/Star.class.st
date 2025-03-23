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
		'age',
		'luminosity'
	],
	#classVars : [
		'brownDwarfLuminosity',
		'brownDwarfMass',
		'brownDwarfTemperature',
		'brownDwarfTypes'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'accessing' }
Star class >> brownDwarfLuminosity [

	^ brownDwarfLuminosity
]

{ #category : 'accessing' }
Star class >> brownDwarfMass [

	^ brownDwarfMass
]

{ #category : 'accessing' }
Star class >> brownDwarfTemperature [

	^ brownDwarfTemperature
]

{ #category : 'as yet unclassified' }
Star class >> brownDwarfTypeAndSubtypeFromMass: mass [

    | type subtype lower upper stepSize lowerValue upperValue massVector epsilon |

    massVector := self brownDwarfMass.

    "Check if mass is larger than or equal to the largest known mass"
    mass >= massVector first ifTrue: [
        ^ { self brownDwarfTypes first. 0 } ].

    epsilon := 1.0e-10.

    "Find upper and lower bounds"
    upper := massVector detectIndex: [ :value | mass > value ] ifNone: [ 7 ].
    lower := upper - 1.

    "Check if upper exceeds the known data range"
    upper > massVector size
        ifTrue: [
            type := self brownDwarfTypes last.
            subtype := ((0.013 - mass) / 0.0024 - epsilon) floor + 6.
            ^ { type. subtype } ].

    "Within known mass range"
    type := self brownDwarfTypes at: (lower / 2) ceiling.
    lowerValue := massVector at: lower.

    "Determine subtype"
    lowerValue = mass
        ifTrue: [ subtype := 0 ]
        ifFalse: [
            upperValue := massVector at: upper.
            stepSize := (lowerValue - upperValue) / 5.
            subtype := ((lowerValue - mass) / stepSize - epsilon) floor + 1 ].

    "Adjust subtype for even-indexed mass values"
    lower even ifTrue: [ subtype := subtype + 5 ].

    ^ { type. subtype }

]

{ #category : 'accessing' }
Star class >> brownDwarfTypes [

	^ brownDwarfTypes
]

{ #category : 'as yet unclassified' }
Star class >> generateCompanionFor: star [

	| t dm table |
	dm := (#( 'III' 'IV' ) includes: star stellarClass)
		      ifTrue: [ -1 ]
		      ifFalse: [ 0 ].
	table := RollTable companionStarDetermination.
	table mod: dm.
	t := table roll.

	t
		caseOf: {
				(#Other -> [
				 (DieRoller roller roll: 2 d: 6) < 8
					 ifTrue: [ ^ self generateNewWhiteDwarf ]
					 ifFalse: [ ^ self generateNewBrownDwarf ] ]).
				(#Random -> [
				 | c |
				 c := self generateNew.
				 (c isHotter: star)
					 ifTrue: [ ^ self generateLesserFor: star ]
					 ifFalse: [ ^ c ] ]).
				(#Lesser -> [ ^ self generateLesserFor: star ]).
				(#Sibling -> [ ^ self generateSiblingFor: star ]).
				(#Twin -> [
				 ^ self
					   generateNewType: star stellarType
					   subtype: star subtype
					   class: star stellarClass ]) }
		otherwise: [ self notImplemented ]
]

{ #category : 'as yet unclassified' }
Star class >> generateLesserFor: aStar [

	| stellarType subtype |
	stellarType := aStar stellarType.
	subtype := aStar subtype.

	aStar stellarType = self typeOrder last
		ifTrue: [
			subtype := RollTable mPrimarySubtype roll.
			subtype < aStar subtype ifTrue: [ stellarType := 'BD' ] ]
		ifFalse: [
			stellarType := aStar coolerType.
			subtype := RollTable starSubtype roll ].

	stellarType = 'BD'
		ifTrue: [ ^ self generateNewBrownDwarf ]
		ifFalse: [
			^ self
				  generateNewType: stellarType
				  subtype: subtype
				  class: aStar stellarClass ]
]

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
Star class >> generateNewBrownDwarf [
	"WBH: 226"

	| mass typeAndSubtypeTuple dice type subtype lower upper temperature diameter luminosity |
	dice := DieRoller roller.
	mass := (dice roll: 1 d: 6) / 100.0
	        + ((dice roll: 4 d: 6) - 1 / 1000).

	typeAndSubtypeTuple := self brownDwarfTypeAndSubtypeFromMass: mass.
	type := typeAndSubtypeTuple at: 1.
	subtype := typeAndSubtypeTuple at: 2.

	lower := (self brownDwarfTypes indexOf: type) * 2 - 1.
	subtype >= 5 ifTrue: [ lower := lower + 1 ].
	upper := lower + 1.

	temperature := StarCatalog
		               subtypeInterpolate: brownDwarfTemperature
		               lower: lower
		               upper: upper
		               subtype: subtype.

	luminosity := StarCatalog
		              subtypeInterpolate: brownDwarfLuminosity
		              lower: lower
		              upper: upper
		              subtype: subtype.

	diameter := 0.1.

	type = 'L' ifTrue: [
		diameter := StarCatalog
			            subtypeInterpolate: #( 0.08 0.06 )
			            lower: 1
			            upper: 2
			            subtype: subtype ].

	type = 'T' ifTrue: [
		diameter := StarCatalog
			            subtypeInterpolate: #( 0.05 0.04 )
			            lower: 1
			            upper: 2
			            subtype: subtype ].

	type = 'Y' ifTrue: [ diameter := 0.1 ].

	^ self new
		  stellarType: type;
		  subtype: subtype;
		  mass: mass;
		  temperature: temperature;
		  luminosity: luminosity;
		  diameter: diameter;
		  yourself
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

{ #category : 'as yet unclassified' }
Star class >> generateNewWhiteDwarf [
	"WBH: 227"

	| mass age finalAge dice type temperature diameter luminosity |
	dice := DieRoller roller.
	mass := ((dice roll: 2 d: 6)-1 / 10.0 + ((dice roll: 1 d: 10) / 100.0)).
	age := mass * (2 + (dice roll: 1 d: 3)).
	finalAge := (10 / (mass pow: 2.5))*(1 + (1/(4+mass) + (1 / (mass pow: 3 * 10)))).
	diameter := 1 / mass * 0.01.

	type := 'D'.

	^ self new
		  stellarType: type;
		  mass: mass;
		  temperature: temperature;
		  luminosity: luminosity;
		  diameter: diameter;
		  yourself
]

{ #category : 'as yet unclassified' }
Star class >> generateSiblingFor: aStar [

	| t s c r roller |
	t := aStar stellarType.
	s := aStar subtype.
	c := aStar stellarClass.

	roller := DieRoller roller.
	r := roller roll: 1 d: 6.
	r + s > 9
		ifTrue: [
			| coolerType |
			coolerType := aStar coolerType.
			coolerType = aStar stellarType
				ifTrue: [ s := 9 ]
				ifFalse: [
					t := coolerType.
					s := r + s \\ 10 ] ]
		ifFalse: [ s := s + r ].

	^ self generateNewType: t subtype: s class: c
]

{ #category : 'class initialization' }
Star class >> initialize [

	brownDwarfLuminosity := #( 0.00029 0.000066 0.000020 0.0000070
	                           0.00000081 0.000000072 ).
	brownDwarfMass := #( 0.08 0.06 0.05 0.04 0.025 0.013 ).
	brownDwarfTemperature := #( 2400 1850 1300 900 550 300 ).
	brownDwarfTypes := #( 'L' 'T' 'Y' )
]

{ #category : 'as yet unclassified' }
Star class >> typeOrder [

	^ #( 'O' 'B' 'A' 'F' 'G' 'K' 'M' )
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

{ #category : 'as yet unclassified' }
Star >> coolerType [

	| i |
	i := self class typeOrder indexOf: stellarType.
	i = self class typeOrder size
		ifTrue: [ ^ stellarType ]
		ifFalse: [ ^ self class typeOrder at: i + 1 ]
]

{ #category : 'as yet unclassified' }
Star >> generateCompanionIfPresent [

	self multipleStarCheck ifTrue: [
		companion := Star generateCompanionStarFor: self ].
	^ self companion
]

{ #category : 'testing' }
Star >> isHotter: aStar [

	| types |
	types := self class typeOrder.
	(types indexOf: stellarType) = (types indexOf: aStar stellarType)
		ifTrue: [ ^ subtype < aStar subtype ]
		ifFalse: [
		^ (types indexOf: stellarType) < (types indexOf: aStar stellarType) ]
]

{ #category : 'accessing' }
Star >> luminosity [

	luminosity
		ifNil: [ ^ diameter squared * (temperature / 5772) squared ]
		ifNotNil: [ ^ luminosity ]
]

{ #category : 'accessing' }
Star >> luminosity: anObject [

	luminosity := anObject
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
