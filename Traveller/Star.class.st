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
		'stellarBodies',
		'isProtoStar'
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

	| star |

	star := self new.
	star
		stellarClass: class;
		subtype: subtype;
		stellarType: type.

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

{ #category : 'initialization' }
Star >> initialize [

	super initialize.
	stellarBodies := SortedCollection sortBlock: [ :a :b |
		                 a orbit < b orbit ].
	isProtoStar := false.
	orbit := 0
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

{ #category : 'testing' }
Star >> isPrimordial [
	"wbh 225"

	(#( 'Ia' #'.' 'Ib' #'.' 'II' )
		includes: (self stellarClass))
		ifTrue: [ ^ true ]
		ifFalse: [ "All stars of Class Ia, Ib and II and all O-type stars
(except O subdwarf stars) are automatically hosts to
primordial systems."
			^ self stellarType = 'O' ]
]

{ #category : 'accessing' }
Star >> isProtoStar [

	^ isProtoStar
]

{ #category : 'accessing' }
Star >> isProtoStar: anObject [

	isProtoStar := anObject
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
