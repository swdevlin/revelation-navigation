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
		'luminosity',
		'stellarBodies'
	],
	#classVars : [
		'brownDwarfLuminosity',
		'brownDwarfMass',
		'brownDwarfTemperature',
		'brownDwarfTypes'
	],
	#category : 'Traveller',
	#package : 'Traveller'
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

{ #category : 'class initialization' }
Star class >> initialize [

	brownDwarfLuminosity := #( 0.00029 0.000066 0.000020 0.0000070
	                           0.00000081 0.000000072 ).
	brownDwarfMass := #( 0.08 0.06 0.05 0.04 0.025 0.013 ).
	brownDwarfTemperature := #( 2400 1850 1300 900 550 300 ).
	brownDwarfTypes := #( 'L' 'T' 'Y' )
]

{ #category : 'as yet unclassified' }
Star class >> newWithType: type subtype: subtype class: class [

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
Star class >> typeOrder [

	^ #( 'O' 'B' 'A' 'F' 'G' 'K' 'M' )
]

{ #category : 'adding' }
Star >> addStar: star [

	stellarBodies add: star.
	star orbiting: self
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

	companion := anObject.
	companion orbiting: self
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

{ #category : 'initialization' }
Star >> initialize [

	stellarBodies := OrderedCollection new
]

{ #category : 'testing' }
Star >> isBrownDwarf [

	^ #( 'BD' 'Y' 'T' 'L' ) includes: stellarType
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

{ #category : 'testing' }
Star >> isPostStellar [

	^ (#( 'D' 'BH' 'NS' 'PSR' ) includes: stellarType)
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

{ #category : 'as yet unclassified' }
Star >> spectralClassification: sc [

	stellarClass := sc spectralClass.
	stellarType := sc spectralType.
	subtype := sc subtype
]

{ #category : 'accessing' }
Star >> stellarBodies [

	^ stellarBodies
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
