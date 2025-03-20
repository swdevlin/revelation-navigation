"
Solar system has a primary star.
"
Class {
	#name : 'SolarSystem',
	#superclass : 'Object',
	#instVars : [
		'sector',
		'x',
		'y',
		'name',
		'primary'
	],
	#category : 'Traveller-WorldBuildersHandbook',
	#package : 'Traveller-WorldBuildersHandbook'
}

{ #category : 'as yet unclassified' }
SolarSystem >> generatePrimary [

	primary := Star generateNew
]

{ #category : 'as yet unclassified' }
SolarSystem >> multipleStarDM [

	| dm |
	dm := 0.

	(#( 'BD' 'D' 'PSR' 'BH' 'NS' ) includes: primary stellarType)
		ifTrue: [ dm := dm - 1 ]
		ifFalse: [
			(#( 'Ia' 'Ib' 'II' 'III' 'IV' ) includes: primary stellarClass)
				ifTrue: [ dm := dm + 1 ].

			(#( 'V' 'VI' ) includes: primary stellarClass) ifTrue: [
				primary stellarType = 'M' ifTrue: [ dm := dm - 1 ].
				(#( 'O' 'B' 'A' 'F' ) includes: primary stellarType) ifTrue: [
					dm := dm + 1 ] ] ].

	^ dm
]

{ #category : 'accessing' }
SolarSystem >> name [

	^ name
]

{ #category : 'accessing' }
SolarSystem >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
SolarSystem >> primary [

	^ primary
]

{ #category : 'accessing' }
SolarSystem >> primary: anObject [

	primary := anObject
]

{ #category : 'accessing' }
SolarSystem >> sector [

	^ sector
]

{ #category : 'accessing' }
SolarSystem >> sector: anObject [

	sector := anObject
]

{ #category : 'accessing' }
SolarSystem >> x [

	^ x
]

{ #category : 'accessing' }
SolarSystem >> x: anObject [

	x := anObject
]

{ #category : 'accessing' }
SolarSystem >> y [

	^ y
]

{ #category : 'accessing' }
SolarSystem >> y: anObject [

	y := anObject
]
